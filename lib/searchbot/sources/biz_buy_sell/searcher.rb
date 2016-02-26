class Searchbot::Sources::BizBuySell::Searcher < Searchbot::Generic::Searcher
  # Note that this site appears to require a known UserAgent.

  BASE_URL = "http://www.bizbuysell.com/listings/handlers/searchresultsredirector.ashx"

  def url_for_page(page = nil)
    params = {
      # State
      s: filters.state_abbrev,

      # Keyword
      k: "#{filters.city} #{filters.keyword}".strip,

      # Asking Price
      pto: filters.max_price,
      pfrom: filters.min_price,

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

end