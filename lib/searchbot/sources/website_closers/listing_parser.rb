class Searchbot::Sources::WebsiteClosers::ListingParser < Searchbot::Generic::ListingParser

  parses :identifier, :price, :cashflow, :link, :title, :teaser

  def before_parse
    return true if price_node.at('strong').text == 'Available'

    page.seen_sold_listing = true
    return nil
  end

  def link;       title_node['href']              end
  def identifier; link.split('/').last            end
  def price;      price_node.at('p').text         end
  def cashflow;   cashf_node.text                 end
  def title;      title_node.text                 end
  def teaser;     doc.at('> p').text              end

  private

  def prepare_doc(raw)
    raw.at('.disc_box')
  end

  def title_node
    doc.at('span:first-child a')
  end

  def price_node
    doc.at('span:nth-child(2)')
  end

  def cashf_node
    doc.at('span:nth-child(3)')
  end

end
