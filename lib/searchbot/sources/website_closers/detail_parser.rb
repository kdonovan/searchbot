class Searchbot::Sources::WebsiteClosers::DetailParser < Searchbot::Generic::DetailParser

  def parse
    {
      description:    description,
      price:          get('Asking Price'),
      revenue:        get('Gross Income'),
      established:    get('Year Established'),
      employees:      get('Employees'),
      cashflow:       get('Cash Flow'),
    }
  end

  private

  def description
    sane doc.at('.web_description').text
  end

  def get(label)
    if node = doc.css('.left_side2 div').detect {|n| n.at('strong').text.strip == label}
      sane node.at('span').text
    end
  end

end
