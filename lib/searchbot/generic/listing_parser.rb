# Subclasses are only responsible for implementing the #parse method
class Searchbot::Generic::ListingParser < Searchbot::Generic::Parser

  def result
    params = parser_options.merge( parse )

    Searchbot::Results::Listing.new( params )
  end

  private

  def parser_options
    {source: source, raw_listing: html}
  end

end