class Searchbot::Sources::Latonas::ListingsPage < Searchbot::Generic::ListingsPage

  def raw_listings
    doc.css('.ct-itemProducts')
  end

  def more_pages_available?
    nil
  end

end
