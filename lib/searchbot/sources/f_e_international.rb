class Searchbot::Sources::FEInternational < Searchbot::Sources::Base

  # Typical scraping, no need to pull in second page for detailed view

  BASE_URL = 'http://feinternational.com/buy-a-website/'

  def url_for_page(page = 1)
    raise "FEInternational has a single page of search results" unless page == 1
    BASE_URL
  end

  private

  def listings_selector(doc)
    doc.css('#tabs-1 div.listing')
  end

  def more_pages_available?
    nil
  end

  def single_result_data(raw)
    title_node = raw.at('h2.listing-title a')
    link  = title_node['href']
    id    = link.split('/').last.split('-').first
    desc  = []

    raw.at('.listing-description > p').children.each do |node|
      next unless node.name == 'text'
      next unless node.text.strip.length > 0
      desc << sane( node.text )
    end

    desc = desc.join(self.class.divider)

    {
      id:          id,
      price:       raw.at('.listing-overview-item--asking-price').text,
      revenue:     raw.at('.listing-overview-item--yearly-revenue').text,
      cashflow:    raw.at('.listing-overview-item--yearly-profit').text,
      link:        link,
      title:       sane( title_node.text ),
      teaser:      desc,
    }
  end

  def self.result_details(listing)
    dt = listing.raw.at('article').attributes['data-date'].value
    date = Date.strptime(dt, '%Y%m%d')

    params = listing.to_hash.merge(established: date)
    Searchbot::Results::Details.new( params )
  end

end