class Searchbot::Sources::Latonas < Searchbot::Sources::Base

  # Standard web scraping, it's all in a mostly-hidden table and all initial
  # listings are on one page (still need detail page for descriptions, but
  # no listing page pagination required).
  #
  # In theory we have to log in first for full details, but in practice
  # all the info we actually need is present, just hidden in the UI.

  BASE_URL   = 'https://latonas.com/websites-for-sale'
  LOGIN_URL  = 'https://latonas.com/account/login'
  DETAIL_URL = "https://latonas.com/websites-for-sale/%s"

  def url_for_page(page = 1)
    raise "Latonas has a single page of search results" unless page == 1
    BASE_URL
  end

  private

  attr_reader :username, :password

  def parse_options(opts)
    @username = opts[:username]
    @password = opts[:password]

    if username && password
      login
    else
      raise ArgumentError, "The Latonas source requires :username and :password keys"
    end
  end

  def listings_selector(doc)
    doc.css('table#listing_data tbody tr')
  end

  def more_pages_available?
    nil
  end

  def authentication_hash
    {
      email: username,
      password: password,
    }
  end

  def login
    return true if logged_in?

    response = HTTParty.post(LOGIN_URL, headers: common_headers, body: authentication_hash)
    result   = JSON.parse(response)

    if result['ret'] == 1
      set_cookies_from(response)
    else
      raise "Unable to log into Latonas with '#{username}' and provided password"
    end
  end

  def logged_in?
    return true
    # TODO: TURN THIS BACK ON!!
    !! cookies
  end

  def single_result_keys
    %i(picture title uniques revenue profit listed_date monetization link category featured high low reduced alexa pr inbound keywords semrush tags is_new slug blank uniques2 revenue2 profit2 price)
  end

  def single_result_data(raw)
    values = raw.css('td')
    data   = Hash[ *single_result_keys.zip(values).flatten ]

    data[:title].at('a').remove
    title = data[:title].text
    link  = DETAIL_URL % data[:slug].text

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

  def single_result_details(listing, doc)
    info_node = doc.at('.result-widget')

    section = -> (label) {
      info_node.css('h3').detect {|h| h.text == label}
    }

    info = ->(section_label, field) {
      if h3 = section[section_label]
        ul = h3.parent.at('> ul.list-result')
        if li = ul.css('li').detect {|l| l.at('.pull-left').text == "#{field}:" }
          li.at('.pull-right').text
        end
      end
    }

    detail = -> (label) {
      if h3 = section[label]
        if div = h3.parent.at('> p')
          "[#{label}]: #{sane div.text}"
        end
      end
    }

    desc = [doc.at('.listing-left p').text]
    desc << detail['Revenue Details']
    desc << detail['Traffic Details']
    desc << detail['Expense Details']
    desc = desc.compact.join(divider)

    established = if date = info['Domain/Site Info', 'Site Established']
      Date.strptime(date, '%Y-%m-%d')
    end

    url = if node = doc.css('a').detect {|l| l.text == 'Visit Site' }
      node['href']
    end

    binding.pry

    # Note: lots more custom stats we could pull in if desired. And graphs!
    {
      description:    desc,
      business_url:   url,
      established:    established,
    }
  end

end