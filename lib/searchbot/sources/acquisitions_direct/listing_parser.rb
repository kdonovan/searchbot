class Searchbot::Sources::AcquisitionsDirect::ListingParser < Searchbot::Generic::ListingParser

  parses :identifier, :title, :link, :teaser

  def identifier
    link.split('/').compact.last
  end

  def title
    doc.at('h2').text
  end

  def link
    doc.at('h2 a')['href']
  end

  def teaser
    doc.at('.post-content').text
  end

end
