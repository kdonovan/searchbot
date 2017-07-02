class Searchbot::Sources::AcquisitionsDirect::DetailParser < Searchbot::Generic::DetailParser

  parses :price, :cashflow, :revenue, :employees, :established, :description, :inventory

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
    doc.at('.project-description p').text
  end

  def inventory
    if price_text.match(/\(plus inventory/)
      price_text.split('(').last
    end
  end


  private

  def li(label)
    return unless strong = doc.css('ul.circle-yes li').detect do |l|
      l.css('strong').any? {|s| [label, "#{label}:"].include?(s.text) }
    end

    strong.text.split("#{label}:").last.split(' (').first
  end

  def price_text
    @price_text ||= doc.at('.alert.success .msg strong').text
  end

end
