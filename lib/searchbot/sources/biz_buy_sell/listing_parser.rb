class Searchbot::Sources::BizBuySell::ListingParser < Searchbot::Generic::ListingParser

  def parse
    {
      id:         identifier,
      price:      price,
      cashflow:   cashflow,
      link:       link,
      title:      sane( doc.at('.title').text ),
      location:   sane( location ),
      teaser:     sane( doc.at('.desc').text ),
    }
  end

  private

  def link
    base = base = page.searcher.base_url
    URI.join(base_url, doc['href']).to_s
  end

  def identifier
    doc['data-listnumber']
  end

  def info
    doc.at('.priceBlock')
  end

  def price
    info.at('.price')
  end

  def cashflow
    info.at('.cflow')
  end

  def location
    doc.at('.info') && doc.at('.info').text.strip
  end


end