class Searchbot::Sources::Latonas::ListingParser < Searchbot::Generic::ListingParser

  parses :identifier, :price, :revenue, :cashflow, :listed_at, :link, :title, :teaser

  def identifier; data[:slug].text    end
  def price;      data[:price].text   end
  def revenue;    data[:revenue].text end
  def cashflow;   data[:profit].text  end

  def listed_at
    Date.strptime(data[:listed_date], '%Y-%m-%d')
  end

  def title
    if node = data[:title].at('a').remove
      node.remove
    end

    data[:title].text
  end

  def link
    detail_url data[:slug].text
  end

  def teaser
    type = data[:monetization].text.split('|').compact.join('/')
    cat  = data[:category].text.split('|').compact.join('/')

    "#{type} website in the #{cat} space(s)"
  end

  private

  LISTING_KEYS = %i(picture title uniques revenue profit listed_date monetization link category featured high low reduced alexa pr inbound keywords semrush tags is_new slug blank uniques2 revenue2 profit2 price)

  def data
    @data ||= begin
      values = doc.css('td')
      Hash[ *LISTING_KEYS.zip(values).flatten ]
    end
  end

  def detail_url(slug)
    "https://latonas.com/websites-for-sale/%s" % slug
  end

end
