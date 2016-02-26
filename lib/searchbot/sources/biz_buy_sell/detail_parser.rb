class Searchbot::Sources::BizBuySell::DetailParser < Searchbot::Generic::DetailParser

  def parse
    {
      revenue:        get(1),
      cashflow_from:  [get(2), get(3)],

      ffe:            get(4),
      inventory:      get(5),

      real_estate:    get(6),
      established:    get(7),
      employees:      get(8),

      description:    sane( parse_desc ),

      seller_financing: !!doc.at('#seller-financing'),
    }
  end


  private

  def prepare_doc
    doc.xpath("//script").remove
    doc = doc.at('.financials')
  end

  def get(label)
    doc.css('p')[label].at('b').text
  end

  def parse_desc
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

end