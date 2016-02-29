class Searchbot::Sources::BusinessBroker::DetailParser < Searchbot::Generic::DetailParser

  parses :description, :cashflow_from, :ffe, :real_estate, :employees, :established, :seller_financing, :reason_selling

  def cashflow_from;    [get('lblycflow'), get('lblynprofit')] end
  def ffe;              get('lblFFE') end
  def real_estate;      get('lblRealEstate') end
  def employees;        get('lblemploy') end
  def established;      get('lblYest') end
  def seller_financing; !!doc.at('#divOwnerFinancing') end
  def reason_selling;   get('lblreason') end

  def description
    desc = []
    desc << "[Business Overview]: #{sane get('lbloverview')}" if get('lbloverview').to_s.strip.length > 0
    desc << "[Property Features]: #{sane get('lblfeatures')}" if get('lblfeatures').to_s.strip.length > 0

    desc.join( divider )
  end

  private

  def get(path)
    return unless doc.at("##{path}")

    raw = doc.at("##{path}").text
    raw.downcase! if raw == raw.upcase
    raw
  end

end
