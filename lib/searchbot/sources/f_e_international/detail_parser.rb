class Searchbot::Sources::FEInternational::DetailParser < Searchbot::Generic::DetailParser

  parses :established, :description

  def established
    dt = doc.at('article').attributes['data-date'].value
    Date.strptime(dt, '%Y%m%d')
  end

  def description
    desc = []
    node = doc.css('h2').detect {|n| n.text == 'Description' }
    loop do
      node = node.next until node.nil? || node.name == 'p'
      break unless node
      desc << node.text
    end

    desc.join(divider)
  end

  private

  # No need to pull in another page - just grab from listing's raw
  def html
    @html ||= listing.raw_listing
  end

end
