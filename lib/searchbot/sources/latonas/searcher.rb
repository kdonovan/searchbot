class Searchbot::Sources::Latonas::Searcher < Searchbot::Generic::Searcher

  # Standard web scraping, it's all in a mostly-hidden table and all initial
  # listings are on one page (still need detail page for descriptions, but
  # no listing page pagination required).
  #
  # In theory we have to log in first for full details, but in practice
  # all the info we actually need is present, just hidden in the UI.

  def base_url
    'https://latonas.com/websites-for-sale'
  end

  def url_for_page(page = 1)
    raise "Latonas has a single page of search results" unless page == 1
    base_url
  end

end
