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
    id      = link.split('/').last.split('.').first.to_i

    raise PreviouslySeen if seen.include?(id)

    Result.new({
      price:   str2i( finance.css('.financial-text-top')[1].text ),
      cash:    str2i( finance.css('.financial-text')[1].text ),
      revenue: str2i( finance.css('.financial-text')[3].text ),
      title:   title.text,
      link:    link,
      id:      id,
    })
  end

  # BusinessBroker.net doesn't allow filtering by cash flow directly.
  def passes_filters?(result)
    return true unless filters.min_cashflow
    result.cash >= filters.min_cashflow
  end

end