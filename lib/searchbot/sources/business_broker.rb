class Sources::BusinessBroker < Sources::Base

  BASE_URL = "https://www.businessbroker.net/listings/bfs_result.aspx"

  def url_for_page(page = nil)
    params = {
      by: 'advancedsearch',

      map_id: map_id_for_state( filters.state ),

      ask_price_l: filters.min_asking_price,
      ask_price_h: filters.max_asking_price,

      # City name
      lcity: nil,

      # Keyword search
      keyword: nil,

      # Specific listing number
      lst_no: nil,

      # Listed within the last n days
      time: 0,

      # Owner Finance Only
      ownerfi: 0,

      # County ID
      county_id: 0,

      # ?
      bprice: 1,
      fresale: 0,
      r_id: 33,
      ind_id: 0,
    }

    params['pg'] = page unless page.nil?

    [BASE_URL, params.map {|k, v| [k, v].join('=')}.join('&')].join('?')
  end

  def listings_selector(doc)
    doc.css('.listing-row')
  end

  def more_pages_available?(doc)
    doc.at('.pagination').css('a').detect {|l| l.text == 'Next Page >' }
  end

  def parse_single_result(raw)
    finance = raw.at('.listing-item-financials')
    title   = raw.at('.listing-text-title')
    link    = title.at('a')['href']
    teaser  = raw.at('.listing-item-desc').css('div').last.text
    id      = self.class.id_from_url(link)

    raise PreviouslySeen if seen.include?(id)

    Result.new(self, {
      price:      str2i( finance.css('.financial-text-top')[1].text ),
      cashflow:   str2i( finance.css('.financial-text')[1].text ),
      revenue:    str2i( finance.css('.financial-text')[3].text ),
      title:      title.text,
      teaser:     teaser,
      link:       link,
      id:         id,
    })
  end

  def self.id_from_url(url)
    url.split('/').last.split('.').first
  end

  def self.parse_result_details(url, doc)
    info = doc.at('#details-bfs').at('.info')

    string_at = -> (path) { doc.at("##{path}").text }
    number_at = -> (path) { str2i( string_at[path] ) }

    # Sometimes miscategorized, so go with the smallest number provided
    cashflow = ['lblycflow', 'lblynprofit'].map {|key| number_at[key] }.reject {|v| v.zero? }.min

    desc = [
      "Business Overview: #{string_at['lbloverview']}",
      "Property Features: #{string_at['lblfeatures']}",
      "Market Competition and Expansion: #{string_at['lbloverview']}",
    ].join("\n\n\n")

    DetailResult.new({
      id:   id_from_url(url),
      link: url,

      title:     doc.at('h2.title').text,
      location:  doc.at('h2.location').text,

      price:        number_at['lblPrice'],
      revenue:      number_at['lblyrevenue'],
      cashflow:     cashflow,

      ffe:          number_at['lblFFE'],
      real_estate:  number_at['lblRealEstate'],
      employees:    number_at['lblemploy'],
      established:  number_at['lblYest'],

      seller_financing: !!doc.at('#divOwnerFinancing'),
      reason_selling:   string_at['lblreason'],

      description:  desc,
    })
  end

  def map_id_for_state(state)
    mapping = {
      "Alabama" => 9,
      "Alaska" => 8,
      "Arizona" => 11,
      "Arkansas" => 10,
      "California" => 12,
      "Colorado" => 13,
      "Confidential" => 65,
      "Connecticut" => 14,
      "Delaware" => 15,
      "District of Columbia" => 59,
      "Florida" => 16,
      "Georgia" => 17,
      "Hawaii" => 18,
      "Idaho" => 20,
      "Illinois" => 21,
      "Indiana" => 22,
      "Iowa" => 19,
      "Kansas" => 23,
      "Kentucky" => 25,
      "Louisiana" => 26,
      "Maine" => 29,
      "Maryland" => 28,
      "Massachusetts" => 27,
      "Michigan" => 30,
      "Minnesota" => 31,
      "Mississippi" => 33,
      "Missouri" => 32,
      "Montana" => 34,
      "Nebraska" => 37,
      "Nevada" => 41,
      "New Hampshire" => 38,
      "New Jersey" => 39,
      "New Mexico" => 40,
      "New York" => 42,
      "North Carolina" => 35,
      "North Dakota" => 36,
      "Ohio" => 43,
      "Oklahoma" => 44,
      "Oregon" => 45,
      "Pennsylvania" => 46,
      "Puerto Rico" => 60,
      "Rhode Island" => 47,
      "South Carolina" => 48,
      "South Dakota" => 49,
      "Tennessee" => 50,
      "Texas" => 51,
      "Utah" => 52,
      "Vermont" => 54,
      "Virgin Islands" => 61,
      "Virginia" => 53,
      "Washington" => 55,
      "West Virginia" => 57,
      "Wisconsin" => 56,
      "Wyoming" => 58,
    }

    mapping[state] || 0
  end

end