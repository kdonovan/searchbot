class Searchbot::Sources::BizBuySell::ListingParser < Searchbot::Generic::ListingParser

  def parse
    id       = doc['data-listnumber']
    info     = doc.at('.priceBlock')
    price    = info.at('.price')
    cashflow = info.at('.cflow')
    location = doc.at('.info') && doc.at('.info').text.strip

    {
      id:         id,
      price:      price,
      cashflow:   cashflow,
      link:       URI.join(BASE_URL, doc['href']).to_s,
      title:      sane( doc.at('.title').text ),
      location:   sane( location ),
      teaser:     sane( doc.at('.desc').text ),
    }
  end

end