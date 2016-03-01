# Subclasses are only responsible for implementing the #parse method
class Searchbot::Generic::DetailParser < Searchbot::Generic::Parser

  attr_reader :listing

  def initialize(listing:, html: nil, url: nil, options: {})
    @listing = listing
    super(html: html, url: url)
  end

  def result
    params = listing.to_hash
      .merge( result_defaults )
      .merge( parse )

    Searchbot::Results::Details.new( params )
  end

  private

  def result_defaults
    {searcher: listing.searcher, raw_details: html}
  end

end