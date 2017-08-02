class Searchbot::Sources::Latonas::DetailParser < Searchbot::Generic::DetailParser

  # Note: Could parse fuller description and maybe a tad more if logged in....

  parses :description, :established, :listed_at

  def established
    info_date 'Established'
  end

  def listed_at
    info_date 'Listed'
  end

  def description
    doc.at('p.ct-u-marginBottom20 + p').text
  end

  private

  def info_date(label)
    if span = doc.css('span.pull-right').detect {|s| s.text =~ /#{label}: / }
      txt = span.at('span').text.split('(').first
      return if txt == 'None'
      Date.parse txt
    end
  end
end
