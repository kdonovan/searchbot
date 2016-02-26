class Searchbot::Sources::FEInternational::Searcher < Searchbot::Generic::Searcher

  # Typical scraping, no need to pull in second page for detailed view

  BASE_URL = 'http://feinternational.com/buy-a-website/'

  def url_for_page(page = 1)
    raise "FEInternational has a single page of search results" unless page == 1
    BASE_URL
  end

end
