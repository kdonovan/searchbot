class Searchbot::Sources::WebsiteClosers::Searcher < Searchbot::Generic::Searcher

  def base_url
    'http://www.websiteclosers.com/websites-for-sale/start/%d/'
  end

  def url_for_page(page = 1)
    base_url % page
  end

end
