class Searchbot::Sources::BizQuest::ListingsPage < Searchbot::Generic::ListingsPage

  def listings_selector
    doc.css('#results .result:not(.srfranchise):not(.franchise):not(.broker)')
  end

  def more_pages_available?
    if pager = doc.at('ul.pagination')
      pager.css('li').last['class'] != 'active'
    end
  end

end
