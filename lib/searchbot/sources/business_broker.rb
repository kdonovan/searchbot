class Searchbot::Sources::BusinessBroker < Searchbot::Sources::Base
  # This class actually uses the API directly for the main search results, and only
  # does the "normal" scraping for result details.
  #
  # Note that we can only filter by asking price+location+keywords in the initial search -
  # we have to do the filtering on cashflow, etc. once results have already been retrieved.

  BASE_URL = 'https://www.businessbroker.net/webservices/dataservice.asmx/getlistingdata'

  private

    def params_for_search
      {
        strIndId: '0',
        strIndAlias: '',
        regId: 33,
        regParentId: 0,

        askPriceLow: filters.min_price.to_i,
        askPriceHigh: filters.max_price.to_i,
        mapId: map_id_for_state( filters.state ),

        strCity: filters.city,
        strKeyword: filters.keyword,

        timeFrame: 0,   # Listing within last n days
        noPrice: 1,     # 1 = do NOT show listings without asking price, 0 = show them
        franchiseResale: 0,
        ownerFinancing: 0,
        countyId: 0,
        strListedOnDate: '',
        sortBy: 'l.flisting DESC, l.ldate DESC', # Newest to oldest
      }
    end

    def params_for_page(page)
      per_page = 50

      params_for_search.merge({
        startAt: (page - 1) * per_page + 1,
        howMany: per_page
      })
    end

    def request_headers
      {'User-Agent' => FIREFOX, 'Content-Type' => 'application/json; charset=UTF-8'}
    end

    def parse_data_for_page(page)
      request = HTTParty.post(
        BASE_URL,
        headers: request_headers,
        body: params_for_page(page).to_json
      )

      JSON.parse( request.body )['d'].map do |json|
        parse_single_listing(json)
      end.select do |result|
        result.passes_filters?(filters)
      end
    end

    def parse_single_listing(json)
      get = -> (field) {
        json[field] == 'Not Disclosed' ? nil : json[field]
      }

      teaser = get['Overview'].strip
      teaser.downcase! if teaser == teaser.upcase

      Searchbot::Results::Listing.new(
        source_klass: self.class,
        price:      get['Price'],
        cashflow:   get['CashFlow'],
        revenue:    get['YearlyRevenue'],
        title:      get['Heading'],
        teaser:     teaser,
        link:       URI.join( BASE_URL, get['URL'] ).to_s,
        id:         get['ListID'].to_s,
        city:       get['City'],
        state:      get['State'],
      )
    end

    def retrieve_results
      @results = []
      more_pages = true
      curr_page = 1

      while more_pages do
        prev_length = @results.length

        begin
          @results += parse_data_for_page(curr_page)
        rescue PreviouslySeen
          break
        end

        more_pages = @results.length > prev_length
        curr_page += 1
        break if max_pages && curr_page > max_pages
      end
    end

    def map_id_for_state(state)
      STATE_ID_MAP[state] || 0
    end

    def self.parse_result_details(listing, doc)
      get = -> (path) {
        if doc.at("##{path}")
          raw = doc.at("##{path}").text
          raw.downcase! if raw == raw.upcase
          raw
        end
      }

      desc = [
        "Business Overview: #{get['lbloverview']}",
        "Property Features: #{get['lblfeatures']}",
      ].join("\n\n\n").strip

      {
        description:    desc,
        cashflow_from:  [get['lblycflow'], get['lblynprofit']],

        ffe:            get['lblFFE'],
        real_estate:    get['lblRealEstate'],
        employees:      get['lblemploy'],
        established:    get['lblYest'],

        seller_financing: !!doc.at('#divOwnerFinancing'),
        reason_selling:   get['lblreason'],
      }
    end

    STATE_ID_MAP = {
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

end
