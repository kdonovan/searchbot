class Searchbot::Sources::BizBroker24::ListingsPage < Searchbot::Generic::ListingsPage

  def raw_listings
    doc.css('.wpl_prp_cont.row_box.hide-mob-tab')
  end

  def more_pages_available?
    doc.at('li.next a')['href'] != '#'
  end

end
