class Searchbot::Sources::BizBuySell::ListingsPage < Searchbot::Generic::ListingsPage

  def listings_selector
    doc.css('a[data-listnumber]')
  end

  def more_pages_available?
    if pager = doc.at('.bbsPager_next')
      pager['href']
    end
  end

end