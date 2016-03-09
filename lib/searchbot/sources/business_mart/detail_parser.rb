class Searchbot::Sources::BusinessMart::DetailParser < Searchbot::Generic::DetailParser

  parses :revenue, :ffe, :inventory, :established, :employees, :seller_financing, :reason_selling, :description

  def revenue
    doc.css('td.busi_bodycopy')[1]
  end

  def ffe
    get 'Furniture and Fixtures Value'
  end

  def inventory
    get 'Inventory Value'
  end

  def established
    get 'Year Business was Established'
  end

  def employees
    get 'Number of Employees'
  end

  def seller_financing
    if sf = get('Owner willing to finance')
      !sf.match(/n\/?a/i)
    end
  end

  def reason_selling
    get 'Reason for selling'
  end

  def description
    doc.at('td.busi_headline p .busi_bodycopy')
  end

  private

  def get(label)
    label = "#{label}:" unless label[-1] == ':'

    if node = doc.css('span.busi_headline').detect {|n| n.text.gsub(/\s{2,}/, ' ').match(/#{label}/)}
      if node.parent.name == 'td'
        node.parent.text.split(label).last
      else
        node.parent.at('.busi_bodycopy')
      end
    end
  end

end
