class Searchbot::Results::Listing < Searchbot::Results::Base

  def detail
    @detail ||= source_klass.result_details(self)
  end

end