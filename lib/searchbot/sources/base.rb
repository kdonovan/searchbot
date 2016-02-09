class Searchbot::Sources::Base
  FIREFOX = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:43.0) Gecko/20100101 Firefox/43.0'

  # When set (e.g. testing), limits results to this many pages
  attr_accessor :max_pages

  def self.result_details(listing)
    doc     = parse(listing.link)
    details = parse_result_details(listing, doc)

    params = listing.to_hash.merge(details)
    Searchbot::Results::Details.new( params )
  end

  attr_reader :filters, :seen

  def initialize(filters, opts = {})
    @filters = Filters.coerce( filters )
    @results = nil
    @seen = Array(opts[:seen]) # Array of seen identifiers
  end

  def results
    retrieve_results if @results.nil?
    @results
  end

  private

  def self.divider
    "\n\n\n"
  end

  def sane(string)
    self.class.sane(string)
  end

  def self.sane(string)
    return unless string

    string.strip!
    if string && string.upcase == string
      string.downcase.split('.').map(&:capitalize).join('.')
    else string
    end
  end

  def self.parse(url)
    html = HTTParty.get(url, headers: {'User-Agent' => FIREFOX}).body
    Nokogiri::HTML( html )
  end

  def parse(url)
    self.class.parse(url)
  end

  def parse_results_page(doc)
    listings_selector(doc).each do |raw|
      result = parse_single_result(raw)
      next unless result.passes_filters?(filters)
      raise PreviouslySeen if seen.include?(result.id)

      @results << result
    end
  end

  def self.parse_result_details(listing, doc)
    raise "Must be implemented in child class"
  end

  def url_for_page
    raise "Must be implemented in child class"
  end

  def parse_single_result(raw)
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
        more_pages = more_pages_available?(doc)
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

end
