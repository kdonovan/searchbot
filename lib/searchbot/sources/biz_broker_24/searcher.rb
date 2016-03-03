class Searchbot::Sources::BizBroker24::Searcher < Searchbot::Generic::Searcher

  def base_url
    'http://bizbroker24.com/listings/'
  end

  def url_for_page(page = 1)
    page > 1 ? "#{base_url}?wplpage=#{page}" : base_url
  end

end
