class Searchbot::Generic::Searcher
  include Searchbot::Utils::Web

  # When set (e.g. testing), limits results to this many pages
  attr_accessor :max_pages

  attr_reader :filters, :seen

  def initialize(filters, opts = {})
    @filters = Filters.coerce( filters )
    @seen = Array(opts.delete(:seen)) # Array of seen identifiers
    parse_options( opts )
  end

  def listings
    get_listings if @listings.nil?
    @listings
  end

  def listing_parser
    source_class 'ListingParser'
  end

  def detail_parser
    source_class 'DetailParser'
  end

  def listings_page
    source_class 'ListingsPage'
  end

  private

  def constantize(string)
    string.split('::').compact.inject(Object) {|context, name| context.const_get(name) }
  end

  def source_class(kind)
    parts = self.class.name.split('::')
    parts.pop
    parts.push kind

    constantize parts.join('::')
  end






  def parse_options(opts)
    # Hook for subclasses to add special options handling
  end

  def self.divider
    "\n\n\n"
  end

  def url_for_page
    raise "Must be implemented in child class"
  end

  def listings_selector(doc)
    raise "Must be implemented in child class"
  end

  def more_pages_available?
    raise "Must be implemented in child class"
  end

  def single_result_data(raw)
    raise "Must be implemented in child class"
  end

  # TODO: this is often a slow point, since it usually
  # requires a secondary web request for each listing,
  # so depending on how nice we want to be to the backends
  # it could possibly be parallelized.
  def single_result_details(listing, doc)
    raise "Must be implemented in child class"
  end

  def get_listings
    @listings = []
    more_pages = true
    curr_page = 0

    while more_pages do
      curr_page += 1
      page = listings_page.new( url: url_for_page(curr_page), searcher: self )

      page.listings.each do |listing|
        next unless listing.passes_filters?(filters)
        break if seen.include?(listing.id)

        @listings << listing
      end

      more_pages = page.more_pages_available?
      break if max_pages && curr_page > max_pages
    end
  end

  def unseen
    @unseen ||= results.reject {|result| seen.include?(result.id) }
  end

  def map_id_for_state(state)
    if state.to_s.length == 2
      raise ArgumentError, "must provide full state name, not an abbreviation"
    elsif respond_to?(:state_id_map, true)
      state_id_map[state] || 0
    else
      raise "Must define #state_id_map in #{self.class.name} before calling #map_id_for_state"
    end
  end


end