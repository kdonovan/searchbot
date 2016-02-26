# Subclasses are only responsible for implementing the #parse method
class Searchbot::Generic::DetailParser < Searchbot::Generic::Parser

  def result
    params = context.to_hash
      .merge(source: source, raw_details: html)
      .merge( parse )

    Searchbot::Results::Details.new( params )
  end

  private

end