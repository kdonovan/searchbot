class Searchbot::Sources::Latonas::ListingsPage < Searchbot::Generic::ListingsPage

  def raw_listings
    doc.css('table#listing_data tbody tr')
  end

  def more_pages_available?
    nil
  end

end
