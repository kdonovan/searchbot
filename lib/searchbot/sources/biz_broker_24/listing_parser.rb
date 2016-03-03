class Searchbot::Sources::BizBroker24::ListingParser < Searchbot::Generic::ListingParser

  parses :identifier, :link, :title, :price, :revenue, :cashflow, :established, :teaser

  def identifier
    link.split('/').last.split('-').first
  end

  def link
    doc.at('a.view_detail')['href']
  end

  def title
    doc.at('h3.wpl_prp_title')
  end

  def price
    get 'Price'
  end

  def revenue
    get 'Income'
  end

  def cashflow
    get 'Cash Flow'
  end

  def established
    get 'Established'
  end

  def teaser
    doc.at('.wpl_prp_desc')
  end

  private

  def get(label)
    node = doc.css('li').detect {|n| n.at('strong')&.text == "#{label}:" }
    node.at('strong').remove
    node.text
  end

end
