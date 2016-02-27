class Searchbot::Results::Listing < Searchbot::Results::Base

  def detail
    @detail ||= detail_parser.new(url: link, listing: self).result
  end

  def detail_parser
    searcher.detail_parser
  end

end