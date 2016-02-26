class Searchbot::Results::Listing < Searchbot::Results::Base

  def detail
    @detail ||= detail_parser.new(url: link, source: source, context: self).result
  end

  def detail_parser
    source.detail_parser
  end

end