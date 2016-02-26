# Subclasses are only responsible for implementing the #parse method
class Searchbot::Generic::DetailParser < Searchbot::Generic::Parser

  def result
    params = context.to_hash
      .merge( parser_options )
      .merge( parse )

    Searchbot::Results::Details.new( params )
  end

  private

  def parser_options
    {source: source, raw_details: html}
  end

end