class Searchbot::Sources::Base
  FIREFOX = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:43.0) Gecko/20100101 Firefox/43.0'

  # When set (e.g. testing), limits results to this many pages
  attr_accessor :max_pages

  def result_details(listing)
    doc     = parse(listing.link)

    details = single_result_details(listing, doc)
    params  = listing.to_hash.merge(details)

    # Provide a default for the raw details, but allow subclasses to narrow down
    Searchbot::Results::Details.new( {raw_details: doc}.merge(params) )
  end

  attr_reader :filters, :seen

  def initialize(filters, opts = {})
    @filters = Filters.coerce( filters )
    @results = nil
    @seen = Array(opts.delete(:seen)) # Array of seen identifiers
    parse_options( opts )
  end

  def results
    retrieve_results if @results.nil?
    @results
  end

  private

  def constantize(string)
    string.split('::').compact.inject(Object) {|context, name| context.const_get(name) }
  end

  def detail_parser
    constantize("Searchbot::Parsers::Detail::#{self.class.name.split('::').last}")
  end

  def parse_options(opts)
    # Hook for subclasses to add special options handling
  end

  def self.divider
    "\n\n\n"
  end

  def common_headers
    {
      'User-Agent' => FIREFOX,
      'Cookie'     => cookie_string,
    }.select {|k,v| !v.nil? }
  end

  attr_reader :cookies

  # Allow sending cookies with all requests by setting @cookies to
  # output of parse_cookies
  def cookie_string
    cookies ? cookies.to_cookie_string : nil
  end

  def set_cookies_from(resp)
    @cookies = parse_cookie(resp)
  end

  def parse_cookie(resp)
    cookie_hash = HTTParty::CookieHash.new
    resp.get_fields('Set-Cookie').each { |c| cookie_hash.add_cookies(c) }
    cookie_hash
  end

  def self.parse(url, headers = nil)
    # binding.pry
    raise "latonas needs headers" unless headers

    html = HTTParty.get(url, headers: headers).body
    Nokogiri::HTML( html )
  end

  def parse(url)
    self.class.parse(url, common_headers)
  end

  def parse_results_page(doc)
    raw_listings(doc).each do |raw|
      result = parse_single_result(raw)
      next unless result.passes_filters?(filters)
      raise PreviouslySeen if seen.include?(result.id)

      @results << result
    end
  end

  def parse_single_result(raw)
    Searchbot::Results::Listing.new(
      single_result_data(raw).merge(raw: raw, source: self),
    )
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


  def retrieve_results
    @results = []
    more_pages = true
    curr_page = 1

    while more_pages do
      url = url_for_page(curr_page)
      doc = parse(url)

      begin
        parse_results_page(doc)
        more_pages = more_pages_available?
      rescue PreviouslySeen
        break
      end

      curr_page += 1
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
