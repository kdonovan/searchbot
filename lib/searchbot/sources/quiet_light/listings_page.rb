class Searchbot::Sources::QuietLight::ListingsPage < Searchbot::Generic::ListingsPage

  def raw_listings
    doc.at('ul#works-container').css('li.active')
  end

  def more_pages_available?
    false
  end

end
