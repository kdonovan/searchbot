class Searchbot::Sources::EmpireFlippers::Searcher < Searchbot::Generic::Searcher

  # This class actually pulls JSON from the HTML PAGE, then applies
  # the filters to the returned items.

  def base_url
    'https://empireflippers.com/marketplace/'
  end

  def url_for_page(page = nil)
    base_url
  end

  def listings
    # Simulate only taking a few pages in testing, so we don't grab details on every listing
    max_pages ? super.take(max_pages * 20) : super
  end

end
