class Searchbot::Sources::AcquisitionsDirect::ListingParser < Searchbot::Generic::ListingParser

  parses :identifier, :title, :link, :teaser

  private

  def identifier
    link.split('/').compact.last
  end

  def title
    sane doc.at('h2').text
  end

  def link
    doc.at('h2 a')['href']
  end

  def teaser
    sane doc.at('.post-content').text
  end

end
