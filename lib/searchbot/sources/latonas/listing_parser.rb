class Searchbot::Sources::Latonas::ListingParser < Searchbot::Generic::ListingParser


  def parse
    values = doc.css('td')
    data   = Hash[ *LISTING_KEYS.zip(values).flatten ]

    data[:title].at('a').remove
    title = data[:title].text
    link  = detail_url data[:slug].text

    type = data[:monetization].text.split('|').compact.join('/')
    cat  = data[:category].text.split('|').compact.join('/')
    teaser = "#{type} website in the #{cat} space(s)"

    listed = Date.strptime(data[:listed_date], '%Y-%m-%d')

    {
      id:          data[:slug].text,
      price:       data[:price].text,
      revenue:     data[:revenue].text,
      cashflow:    data[:profit].text,
      listed_at:   listed,
      link:        link,
      title:       sane( title ),
      teaser:      teaser,
    }
  end

  private

  LISTING_KEYS = %i(picture title uniques revenue profit listed_date monetization link category featured high low reduced alexa pr inbound keywords semrush tags is_new slug blank uniques2 revenue2 profit2 price)

  def detail_url(slug)
    "https://latonas.com/websites-for-sale/%s" % slug
  end

end
