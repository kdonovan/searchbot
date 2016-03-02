class Searchbot::Sources::WebsiteProperties::DetailParser < Searchbot::Generic::DetailParser

  parses :established, :employees, :inventory, :seller_financing, :description

  def established
    info('Year Established')
  end

  def employees
    info('Employees')
  end

  def inventory
    info('Inventory')
  end

  def seller_financing
    info('Seller Financing Available') == 'Yes'
  end

  def description
    base = doc.at('.entry-content').css('div').map do |div|
      txt = div.text.strip
      txt.length > 0 ? txt : nil
    end.compact

    base << description_section('Growth', growth)
    base << description_section('Competition', competition)

    base.join(divider)
  end

  private

  def growth
    doc.at('.growth p').text
  end

  def competition
    doc.at('.competition p').text
  end

  def info(label)
    if node = doc.at('.overview').css('div.label').detect {|n| n.text == label }
      node = node.next until node.name == 'div'
      node.text.strip == 'N/A' ? nil : node.text
    end
  end

end
