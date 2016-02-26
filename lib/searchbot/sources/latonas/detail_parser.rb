class Searchbot::Sources::Latonas::DetailParser < Searchbot::Generic::DetailParser

  def parse
    # Note: lots more custom stats we could pull in if desired. And graphs!
    {
      description:    description,
      business_url:   url,
      established:    established,
    }
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

  def established
    if date = info('Domain/Site Info', 'Site Established')
      Date.strptime(date, '%Y-%m-%d')
    end
  end

  def url
    if node = doc.css('a').detect {|l| l.text == 'Visit Site' }
      node['href']
    end
  end

  def description
    desc = [doc.at('.listing-left p').text]
    desc << detail('Revenue Details')
    desc << detail('Traffic Details')
    desc << detail('Expense Details')

    desc.compact.join(divider)
  end

end
