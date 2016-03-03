class Searchbot::Sources::QuietLight::Searcher < Searchbot::Generic::Searcher

  def base_url
    "https://www.quietlightbrokerage.com/listings/"
  end

  def url_for_page(page = nil)
    base_url
  end

end
