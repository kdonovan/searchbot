class Searchbot::Generic::ListingsPage
  include Searchbot::Utils::Web

  attr_reader :url, :searcher

  def initialize(url:, searcher:)
    @url, @searcher = url, searcher
  end

  def listings
    listings_selector.map do |raw|
      searcher.listing_parser.new(html: raw, context: self, source: searcher).result
    end
  end

  def listings_selector
    raise "Must be implemented in subclasses"
  end

  def more_pages_available?
    raise "Must be implemented in subclasses"
  end

  private

  def doc
    @doc ||= fetch(url)
  end

end