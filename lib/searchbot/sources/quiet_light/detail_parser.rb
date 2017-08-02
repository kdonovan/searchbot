class Searchbot::Sources::QuietLight::DetailParser < Searchbot::Generic::DetailParser

  parses :description

  def description
    doc.css('.description p').map(&:text).join(divider)
  end

end
