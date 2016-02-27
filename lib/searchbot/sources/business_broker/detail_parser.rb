class Searchbot::Sources::BusinessBroker::DetailParser < Searchbot::Generic::DetailParser

  def parse
    {
      description:    description,
      cashflow_from:  [get('lblycflow'), get('lblynprofit')],

      ffe:            get('lblFFE'),
      real_estate:    get('lblRealEstate'),
      employees:      get('lblemploy'),
      established:    get('lblYest'),

      seller_financing: !!doc.at('#divOwnerFinancing'),
      reason_selling:   sane( get('lblreason') ),
    }
  end

  private

  def get(path)
    return unless doc.at("##{path}")

    raw = doc.at("##{path}").text
    raw.downcase! if raw == raw.upcase
    raw
  end

  def description
    desc = []
    desc << "[Business Overview]: #{sane get('lbloverview')}" if get('lbloverview').to_s.strip.length > 0
    desc << "[Property Features]: #{sane get('lblfeatures')}" if get('lblfeatures').to_s.strip.length > 0

    desc.join( divider )
  end

end
