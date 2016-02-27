class Searchbot::Generic::ListingsPage
  include Searchbot::Generic::Concerns::Html
  include Searchbot::Utils::Web

  attr_reader :url, :searcher, :options

  def initialize(url:, searcher:, options: {})
    @url, @searcher, @options = url, searcher, options
  end

  def listings
    raw_listings.map do |raw|
      parse_raw_listing(raw)
    end
  end

  def raw_listings
    raise "Must be implemented in subclasses"
  end

  def more_pages_available?
    raise "Must be implemented in subclasses"
  end

  private

  def parse_raw_listing(raw)
    searcher.listing_parser.new(html: raw, page: self).result
  end

end