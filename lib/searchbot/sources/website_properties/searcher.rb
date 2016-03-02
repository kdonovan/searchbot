class Searchbot::Sources::WebsiteProperties::Searcher < Searchbot::Generic::Searcher

  def base_url
    'http://websiteproperties.com/websites-for-sale/'
  end

  def url_for_page(page = nil)
    page.to_i > 1 ? "#{base_url}?num=#{page-1}" : base_url
  end

end
