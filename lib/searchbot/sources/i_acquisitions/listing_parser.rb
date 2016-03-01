class Searchbot::Sources::IAcquisitions::ListingParser < Searchbot::Generic::ListingParser

  parses :identifier, :link, :title, :price, :cashflow, :revenue, :teaser

  def identifier
    link.split('=').last
  end

  def link
    URI.join(page.searcher.base_url, title_node['href']).to_s
  end

  def title
    title_node.text
  end

  def price
    info.at('.blue strong').text
  end

  def cashflow
    info_dd('Net Profit')
  end

  def revenue
    info_dd('Revenue')
  end

  def teaser
    doc.at('.cloud-content p').text.gsub('<br>', divider)
  end

  private

  def title_node
    doc.at('a')
  end

  def info
    doc.at('.info')
  end

  def info_dd(label)
    if dt = info.css('dt').detect{|dt| dt.text == label }
      dt.parent.at('dd').text
    end
  end

end
