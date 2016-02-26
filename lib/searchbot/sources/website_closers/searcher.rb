class Searchbot::Sources::WebsiteClosers::Searcher < Searchbot::Generic::Searcher

  BASE_URL = 'http://www.websiteclosers.com/websites-for-sale/start/%d/'

  def url_for_page(page = 1)
    BASE_URL % page
  end

end
