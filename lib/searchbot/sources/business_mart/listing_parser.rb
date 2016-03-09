class Searchbot::Sources::BusinessMart::ListingParser < Searchbot::Generic::ListingParser

  parses :identifier, :link, :title, :price, :cashflow, :state

  def identifier
    if m = link.match(/bid\/(\d+?)\//)
      m[1]
    end
  end

  def link
    make_absolute title_node['href']
  end

  def title
    title_node.text
  end

  def price
    doc.css('td')[1]
  end

  def cashflow
    doc.css('td')[2]
  end

  def state
    if m = doc.css('td')[3].text.match(/\((\w\w)\)/)
      m[1]
    end
  end

  private

  def title_node
    @title_node ||= doc.at('a')
  end

end
