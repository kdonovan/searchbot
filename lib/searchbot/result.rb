class Result < Hashie::Dash
  property :id,      required: true
  property :link,    required: true

  property :cashflow
  property :revenue
  property :title
  property :teaser
  property :price

  attr_accessor :source_klass

  def initialize(source, *attrs)
    @source_klass = source.class
    super(*attrs)
  end

  def detail
    @detail ||= source_klass.result_details(link)
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