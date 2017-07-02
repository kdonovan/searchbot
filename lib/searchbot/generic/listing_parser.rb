# Subclasses are only responsible for implementing the #parse method
class Searchbot::Generic::ListingParser < Searchbot::Generic::Parser

  attr_reader :page

  def initialize(page:, html: nil, url: nil, options: {})
    @page, @url = page, url

    if html
      @html = html.respond_to?(:to_html) ? html.to_html : html
    end

    raise ArgumentError, "must provide either :html or :url" unless html || url
  end

  def result
    return unless parsed = parse
    params = result_defaults.merge( parsed )

    Searchbot::Results::Listing.new( params )
  end

  private

  def result_defaults
    {searcher: page.searcher, raw_listing: html}
  end

  def make_absolute(url, base: page.searcher.base_url)
    URI.join( base, url ).to_s
  end

end