class Searchbot::Sources::BizQuest::ListingParser < Searchbot::Generic::ListingParser

  def parse
    {
      id:         identifier,
      price:      price,
      cashflow:   cashflow,
      link:       link,
      title:      sane( title_node.text ),
      location:   sane( location ),
      teaser:     sane( description ),
    }
  end

  private

  def price
    doc.at('.price').at('.asking').text
  end

  def cashflow
    if general = doc.at('.price').text.scan(/Cash Flow: \$(\S+)/)[0]
      general[0]
    end
  end

  def title_node
    @title_node ||= doc.at('.title a')
  end

  def link
    @link ||= begin
      base = page.searcher.redirected_base_search_url
      relative = title_node['href']
      absolute = URI.join(base, relative)
      absolute.to_s.split('?')[0]
    end
  end

  def identifier
    link.split('/').last.split('.').first
  end

  def description
    doc.at('.desc').text.sub(/ More info/, '...')
  end

  def location
    doc.at('.price').css('a').select do |n|
      n.text != 'View Details'
    end.reverse.map(&:text).take(2).reverse.compact.join(', ')
  end

end
