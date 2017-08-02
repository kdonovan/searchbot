class Searchbot::Sources::AcquisitionsDirect::ListingsPage < Searchbot::Generic::ListingsPage

  def raw_listings
    doc.css(".portfolio-item:not(.sold):not(.under-loi)").select do |l|
      !l.at('h2').text.include?('(Coming Soon)')
    end
  end

  def more_pages_available?
    false
  end

end
