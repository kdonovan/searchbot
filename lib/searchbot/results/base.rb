class Searchbot::Results::Base < Hashie::Dash
  include Hashie::Extensions::Dash::PropertyTranslation
  extend Searchbot::Utils::Parsing

  property :source_klass

  property :id,      required: true
  property :link,    required: true

  property :price,    transform_with: ->(v) { str2i(v) }
  property :cashflow, transform_with: ->(v) { str2i(v) }
  property :revenue,  transform_with: ->(v) { str2i(v) }

  property :title
  property :teaser

  property :city
  property :state


  # Many sites have cashflow and/or EBITDA and/or net profit, and brokers
  # don't use them consistently. Go with the lowest non-zero number.
  property :cashflow_from

  def cashflow
    self[:cashflow] || Array(self[:cashflow_from]).map {|k| self.class.str2i(k) }.reject {|v| v.zero? }.min
  end

  def passes_filters?(filters)
    filters.all? do |key, value|
      if key.to_s.include?('_') # Handle two-part value (e.g. min_cashflow)
        min_max, field = key.to_s.split('_').map(&:to_sym)
        passes_complex_filter?(field, min_max, value)
      else # Handle simple value (e.g. State = Washington)
        passes_simple_filter?(key, value)
      end
    end
  end

  private

  def passes_complex_filter?(field, min_max, value)
    return true unless self.keys.include?(field)

    case min_max
    when :min then self[field] >= value
    when :max then self[field] <= value
    else raise "Unknown complex filter: #{min_max}"
    end
  end

  def passes_simple_filter?(field, value)
    return true unless self.keys.include?(field)
    self[field] == value
  end

end