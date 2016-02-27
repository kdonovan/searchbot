class Searchbot::Sources::EmpireFlippers::DetailParser < Searchbot::Generic::DetailParser

  def parse
    {
      revenue:        revenue,
      description:    doc.at('.listing--description p').text,
      hours_required: hours,
      reason_selling: sane(reason),
    }
  end

  private

  def reason
    if h3 = doc.css('.listing--content h3').detect {|n| n.text == 'Reason for Sale'}
      h3.next.text
    end
  end

  def hours
    if node = doc.at('.listing--hours')
      if hrs = node.text.scan(/(\d+)\s*hours/i).flatten.first
        hrs.to_i
      end
    end
  end

  def revenue
    if rv = doc.at('.revenue')
      Searchbot::Utils::Parsing.str2i( rv.text ) * 12
    end
  end

end
