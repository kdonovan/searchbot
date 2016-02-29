class Searchbot::Sources::EmpireFlippers::DetailParser < Searchbot::Generic::DetailParser

  parses :revenue, :description, :hours_required, :reason_selling

  def description
    doc.at('.listing--description p').text
  end

  def reason_selling
    if node = doc.css('.listing--content h3').detect {|n| n.text == 'Reason for Sale'}
      node = node.next while node && node.name != 'p'
      sane node.text
    end
  end

  def hours_required
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
