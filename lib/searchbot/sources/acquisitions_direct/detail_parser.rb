class Searchbot::Sources::AcquisitionsDirect::DetailParser < Searchbot::Generic::DetailParser

  parses :price, :cashflow, :revenue, :employees, :established, :description, :inventory

  def price
    price_text.split('(').first.strip.sub('Asking Price: ', '')
  end

  def cashflow
    # TODO: sometimes contains additional text indicating e.g. only part of a year is included
    li("#{Date.today.year} Profit") || li("#{Date.today.year}Profit") ||
      li("#{Date.today.year - 1} Profit") || li("#{Date.today.year - 1}Profit")
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
    if price_text.include?('plus inventory')
      price_text.split('(').last.split(':').last.sub(/\)/, '').strip
    end
  end


  private

  def li(label)
    return unless strong = doc.css('ul.circle-yes li').detect do |l|
      l.css('strong').text.include? label
    end

    strong.text.split(':').last.split(/[\(–]/).first
  end

  def price_text
    @price_text ||= doc.at('.alert.success .msg strong').text
  end

end
