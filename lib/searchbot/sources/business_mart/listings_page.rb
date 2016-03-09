class Searchbot::Sources::BusinessMart::ListingsPage < Searchbot::Generic::ListingsPage

  def raw_listings
    doc.at('table[width="760"]').css('tr').select do |tr|
      tr.at('td.listing_bodycopy') &&
      tr.at('td.listing_bodycopy')['bgcolor'] != '#D9FAB4' # Franchise listings
    end
  end

  def more_pages_available?
    if pages = doc.css('.listing_pagelink .busi_bodycopy strong')
      current, total = pages.map(&:text).map(&:strip).map(&:to_i)
      current <= total
    end
  end

end
