class Result < Hashie::Dash
  property :id,     required: true
  property :link,   required: true
  property :cash
  property :revenue
  property :title
  property :price
end