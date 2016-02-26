class Searchbot::Sources::WebsiteClosers::ListingParser < Searchbot::Generic::ListingParser

  attr_reader :seen_sold_listing

  def parse
    info = doc.at('.disc_box')
    title_node = info.at('span:first-child a')
    price_node = info.at('span:nth-child(2)')
    cashf_node = info.at('span:nth-child(3)')

    unless price_node.at('strong').text == 'Available'
      context.seen_sold_listing = true
      return nil
    end

    link  = title_node['href']
    id    = link.split('/').last

    {
      id:         id,
      price:      price_node.at('p').text,
      cashflow:   cashf_node.text,
      link:       link,
      title:      sane( title_node.text ),
      teaser:     sane( info.at('> p').text ),
    }
  end

end
