class Searchbot::Sources::QuietLight::ListingParser < Searchbot::Generic::ListingParser

  parses :identifier, :link, :title, :price, :revenue, :cashflow, :teaser

  def identifier
    link.match(/listings\/(\d+)/)[0]
  end

  def link
    doc.at('a')['href']
  end

  def title
    doc.at('h5')
  end

  def price
    doc.at('.bottom_info .line_1 span')
  end

  def revenue
    info 'Revenue'
  end

  def cashflow
    info 'Income'
  end

  def teaser
    doc.at('p')
  end

  private

  def info(label)
    if para = doc.css(".line_2 p").detect {|para| para.text =~ /#{label}/ }
      para.text.split(':').last
    end
  end

end
