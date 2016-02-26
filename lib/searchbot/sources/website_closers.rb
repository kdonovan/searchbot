class Searchbot::Sources::WebsiteClosers < Searchbot::Sources::Base

  # Typical scraping

  BASE_URL = 'http://www.websiteclosers.com/websites-for-sale/start/%d/'

  def url_for_page(page = 1)
    BASE_URL % page
  end

  private

  attr_reader :seen_sold_listing

  def listings_selector(doc)
    doc.css('.listing ul')
  end

  def more_pages_available?(doc)
    return false if seen_sold_listing

    if pager = doc.css('.listing > table')
      pager.css('a.link').any? {|l| l.text == 'NEXT'}
    end
  end

  def parse_single_result(raw)
    info = raw.at('.disc_box')
    title_node = info.at('span:first-child a')
    price_node = info.at('span:nth-child(2)')
    cashf_node = info.at('span:nth-child(3)')

    unless price_node.at('strong').text == 'Available'
      @seen_sold_listing = true
      return nil
    end

    link  = title_node['href']
    id    = link.split('/').last

    Searchbot::Results::Listing.new(
      source_klass: self.class,

      id:         id,
      price:      price_node.at('p').text,
      cashflow:   cashf_node.text,
      link:       link,
      title:      sane( title_node.text ),
      teaser:     sane( info.at('> p').text ),
    )
  end

  def self.parse_result_details(listing, doc)
    desc = doc.at('.web_description').text
    info = doc.at('.left_side2')

    parse_info = -> (label) {
      if node = info.css('div').detect {|n| n.at('strong').text.strip == label}
        sane node.at('span').text
      end
    }

    {
      description:    sane( desc ),
      price:          parse_info['Asking Price'],
      revenue:        parse_info['Gross Income'],
      established:    parse_info['Year Established'],
      employees:      parse_info['Employees'],
      cashflow:       parse_info['Cash Flow'],
    }
  end

end