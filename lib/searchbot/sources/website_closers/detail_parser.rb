class Searchbot::Sources::WebsiteClosers::DetailParser < Searchbot::Generic::DetailParser

  def parse
    desc = doc.at('.web_description').text

    {
      description:    sane( desc ),
      price:          get('Asking Price'),
      revenue:        get('Gross Income'),
      established:    get('Year Established'),
      employees:      get('Employees'),
      cashflow:       get('Cash Flow'),
    }
  end

  private

  def get(label)
    if node = doc.css('.left_side2 div').detect {|n| n.at('strong').text.strip == label}
      sane node.at('span').text
    end
  end

end
