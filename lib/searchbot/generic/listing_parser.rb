# Subclasses are only responsible for implementing the #parse method
class Searchbot::Generic::ListingParser < Searchbot::Generic::Parser

  def result
    params = {source: source, raw_listing: html}.merge( parse )

    Searchbot::Results::Listing.new( params )
  end

  private

end