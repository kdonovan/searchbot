class Filters < Hashie::Dash
  include Searchbot::Utils::Parsing

  def self.coerce(other)
    case other
    when Filters then other
    else Filters.new( other )
    end
  end

  property :min_price
  property :max_price

  property :min_cashflow
  property :max_cashflow

  property :min_ratio
  property :max_ratio

  property :min_revenue
  property :max_revenue

  property :state
  property :city

  property :keyword

  def state_abbrev(*ignored)
    super(state)
  end

  def state_full(*ignored)
    super(state)
  end

end