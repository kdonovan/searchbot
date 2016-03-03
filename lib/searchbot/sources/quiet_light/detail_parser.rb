class Searchbot::Sources::QuietLight::DetailParser < Searchbot::Generic::DetailParser

  parses :description

  def description
    desc = []
    doc.at('.listing-description').children.each do |node|
      desc << node.text.gsub(/\n/, ' ') if node.name == 'p'
      break if node['id'] == 'tve_leads_end_content'
    end

    desc.join(divider)
  end

end
