class Searchbot::Sources::BizBuySell::DetailParser < Searchbot::Generic::DetailParser

  parses :revenue, :cashflow_from, :ffe, :inventory, :established, :description, :seller_financing, :employees

  def cashflow_from; [get(1), get(3)] end
  def revenue; get(2) end
  def ffe; get(4) end
  def inventory; get(5) end
  def established; get(7) end

  def employees
    detail 'Employees'
  end

  def description
    doc.at('.businessDescription').text.strip
  end

  def seller_financing
    !!financials.at('#seller-financing')
  end

  private

  def prepare_doc(raw)
    raw.xpath("//script").remove
    raw.at('.financials').parent
  end

  def financials
    doc.at('.financials')
  end

  def get(label)
    if matched = financials.css('p')[label]
      matched.at('b').text
    end
  end

  def details
    doc.at('dl.listingProfile_details')
  end

  def detail(label)
    return unless details

    if matched = details.css('dt').detect {|dt| dt.text == "#{label}:"}
      matched.at('+ dd').text
    end
  end

end