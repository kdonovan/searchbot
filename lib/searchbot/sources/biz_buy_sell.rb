class Sources::BizBuySell < Sources::Base
  # Note that this site appears to require a known UserAgent.
  #
  BASE_URL = "http://www.bizbuysell.com/listings/handlers/searchresultsredirector.ashx"

  def url_for_page(page = nil)
    params = {
      # State
      s: filters.state_abbrev,

      # Keyword
      k: nil,

      # Asking Price
      pto: filters.max_asking_price,
      pfrom: filters.min_asking_price,

      # Gross Income
      gito: filters.max_revenue,
      gifrom: filters.min_revenue,

      # Cashflow
      cfto: filters.max_cashflow,
      cffrom: filters.min_cashflow,


      hb: nil, # Home based (default: show all)
      bm: nil, # Broker Membership
      bc: nil, # Broker Certification

      sf: nil, # Seller financing (nil/1)
      x: nil,  # Hide listings without prices (nil/1)
      r: nil,  # Show only relocatable listings (nil/1)
      i: nil,  # Business Category

      t: 9, # Posting added within: 9: anytime, 1: 3 days, 2: 7 days, 3: 30 days

      # ?
      ir: 1,
      J: 'bbs',
      tab: 'eb',
      spid: 3,
      A: 1,
    }

    params['pg'] = page unless page.nil?

    [BASE_URL, params.map {|k, v| [k, v].join('=')}.join('&')].join('?')
  end

  def listings_selector(doc)
    doc.css('a[data-listnumber]')
  end

  def more_pages_available?(doc)
    false # TODO implement paging
  end

  def next_page_url(doc)
  end

  def parse_single_result(raw)
    id       = raw['data-listnumber']
    info     = raw.at('.priceBlock')
    price    = info.at('.price') ? str2i( info.at('.price').text ) : nil
    cashflow = info.at('.cflow') ? str2i( info.at('.cflow').text ) : nil

    raise PreviouslySeen if seen.include?(id)

    Result.new(self, {
      id:         id,
      price:      price,
      cashflow:   cashflow,
      link:       URI.join(BASE_URL, raw['href']).to_s,
      title:      raw.at('.title').text,
      teaser:     raw.at('.desc').text,
    })
  end

  def self.parse_result_details(url, doc)
    doc.xpath("//script").remove
    link = url.split('?')[0]
    info = doc.at('.financials')

    info_at = -> (which) { str2i( info.css('p')[which].at('b').text ) }

    # Sometimes miscategorized, so go with the smallest number provided
    cashflow = [info_at[2], info_at[3]].reject {|v| v.zero? }.min

    params = {
      id:   link.split('/').last,
      link: link,

      title:     doc.at('h1').text.strip,
      location:  doc.at('h2.gray').text.strip,

      price:        info_at[0],
      revenue:      info_at[1],
      cashflow:     cashflow,

      ffe:          info_at[4],
      inventory:    info_at[5],

      real_estate:  info_at[6],
      established:  info_at[7],
      employees:    info_at[8],

      description:  parse_desc(doc),

      seller_financing: !!doc.at('#seller-financing'),
    }

    # Note: if needed, could also extract "reason selling"
    DetailResult.new(params)
  end

  def self.parse_desc(doc)
    desc = []
    node = doc.at('#listingActions')

    loop do
      node = node.next
      break if node.nil?
      desc << node.to_html

      break if node['class'] == 'listingProfile_details'
    end

    desc.join("\n\n\n")
  end


end