class Searchbot::Sources::QuietLight::ListingsPage < Searchbot::Generic::ListingsPage

  def raw_listings
    doc.css('ul.items_list > li').select do |li|
      !li.at('.item_label')
    end
  end

  def more_pages_available?
    false
  end

end
