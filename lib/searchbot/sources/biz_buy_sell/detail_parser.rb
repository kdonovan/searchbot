class Searchbot::Sources::BizBuySell::DetailParser < Searchbot::Generic::DetailParser

  parses :revenue, :cashflow_from, :ffe, :inventory, :real_estate, :established, :employees, :description, :seller_financing

  def revenue; get(1) end
  def cashflow_from; [get(2), get(3)] end
  def ffe; get(4) end
  def inventory; get(5) end
  def real_estate; get(6) end
  def established; get(7) end
  def employees; get(8) end

  def description
    desc = []
    node = doc.at('#listingActions')

    loop do
      node = node.next
      break if node.nil?
      desc << node.to_html

      break if node['class'] == 'listingProfile_details'
    end

    desc.join( divider )
  end

  def seller_financing
    !!doc.at('#seller-financing')
  end


  private

  def prepare_doc(raw)
    raw.xpath("//script").remove
    raw.at('.financials')
  end

  def get(label)
    doc.css('p')[label].at('b').text
  end

end