class Searchbot::Sources::FEInternational::ListingsPage < Searchbot::Generic::ListingsPage

  def listings_selector
    doc.css('#tabs-1 div.listing')
  end

  def more_pages_available?
    nil
  end

end
