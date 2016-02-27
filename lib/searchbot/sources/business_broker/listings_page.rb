class Searchbot::Sources::BusinessBroker::ListingsPage < Searchbot::Generic::ListingsPage

  def raw_listings
    fetch_json( url, options[:search_params] )['d']
  end

  def more_pages_available?
    false
  end

end
