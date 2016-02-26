class Searchbot::Sources::FEInternational::DetailParser < Searchbot::Generic::DetailParser

  # No need to pull in another page - just grab from listing's raw
  def html
    @html ||= context.raw_listing
  end

  def parse
    dt = doc.at('article').attributes['data-date'].value
    date = Date.strptime(dt, '%Y%m%d')

    {
      established: date
    }
  end

end
