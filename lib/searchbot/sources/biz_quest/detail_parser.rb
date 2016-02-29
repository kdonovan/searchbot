class Searchbot::Sources::BizQuest::DetailParser < Searchbot::Generic::DetailParser

  parses :revenue, :ffe, :inventory, :established, :employees, :reason_selling, :description, :seller_financing, :cashflow_from

  def revenue
    info_at('Gross Revenue')
  end

  def ffe
    info_at('FF&E')
  end

  def inventory
    info_at('Inventory')
  end

  def established
    parse_dd_for('Year Established')
  end

  def employees
    parse_dd_for('Number of Employees')
  end

  def reason_selling
    parse_dd_for('Reason For Selling')
  end

  def description
    desc = [ sane( parse_section_after(info, 'Business Description') ) ]

    info.css('dt').map(&:text).each do |header|
      next if unwanted_dts.include?(header)

      # Manually fix malformed text
      header_display = header == "Market Outlook/\r\n        Competition:" ? 'Market Outlook/Competition:' : header

      desc << ["[#{header_display.sub(/:$/, '')}]: #{sane parse_dd_for(header)}"]
    end

    desc.join(divider)
  end

  def seller_financing
    !!parse_dd_for('Seller Financing')
  end

  # Using cashflow_from, rather than cashflow, to allow pulling cashflow from editba comments as well
  def cashflow_from
    [info_at('Cash Flow'), ebitda].compact
  end

  private

  def info
    doc.at('.listingDetail')
  end

  def parse_dd_for(dt_text)
    dt_text += ':' unless dt_text[-1] == ':'

    if node = info.css('dt').detect {|n| n.text.strip == dt_text}
      node = node.next until node.name.upcase == 'DD'
      sane( node.text )
    end
  end

  def info_at(label)
    return unless node = info.css('b.text-info').detect do |n|
      n.text.strip == "#{label}:"
    end

    node = node.next
    node = node.next until node.name.upcase == 'B'
    unless node[:class].include?('no-info')
      val = sane( node.text )
      val =~ /Not Disclosed/ ? nil : val
    end
  end

  def unwanted_dts
    ['BizQuest Listing ID:', 'Ad Detail Views:', 'Year Established:', 'Number of Employees:', 'Reason For Selling:']
  end

  def parse_section_after(context, h3_text)
    return unless node = context.css('h3').detect {|n| n.text == h3_text}
    sections = []

    loop do
      node = node.next
      break if node.nil? || %w(H3 A).include?(node.name.upcase)
      next if %w(A SCRIPT BR).include?(node.name.upcase)
      sections << node.text if node.text.strip.length > 0
    end

    sections.join( divider ).strip
  end

  # See if there's a comment about EBITDA in one of the dt/dd listings
  def ebitda
    if cf = parse_dd_for('Cash Flow Comments')
      if cf = cf.scan(/ebitda: \$([\d,\.]+)/i)[0]
        cf[0]
      end
    end
  end

end
