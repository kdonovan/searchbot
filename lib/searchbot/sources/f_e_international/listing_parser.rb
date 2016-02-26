class Searchbot::Sources::FEInternational::ListingParser < Searchbot::Generic::ListingParser

  def parse
    {
      id:          identifier,
      price:       doc.at('.listing-overview-item--asking-price').text,
      revenue:     doc.at('.listing-overview-item--yearly-revenue').text,
      cashflow:    doc.at('.listing-overview-item--yearly-profit').text,
      link:        link,
      title:       sane( title_node.text ),
      teaser:      description,
    }
  end

  private

  def title_node
    @title_node ||= doc.at('h2.listing-title a')
  end

  def link
    title_node['href']
  end

  def identifier
    link.split('/').last.split('-').first
  end

  def description
    desc  = []

    doc.at('.listing-description > p').children.each do |node|
      next unless node.name == 'text'
      next unless node.text.strip.length > 0
      desc << sane( node.text )
    end

    desc.join(divider)
  end

end
