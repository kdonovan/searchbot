class DetailResult < Hashie::Dash
  property :id,      required: true
  property :link,    required: true

  property :cashflow
  property :revenue

  property :title
  property :price
  property :description
  property :location

  property :ffe
  property :real_estate
  property :employees
  property :established
  property :seller_financing
  property :reason_selling
end