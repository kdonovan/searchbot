class Searchbot::Sources::IAcquisitions::ListingParser < Searchbot::Generic::ListingParser

  parses :identifier, :link, :title, :price, :cashflow, :revenue, :teaser

  def identifier
    link.split('=').last
  end

  def link
    make_absolute title_node['href']
  end

  def title
    title_node.text
  end

  def price
    doc.at('.asking-price')
  end

  def cashflow
    info 'Net Profit'
  end

  def revenue
    info 'Revenue'
  end

  def teaser
    doc.at('.subject p').text.gsub('<br>', divider).sub(/Read More$/, '')
  end

  private

  def title_node
    @title_node ||= doc.at('a')
  end

  def info_section
    doc.at('.value')
  end

  def info(label)
    if info_title = info_section.css('.price-title').detect{|l| l.text == label }
      info_title.css('+ .price').text
    end
  end

end
