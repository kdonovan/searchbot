class Searchbot::Sources::WebsiteProperties::ListingParser < Searchbot::Generic::ListingParser

  parses :identifier, :link, :title, :price, :cashflow, :revenue, :teaser, :state

  def identifier
    if match = doc.at('.listing-number')&.text&.match(/\((\d+)\)/)
      match[1]
    end
  end

  def link
    title_node['href']
  end

  def title
    title_node.text
  end

  def price
    doc.at('.ask-price span').text
  end

  def cashflow
    li('Cash Flow')
  end

  def revenue
    li('Gross Rev')
  end

  def teaser
    ts = doc.at('.center-panel p')
    ts.css('a').remove
    ts.text
  end

  def state
    if loc = doc.at('.location')
      parse_state loc.text
    end
  end

  private

  def title_node
    @title_node ||= doc.at('h2.post-title a')
  end

  def overview_node
    @overview_node ||= doc.at('ul.overview-detail')
  end

  # e.g. USA, Maryland (Baltimore) or USA, Florida (Broward), so
  # city isn't reliable but we can still usually pull out the state
  def parse_state(txt)
    parts = txt.split(',')

    if parts.first == 'USA'
      parts[1].split('(').first.strip
    end
  end

  def li(label)
    if l = overview_node.css('li').detect {|l| l.text.match(/#{label}/) }
      l.at('span').text
    end
  end

end
