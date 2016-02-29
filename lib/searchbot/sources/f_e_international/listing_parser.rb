class Searchbot::Sources::FEInternational::ListingParser < Searchbot::Generic::ListingParser

  parses :identifier, :price, :revenue, :cashflow, :link, :title, :teaser

  def price;       doc.at('.listing-overview-item--asking-price').text end
  def revenue;     doc.at('.listing-overview-item--yearly-revenue').text end
  def cashflow;    doc.at('.listing-overview-item--yearly-profit').text end
  def title;       sane( title_node.text ) end

  def identifier
    link.split('/').last.split('-').first
  end

  def link
    title_node['href']
  end

  def teaser
    desc  = []

    doc.at('.listing-description > p').children.each do |node|
      next unless node.name == 'text'
      next unless node.text.strip.length > 0
      desc << sane( node.text )
    end

    desc.join(divider)
  end

  private

  def title_node
    @title_node ||= doc.at('h2.listing-title a')
  end

end
