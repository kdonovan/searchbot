class Searchbot::Sources::BizQuest < Searchbot::Sources::Base

  BASE_URL = "http://www.bizquest.com/Handlers/SearchRedirector.ashx"

  def url_for_page(page = nil)
    url = redirected_base_search_url
    return url unless page && page.to_i > 1

    url.sub(/-for-sale\//, "-for-sale/page-#{page}/")
  end

  private

  def redirected_base_search_url
    @redirected_base_search_url ||= begin
      params = {
        # Location (e.g. S49 is Washington, R74 is Pacific Region, also have country/country/city w/ custom indexes)
        l: map_id_for_state( filters.state_full ),

        # Asking price
        a2: filters.max_price,
        a1: filters.min_price,

        # Keyword
        k: filters.keyword,

        ka: 0,  # If set to 1, means search ALL, not ANY, keywords
        # kh: 1 # If present, means only search headlines for keyword

        # Revenue
        r2: filters.max_revenue,
        r1: filters.min_revenue,

        # Inventory
        i2: nil,
        i1: nil,

        # Cashflow
        c2: filters.max_cashflow,
        c1: filters.min_cashflow,

        # FFE
        f2: nil,
        f1: nil,

        # Real estate value
        re2: nil,
        re1: nil,

        # Posted within the last n days
        d: 0,

        # Year established
        y1: nil,
        y2: nil,

        po: 1, # hide listings without disclosed asking prices

        # Also accepts many i: arguments with internal codes for industry segments

        o: 2, # This is the magical number for sorting by newest-to-oldest
      }

      url_for_redirection = [BASE_URL, params.map {|k, v| [k, v].join('=')}.join('&')].join('?')
      response = HTTParty.get(url_for_redirection, headers: {'User-Agent' => FIREFOX})

      response.request.last_uri.to_s
    end
  end

  def listings_selector(doc)
    doc.css('#results .result:not(.srfranchise):not(.franchise):not(.broker)')
  end

  def more_pages_available?(doc)
    if pager = doc.at('ul.pagination')
      pager.css('li').last['class'] != 'active'
    end
  end

  def parse_single_result(raw)
    price    = raw.at('.price').at('.asking').text
    cashflow = if general = raw.at('.price').text.scan(/Cash Flow: \$(\S+)/)[0]
      general[0]
    end

    title_node = raw.at('.title a')
    title = title_node.text
    link  = URI.join(BASE_URL, title_node['href']).to_s.split('?')[0]
    id    = link.split('/').last.split('.').first
    desc  = raw.at('.desc').text.sub(/ More info/, '...')

    location = raw.at('.price').css('a').select {|n| n.text != 'View Details' }.reverse.map(&:text).take(2).reverse.compact.join(', ')

    Searchbot::Results::Listing.new(
      source_klass: self.class,
      id:         id,
      price:      price,
      cashflow:   cashflow,
      link:       link,
      title:      sane( title ),
      location:   sane( location ),
      teaser:     sane( desc ),
    )
  end

  def self.parse_result_details(listing, doc)
    info = doc.at('.listingDetail')

    parse_dd_for = -> (dt_text) {
      dt_text += ':' unless dt_text[-1] == ':'
      if node = info.css('dt').detect {|n| n.text.strip == dt_text}
        node = node.next until node.name.upcase == 'DD'
        sane( node.text )
      end
    }

    info_at = -> (label) {
      if node = info.css('b.text-info').detect {|n| n.text.strip == "#{label}:"}
        node = node.next
        node = node.next until node.name.upcase == 'B'
        unless node[:class].include?('no-info')
          val = sane( node.text )
          val =~ /Not Disclosed/ ? nil : val
        end
      end
    }

    # Build the description
    unwanted_dts = ['BizQuest Listing ID:', 'Ad Detail Views:', 'Year Established:', 'Number of Employees:', 'Reason For Selling:']
    desc = [ sane( parse_section_after(info, 'Business Description') ) ]
    info.css('dt').map(&:text).each do |header|
      unless unwanted_dts.include?(header)
        header_display = header == "Market Outlook/\r\n        Competition:" ? 'Market Outlook/Competition:' : header
        desc << ["[#{header_display.sub(/:$/, '')}]: #{sane parse_dd_for[header]}"]
      end
    end

    # See if there's a comment about EBITDA in one of the dt/dd listings
    ebitda = if cf = parse_dd_for['Cash Flow Comments']
      if cf = cf.scan(/ebitda: \$([\d,\.]+)/i)[0]
        cf[0]
      end
    end

    params = {
      id:         listing.id,
      link:       listing.link,
      location:   listing.location,
      title:      listing.title,


      price:          info_at['Asking Price'],
      revenue:        info_at['Gross Revenue'],

      ffe:            info_at['FF&E'],
      inventory:      info_at['Inventory'],

      established:    parse_dd_for['Year Established'],
      employees:      parse_dd_for['Number of Employees'],
      reason_selling: parse_dd_for['Reason For Selling'],

      description:    desc.join(divider),

      seller_financing: !!parse_dd_for['Seller Financing'],
    }.tap do |params|
      if ebitda
        params[:cashflow_from] = [info_at['Cash Flow'], ebitda]
      else
        params[:cashflow] = info_at['Cash Flow']
      end
    end
  end

  def self.parse_section_after(doc, h3_text)
    return unless node = doc.css('h3').detect {|n| n.text == h3_text}
    sections = []

    loop do 
      node = node.next
      break if node.nil? || %w(H3 A).include?(node.name.upcase)
      next if %w(A SCRIPT BR).include?(node.name.upcase)
      sections << node.text if node.text.strip.length > 0
    end

    sections.join(divider).strip
  end

  private

  def state_id_map
    {
      "Alabama" => "S2",
      "Alaska" => "S3",
      "Arizona" => "S4",
      "Arkansas" => "S5",
      "California" => "S6",
      "Colorado" => "S7",
      "Connecticut" => "S8",
      "Delaware" => "S9",
      "Florida" => "S11",
      "Georgia" => "S12",
      "Hawaii" => "S13",
      "Idaho" => "S14",
      "Illinois" => "S15",
      "Indiana" => "S16",
      "Iowa" => "S17",
      "Kansas" => "S18",
      "Kentucky" => "S19",
      "Louisiana" => "S20",
      "Maine" => "S21",
      "Maryland" => "S22",
      "Massachusetts" => "S23",
      "Michigan" => "S24",
      "Minnesota" => "S25",
      "Mississippi" => "S26",
      "Missouri" => "S27",
      "Montana" => "S28",
      "Nebraska" => "S29",
      "Nevada" => "S30",
      "New Hampshire" => "S31",
      "New Jersey" => "S32",
      "New Mexico" => "S33",
      "New York" => "S34",
      "North Carolina" => "S35",
      "North Dakota" => "S36",
      "Ohio" => "S37",
      "Oklahoma" => "S38",
      "Oregon" => "S39",
      "Pennsylvania" => "S40",
      "Rhode Island" => "S41",
      "South Carolina" => "S42",
      "South Dakota" => "S43",
      "Tennessee" => "S44",
      "Texas" => "S45",
      "Utah" => "S46",
      "Vermont" => "S47",
      "Virginia" => "S48",
      "Washington" => "S49",
      "Washington DC" => "S10",
      "West Virginia" => "S50",
      "Wisconsin" => "S51",
      "Wyoming" => "S52",
    }
  end

end
__END__

Searchbot::Sources::BizQuest.new(min_price: 240_000, max_price: 260_000, state: 'Washington', city: 'Seattle').results.first