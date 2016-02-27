class Searchbot::Sources::FEInternational::ListingsPage < Searchbot::Generic::ListingsPage

  def raw_listings
    doc.css('#tabs-1 div.listing')
  end

  def more_pages_available?
    nil
  end

end
