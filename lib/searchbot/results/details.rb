class Searchbot::Results::Details < Searchbot::Results::Base

  property :description, transform_with: ->(v) { sane(v) }

  # We don't want to report it, but keep the raw HTML or JSON internally for examination
  property :raw_details

  property :ffe,              transform_with: ->(v) { str2i(v) }
  property :inventory,        transform_with: ->(v) { str2i(v) }
  property :real_estate,      transform_with: ->(v) { str2i(v) }
  property :employees,        transform_with: ->(v) { sane(v) }
  property :seller_financing, transform_with: ->(v) { str2i(v) }
  property :reason_selling,   transform_with: ->(v) { sane(v) }

  # Websites
  property :hours_required
  property :business_url

end