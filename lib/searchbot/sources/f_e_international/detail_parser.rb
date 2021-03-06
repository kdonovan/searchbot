class Searchbot::Sources::FEInternational::DetailParser < Searchbot::Generic::DetailParser

  parses :established, :description

  def established
    dt = doc.at('article').attributes['data-date'].value
    Date.strptime(dt, '%Y%m%d')
  end

  def description
    (doc.css('.main-benefits li').map(&:text) + doc.at('.listing-description p').text.split('<br>')).compact.join(divider)
  end

  private

  # No need to pull in another page - just grab from listing's raw
  def html
    @html ||= listing.raw_listing
  end

end
