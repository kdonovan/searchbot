class Searchbot::Sources::Latonas::DetailParser < Searchbot::Generic::DetailParser

  # Note: lots more custom stats we could pull in if desired. And graphs!
  parses :description, :business_url, :established

  def established
    if date = info('Domain/Site Info', 'Site Established')
      Date.strptime(date, '%Y-%m-%d')
    end
  end

  def business_url
    if img = doc.css('img').detect {|i| i['src'].to_s.match(/visit_site.jpg/) }
      img.parent['href']
    end
  end

  def description
    desc = [doc.at('.listing-left p').text]
    desc << detail('Revenue Details')
    desc << detail('Traffic Details')
    desc << detail('Expense Details')

    desc.compact.join(divider)
  end

  private

  def section(label)
    doc.at('.result-widget').css('h3').detect {|h| h.text == label}
  end

  def info(section_label, field)
    if h3 = section(section_label)
      ul = h3.parent.at('> ul.list-result')
      if li = ul.css('li').detect {|l| l.at('.pull-left').text == "#{field}:" }
        li.at('.pull-right').text
      end
    end
  end

  def detail(label)
    if h3 = section(label)
      if div = h3.parent.at('> p')
        "[#{label}]: #{sane div.text}"
      end
    end
  end

end
