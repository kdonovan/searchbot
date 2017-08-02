class Searchbot::Sources::WebsiteClosers::ListingParser < Searchbot::Generic::ListingParser

  parses :identifier, :price, :cashflow, :link, :title, :teaser

  def before_parse
    return true if title_node.at('span.avail')

    page.seen_sold_listing = true
    return nil
  end

  def link;       title_node['href']                  end
  def identifier; link.split('/').last                end
  def price;      price_node.children.last.text       end
  def cashflow;   cashf_node.children.last.text       end
  def title;      title_node.text                     end
  def teaser;     doc.at('p').text                    end

  private

  def title_node
    doc.at('span:first-child a')
  end

  def price_node
    doc.at('span.asking-price')
  end

  def cashf_node
    doc.at('span.cach-flow-price')
  end

end
