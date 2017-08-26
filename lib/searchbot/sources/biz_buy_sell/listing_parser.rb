class Searchbot::Sources::BizBuySell::ListingParser < Searchbot::Generic::ListingParser

  parses :identifier, :price, :cashflow, :link, :title, :location, :teaser

  def identifier
    doc_root['data-listnumber']
  end

  def price
    info.at('.price')
  end

  def cashflow
    info.at('.cflow')
  end

  def link
    make_absolute doc_root['href']
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

  # Perhaps a version issue, but doc is now wrapped in html/body tags
  def doc_root
    doc['href'].nil? ? doc.at('a') : doc
  end

end