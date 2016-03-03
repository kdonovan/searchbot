class Searchbot::Sources::BizBroker24::DetailParser < Searchbot::Generic::DetailParser

  parses :description, :seller_financing

  def description
    doc.css('.wpl_prp_show_detail_boxes_cont p').map(&:text).join(divider)
  end

  def seller_financing
    get('Financing Available') == 'Yes'
  end

  private

  def get(label)
    node = doc.at('.wpl_prp_show_detail_boxes').css('.rows.other').detect do |n|
      n.text.match(/#{label}/)
    end

    node&.at('span')&.text
  end

end
