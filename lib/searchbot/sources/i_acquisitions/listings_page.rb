class Searchbot::Sources::IAcquisitions::ListingsPage < Searchbot::Generic::ListingsPage

  def raw_listings
    doc.css('ul.item-list > li').select do |li|
      title = li.at('h3').text
      ! title.include?('SOLD') && !title.include?('SALE PENDING')
    end
  end

  def more_pages_available?
    false
  end

end
