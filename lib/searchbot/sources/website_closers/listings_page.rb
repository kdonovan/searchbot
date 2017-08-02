class Searchbot::Sources::WebsiteClosers::ListingsPage < Searchbot::Generic::ListingsPage

  attr_accessor :seen_sold_listing

  def raw_listings
    doc.css('form#website li')
  end

  def more_pages_available?
    return false if seen_sold_listing

    if pager = doc.css('.listing > table')
      pager.css('a.link').any? {|l| l.text == 'NEXT'}
    end
  end

end
