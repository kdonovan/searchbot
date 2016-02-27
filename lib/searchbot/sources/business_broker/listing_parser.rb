class Searchbot::Sources::BusinessBroker::ListingParser < Searchbot::Generic::ListingParser

  def parse
    {
      price:      get('Price'),
      cashflow:   get('CashFlow'),
      revenue:    get('YearlyRevenue'),
      title:      sane( get('Heading') ),
      teaser:     sane( get('Overview') ),
      link:       link,
      id:         get('ListID').to_s,
      city:       sane( get('City') ),
      state:      sane( get('State') ),
    }
  end

  private

  def json
    html # We're passing it as w/ HTML name, but it's JSON from their API
  end

  def get(field)
    json[field] == 'Not Disclosed' ? nil : json[field]
  end

  def link
    base = page.searcher.base_url

    URI.join( base, get('URL') ).to_s
  end

end
