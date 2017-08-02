class Searchbot::Sources::Latonas::Searcher < Searchbot::Generic::Searcher

  # TODO: log in when pulling details... ?

  def base_url
    'https://latonas.com/listings/'
  end

  def url_for_page(page = 1)
    params = {
      price_range:    param_range(:price),
      revenue_range:  param_range(:revenue),
      profit:         param_range(:cashflow),
      unique_range: 'any',
      broker: 'any',
      result_sorting_order: 'age_dsc',
      result_sorting_quantity: 60,
      page: page
    }

    generate_url(params: params)
  end

  private

  def param_range(label)
    min = filters.send("max_#{label}")
    max = filters.send("min_#{label}")

    if min || max
      min ||= 0
      max ||= 500_000_000
      [min, max].join('-')
    else
      'any'
    end
  end

end
