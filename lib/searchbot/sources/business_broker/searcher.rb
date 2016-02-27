class Searchbot::Sources::BusinessBroker::Searcher < Searchbot::Generic::Searcher

  # This class actually uses the API directly for the main search results, and only
  # does the "normal" scraping for result details.
  #
  # Note that we can only filter by asking price+location+keywords in the initial search -
  # we have to do the filtering on cashflow, etc. once results have already been retrieved.

  def base_url
    'https://www.businessbroker.net/webservices/dataservice.asmx/getlistingdata'
  end

  # Actually params for page, since we're retrieving via JSON
  def params_for_page(page)
    per_page = 50

    params_for_search.merge({
      startAt: (page - 1) * per_page + 1,
      howMany: per_page
    })
  end

  private

  def listings_page_for(page)
    listings_page.new( url: base_url, searcher: self, options: {search_params: params_for_page(page)} )
  end

  def params_for_search
    {
      strIndId: '0',
      strIndAlias: '',
      regId: 33,
      regParentId: 0,

      askPriceLow: filters.min_price.to_i,
      askPriceHigh: filters.max_price.to_i,
      mapId: map_id_for_state( filters.state_full ),

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

  def state_id_map
    {
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

end
