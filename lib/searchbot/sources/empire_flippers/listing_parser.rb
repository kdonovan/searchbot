class Searchbot::Sources::EmpireFlippers::ListingParser < Searchbot::Generic::ListingParser

  def parse
    {
      price:        json['price'].to_i,
      cashflow:     json['net_profit'].to_i * 12,
      title:        title,
      link:         link,
      id:           json['listing_id'].to_s,
      teaser:       teaser,
    }
  end

  private

  def json
    html # We're passing it as w/ HTML name, but it's JSON from their API
  end

  def title
    [json['monetization'], json['niche']].join(' // ')
  end

  def link
    "https://empireflippers.com/listing/#{json['listing_id']}/"
  end

  def teaser
    "Created: #{json['date_created']}. Posted: #{json['post_date']}."
  end

end
