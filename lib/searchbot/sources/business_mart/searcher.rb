class Searchbot::Sources::BusinessMart::Searcher < Searchbot::Generic::Searcher

  searchable_filters :keyword, :city, :state, :max_price


  def base_url
    'http://www.businessmart.com/businesses-for-sale.php'
  end

  def url_for_page(page = nil)
    params = if page.to_i > 1
      params_for_subsequent_page(page)
    else
      params_for_search
    end

    generate_url(params: params)
  end

  private

  # I don't make the crazy rules, I just see and replicate them...
  def price_for_search
    return 0 unless filters.max_price

    bands = [1..100_000, 100_000..250_000, 250_000..500_000, 500_000..1_000_000]

    bands.each do |band|
      if band.include?(filters.max_price)
        if filters.min_price.nil? || band.include?(filters.min_price)
          return band.last / 1_000
        end
      end
    end

    if filters.max_price > 1_000_000 && (filters.min_price.nil? || filters.min_price > 1_000_000)
      return 9
    end

    0
  end

  def params_for_search
    {
      # Price is broken into strange custom chunks
      price: price_for_search,

      # Show businesses listed: 0 = any time, otherwise n = days ago (UI offers 7, 30, 60, 90)
      tslist: 0,

      # Location
      'bloc[]': filters.state_full ? map_id_for_state( filters.state_full ) : nil,

      kw: [filters.keyword, filters.city].compact.join(' '),

      # anykw = any keyword (default). allkw = all keywords.
      any: filters.keyword || filters.city ? 'allkw' : 'anykw',

      'Submit.x': submit_x,
      'Submit.y': submit_y,
      Submit: 'Search',
    }.select {|k,v| v }
  end

  def submit_x
    rand(85)
  end

  def submit_y
    rand(23)
  end

  def params_for_subsequent_pages(page)
    offset = 10 * page
    base   = params_for_search

    {
      ascdesc: nil,
      headcol: nil,
      owner: nil,
      offset: offset,
      bloc: base[:'bloc[]'] || '%',
      pricat: '%',
      price: base[:price],
      tslist: base[:tslist],
      any: base[:any],
      onelist: nil,
      kw: base[:kw],
    }
  end

  def state_id_map
    {
      'Alabama' => 1,
      'Alaska' => 2,
      'Arizona' => 3,
      'Arkansas' => 4,
      'California' => 5,
      'Colorado' => 6,
      'Connecticut' => 7,
      'Delaware' => 8,
      'District of Columbia' => 9,
      'Florida' => 10,
      'Georgia' => 11,
      'Hawaii' => 12,
      'Idaho' => 13,
      'Illinois' => 14,
      'Indiana' => 15,
      'Iowa' => 16,
      'Kansas' => 17,
      'Kentucky' => 18,
      'Louisiana' => 19,
      'Maine' => 20,
      'Maryland' => 21,
      'Massachusetts' => 22,
      'Michigan' => 23,
      'Minnesota' => 24,
      'Mississippi' => 25,
      'Missouri' => 26,
      'Montana' => 27,
      'Nebraska' => 28,
      'Nevada' => 29,
      'New Hampshire' => 30,
      'New Jersey' => 31,
      'New Mexico' => 32,
      'New York' => 33,
      'North Carolina' => 34,
      'North Dakota' => 35,
      'Ohio' => 36,
      'Oklahoma' => 37,
      'Oregon' => 38,
      'Pennsylvania' => 39,
      'Rhode Island' => 40,
      'South Carolina' => 41,
      'South Dakota' => 42,
      'Tennessee' => 43,
      'Texas' => 44,
      'Utah' => 45,
      'Vermont' => 46,
      'Virginia' => 47,
      'Washington' => 48,
      'West Virginia' => 49,
      'Wisconsin' => 50,
      'Wyoming' => 51,
    }
    # 'INTERNET/E-COMMERCE' => 53,
  end

end
