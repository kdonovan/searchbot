class Searchbot::Sources::Latonas::ListingParser < Searchbot::Generic::ListingParser

  parses :identifier, :price, :revenue, :cashflow, :link, :title, :teaser

  def identifier
    link.match(/\/listings\/(.+?)\//)[1]
  end

  def price
    doc.at('.ct-product--price').text
  end

  def revenue
    doc.at('span[title=Revenue]').text
  end

  def cashflow
    doc.at('span[title=Profit]').text
  end

  def title
    doc.at('.ct-product--tilte').text
  end

  def link
    make_absolute doc.at('a')['href']
  end

  def teaser
    doc.at('.ct-product--description p').text
  end

end
