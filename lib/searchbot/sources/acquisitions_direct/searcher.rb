class Searchbot::Sources::AcquisitionsDirect::Searcher < Searchbot::Generic::Searcher

  def base_url
    'http://www.acquisitionsdirect.com/buy/'
  end

  def url_for_page(page = 1)
    raise "AcquisitionsDirect has a single page of search results" unless page == 1
    base_url
  end

end
