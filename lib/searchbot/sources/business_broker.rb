class Sources::BusinessBroker < Sources::Base

  BASE_URL = "http://www.businessbroker.net/listings/bfs_result.aspx?By=AdvancedSearch&r_id=33&ind_id=0&ask_price_l=300000&ask_price_h=1600000&map_id=55&lcity=&keyword=&lst_no=&time=0&bprice=1&fresale=0&ownerfi=0&county_id=0"

  def url_for_page(page)
    BASE_URL + "&pg=#{page}"
  end

  def parse_results_page(doc)
    doc.css('.listing-row').each do |raw|
      result = parse_single_result(raw)
      next unless passes_filters?(result)

      @results << result
    end

    doc.at('.pagination').css('a').detect {|l| l.text == 'Next Page >' }
  end

  def parse_single_result(raw)
    finance = raw.at('.listing-item-financials')
    title   = raw.at('.listing-text-title')
    link    = title.at('a')['href']
    teaser  = raw.at('.listing-item-desc').css('div').last.text
    id      = self.class.id_from_url(link)

    raise PreviouslySeen if seen.include?(id)

    Result.new(self, {
      price:      str2i( finance.css('.financial-text-top')[1].text ),
      cashflow:   str2i( finance.css('.financial-text')[1].text ),
      revenue:    str2i( finance.css('.financial-text')[3].text ),
      title:      title.text,
      teaser:     teaser,
      link:       link,
      id:         id,
    })
  end

  def self.id_from_url(url)
    url.split('/').last.split('.').first
  end

  def self.parse_result_details(url, doc)
    info = doc.at('#details-bfs').at('.info')

    string_at = -> (path) { doc.at("##{path}").text }
    number_at = -> (path) { str2i( string_at[path] ) }

    # Sometimes miscategorized, so go with the smallest number provided
    cashflow = ['lblycflow', 'lblynprofit'].map {|key| number_at[key] }.reject {|v| v.zero? }.min

    desc = [
      "Business Overview: #{string_at['lbloverview']}",
      "Property Features: #{string_at['lblfeatures']}",
      "Market Competition and Expansion: #{string_at['lbloverview']}",
    ].join("\n\n\n")

    DetailResult.new({
      id:   id_from_url(url),
      link: url,

      title:     doc.at('h2.title').text,
      location:  doc.at('h2.location').text,

      price:        number_at['lblPrice'],
      revenue:      number_at['lblyrevenue'],
      cashflow:     cashflow,

      ffe:          number_at['lblFFE'],
      real_estate:  number_at['lblRealEstate'],
      employees:    number_at['lblemploy'],
      established:  number_at['lblYest'],

      seller_financing: !!doc.at('#divOwnerFinancing'),
      reason_selling:   string_at['lblreason'],

      description:  desc,
    })
  end

  # BusinessBroker.net doesn't allow filtering by cash flow directly.
  def passes_filters?(result)
    return true unless filters.min_cashflow
    result.cashflow >= filters.min_cashflow
  end

end