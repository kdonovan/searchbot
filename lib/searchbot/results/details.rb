class Searchbot::Results::Details < Searchbot::Results::Base

  property :description

  # We don't want to report it, but keep the raw HTML or JSON internally for examination
  property :raw_details

  property :ffe,          transform_with: ->(v) { str2i(v) }
  property :inventory,    transform_with: ->(v) { str2i(v) }
  property :real_estate,  transform_with: ->(v) { str2i(v) }
  property :employees,    transform_with: ->(v) { str2i(v) }
  property :established,  transform_with: ->(v) { str2i(v) }
  property :seller_financing
  property :reason_selling

  # Websites
  property :hours_required
  property :business_url

end