class Searchbot::Sources::BizBuySell::ListingParser < Searchbot::Generic::ListingParser

  parses :identifier, :price, :cashflow, :link, :title, :location, :teaser


  def identifier
    doc['data-listnumber']
  end

  def price
    info.at('.price')
  end

  def cashflow
    info.at('.cflow')
  end

  def link
    make_absolute doc['href']
  end

  def title
    doc.at('.title').text
  end

  def location
    doc.at('.info') && doc.at('.info').text.strip
  end

  def teaser
    doc.at('.desc').text
  end

  private

  def info
    doc.at('.priceBlock')
  end

end