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
    doc.at('.asking-value')
  end

  def revenue
    get('revenue-meta')
  end

  def cashflow
    get('revenue-income')
  end

  def teaser
    doc.at('p')
  end

  private

  def get(css_class)
    doc.at(".#{css_class}").text.split(':').last
  end

end
