class Searchbot::Sources::WebsiteClosers::DetailParser < Searchbot::Generic::DetailParser

  parses :description, :price, :revenue, :established, :employees, :cashflow

  def price;          get('Asking Price')       end
  def revenue;        get('Gross Income')       end
  def established;    get('Year Established')   end
  def employees;      get('Employees')          end
  def cashflow;       get('Cash Flow')          end

  def description
    doc.at('.web_description').text
  end

  private

  def get(label)
    if node = doc.css('.left_side2 div').detect {|n| n.at('strong').text.strip == label}
      node.at('span').text
    end
  end

end
