class Searchbot::Sources::FEInternational::Searcher < Searchbot::Generic::Searcher

  # Typical scraping, no need to pull in second page for detailed view

  def base_url
    'http://feinternational.com/buy-a-website/'
  end

  def url_for_page(page = 1)
    raise "FEInternational has a single page of search results" unless page == 1
    base_url
  end

end
