class Searchbot::Sources::EmpireFlippers::ListingParser < Searchbot::Generic::ListingParser

  parses :identifier, :price, :cashflow, :title, :link, :teaser


  def identifier
    json['listing_id'].to_s
  end

  def price
    json['price'].to_i
  end

  def cashflow
    json['net_profit'].to_i * 12
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

  private

  def json
    html # We're passing it as w/ HTML name, but it's JSON from their API
  end

end
