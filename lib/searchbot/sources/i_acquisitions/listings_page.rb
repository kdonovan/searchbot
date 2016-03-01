class Searchbot::Sources::IAcquisitions::ListingsPage < Searchbot::Generic::ListingsPage

  def raw_listings
    doc.css('.buy-cloud').select do |div|
      title = div.at('a').text
      ! title[/SOLD/] && ! title[/SALE PENDING/]
    end
  end

  def more_pages_available?
    false
  end

end
