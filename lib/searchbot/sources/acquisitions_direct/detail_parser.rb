class Searchbot::Sources::AcquisitionsDirect::DetailParser < Searchbot::Generic::DetailParser

  parses :price, :cashflow, :revenue, :employees, :established, :description, :inventory

  private

  def li(label)
    strong = doc.at('ul.circle-yes').css('li').detect do |l|
      l.css('strong').any? {|s| s.text == label }
    end

    if strong
      strong.next.text
    end
  end

  def price_text
    @price_text ||= doc.at('.alert.success .msg strong').text
  end

  def price
    price_text.split('(').first.strip
  end

  def cashflow
    li('Profit')
  end

  def revenue
    li('Revenue')
  end

  def employees
    li('Employees')
  end

  def established
    li('Years Established')
  end

  def description
    sane doc.at('.project-description p').text
  end

  def inventory
    if price_text.match(/\(plus inventory/)
      price_text.split('(').last
    end
  end

end
