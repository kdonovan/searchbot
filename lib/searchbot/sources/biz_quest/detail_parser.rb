class Searchbot::Sources::BizQuest::DetailParser < Searchbot::Generic::DetailParser

  def parse
    info = doc.at('.listingDetail')

    parse_dd_for = -> (dt_text) {
      dt_text += ':' unless dt_text[-1] == ':'
      if node = info.css('dt').detect {|n| n.text.strip == dt_text}
        node = node.next until node.name.upcase == 'DD'
        sane( node.text )
      end
    }

    info_at = -> (label) {
      if node = info.css('b.text-info').detect {|n| n.text.strip == "#{label}:"}
        node = node.next
        node = node.next until node.name.upcase == 'B'
        unless node[:class].include?('no-info')
          val = sane( node.text )
          val =~ /Not Disclosed/ ? nil : val
        end
      end
    }

    # Build the description
    unwanted_dts = ['BizQuest Listing ID:', 'Ad Detail Views:', 'Year Established:', 'Number of Employees:', 'Reason For Selling:']
    desc = [ sane( parse_section_after(info, 'Business Description') ) ]
    info.css('dt').map(&:text).each do |header|
      unless unwanted_dts.include?(header)
        header_display = header == "Market Outlook/\r\n        Competition:" ? 'Market Outlook/Competition:' : header
        desc << ["[#{header_display.sub(/:$/, '')}]: #{sane parse_dd_for[header]}"]
      end
    end

    # See if there's a comment about EBITDA in one of the dt/dd listings
    ebitda = if cf = parse_dd_for['Cash Flow Comments']
      if cf = cf.scan(/ebitda: \$([\d,\.]+)/i)[0]
        cf[0]
      end
    end

    {
      revenue:        info_at['Gross Revenue'],

      ffe:            info_at['FF&E'],
      inventory:      info_at['Inventory'],

      established:    parse_dd_for['Year Established'],
      employees:      parse_dd_for['Number of Employees'],
      reason_selling: parse_dd_for['Reason For Selling'],

      description:    desc.join(divider),

      seller_financing: !!parse_dd_for['Seller Financing'],
    }.tap do |params|
      if ebitda
        params[:cashflow_from] = [info_at['Cash Flow'], ebitda]
      else
        params[:cashflow] = info_at['Cash Flow']
      end
    end
  end

  private

  def parse_section_after(doc, h3_text)
    return unless node = doc.css('h3').detect {|n| n.text == h3_text}
    sections = []

    loop do
      node = node.next
      break if node.nil? || %w(H3 A).include?(node.name.upcase)
      next if %w(A SCRIPT BR).include?(node.name.upcase)
      sections << node.text if node.text.strip.length > 0
    end

    sections.join( divider ).strip
  end

end
