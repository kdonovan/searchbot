class Searchbot::Sources::IAcquisitions::DetailParser < Searchbot::Generic::DetailParser

  parses :description, :inventory, :established, :employees

  def description
    doc.at('.left-column p').text.gsub('<br>', divider)
  end

  def inventory
    info 'inventory'
  end

  def established
    info 'established'
  end

  def employees
    info 'employees'
  end

  private

  def info(label_class)
    doc.at(".right-column .#{label_class}").css('+ .data').text
  end

end
