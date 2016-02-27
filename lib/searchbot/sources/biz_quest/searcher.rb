class Searchbot::Sources::BizQuest::Searcher < Searchbot::Generic::Searcher

  BASE_URL = "http://www.bizquest.com/Handlers/SearchRedirector.ashx"

  def url_for_page(page = nil)
    url = redirected_base_search_url
    return url unless page && page.to_i > 1

    url.sub(/-for-sale\//, "-for-sale/page-#{page}/")
  end

  searchable_filters :keyword, :state, :max_price, :min_price, :max_revenue, :min_revenue, :max_cashflow, :min_cashflow

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
      response = HTTParty.get(url_for_redirection, headers: headers)

      response.request.last_uri.to_s
    end
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
