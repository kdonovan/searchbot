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

  # subclasses can override to provide meta information for e.g. specs to
  # determine when they can share cassettes.
  def self.searchable_filters(*args)
    @searchable_filters = args
  end

  def listings
    get_listings if @listings.nil?
    @listings
  end

  def detailed_listings
    @detailed_listings ||= listings.map(&:detail)
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

  def fields_from_listing
    fields_from listing_parser
  end

  def fields_from_detail
    fields_from detail_parser
  end

  def all_fields
    fields_from_listing + fields_from_detail
  end

  private

  def fields_from(parser)
    parser.fields_parsed
  end

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

  def url_for_page
    raise "Must be implemented in child class"
  end

  def raw_listings(doc)
    raise "Must be implemented in child class"
  end

  def more_pages_available?
    raise "Must be implemented in child class"
  end

  def generate_url(base: base_url, params:)
    param_string = params.map do |k, v|
      [k, v].join('=')
    end.join('&')

    [base, param_string].join('?')
  end

  def get_listings
    @listings = []
    more_pages = true
    curr_page = 0

    while more_pages do
      curr_page += 1
      page = listings_page_for( curr_page )

      page.listings.each do |listing|
        next unless listing.passes_filters?(filters)
        break if seen.include?(listing.identifier)

        @listings << listing
      end

      more_pages = page.more_pages_available?
      break if max_pages && curr_page >= max_pages
    end
  end

  def listings_page_for(page)
    listings_page.new( url: url_for_page(page), searcher: self )
  end

  def unseen
    @unseen ||= listings.reject {|listing| seen.include?(listing.identifier) }
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