class Searchbot::Sources::BizQuest::ListingParser < Searchbot::Generic::ListingParser

  parses :identifier, :price, :cashflow, :link, :title, :location, :teaser

  def identifier
    link.split('/').last.split('.').first
  end

  def price
    doc.at('.price').at('.asking').text
  end

  def cashflow
    if general = doc.at('.price').text.scan(/Cash Flow: \$(\S+)/)[0]
      general[0]
    end
  end

  def link
    @link ||= begin
      relative = title_node['href']
      absolute = make_absolute(relative, base: page.searcher.redirected_base_search_url)
      absolute.to_s.split('?')[0]
    end
  end

  def title
    title_node.text
  end

  def location
    doc.at('.price').css('a').select do |n|
      n.text != 'View Details'
    end.reverse.map(&:text).take(2).reverse.compact.join(', ')
  end

  def teaser
    doc.at('.desc').text.sub(/ More info/, '...')
  end

  private

  def title_node
    @title_node ||= doc.at('.title a')
  end

end
