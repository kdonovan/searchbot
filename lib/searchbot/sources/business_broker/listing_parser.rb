class Searchbot::Sources::BusinessBroker::ListingParser < Searchbot::Generic::ListingParser

  parses :identifier, :price, :cashflow, :revenue, :title, :teaser, :link, :city, :state

  def price;      get('Price') end
  def cashflow;   get('CashFlow') end
  def revenue;    get('YearlyRevenue') end
  def title;      get('Heading') end
  def teaser;     get('Overview') end
  def identifier; get('ListID').to_s end
  def city;       get('City') end
  def state;      get('State') end

  def link
    make_absolute get('URL')
  end


  private

  def json
    html # We're passing it as w/ HTML name, but it's JSON from their API
  end

  def get(field)
    json[field] == 'Not Disclosed' ? nil : json[field]
  end

end
