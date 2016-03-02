class Searchbot::Sources::WebsiteProperties::ListingsPage < Searchbot::Generic::ListingsPage

  def raw_listings
    doc.css('article.type-page')
  end

  def more_pages_available?
    next_classes = doc.css('.pagination .nav-left span').last['class'].split(' ')

    ! next_classes.any? {|c| c == 'inactive' }
  end

end
