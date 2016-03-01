class Searchbot::Sources::IAcquisitions::Searcher < Searchbot::Generic::Searcher

  def base_url
    'http://www.iacquisitions.com/website-brokerage-listings.php'
  end

  def url_for_page(page = nil)
    base_url
  end

end
