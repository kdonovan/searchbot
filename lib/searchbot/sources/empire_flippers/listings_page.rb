class Searchbot::Sources::EmpireFlippers::ListingsPage < Searchbot::Generic::ListingsPage

  def raw_listings
    section = html.match(/window.efMarketplaceList = (.+?);\s*<\/script>/)
    JSON.parse(section[1]).select {|r| r['listing_status'] == 'for_sale' }
  end

  def more_pages_available?
    false
  end

end
