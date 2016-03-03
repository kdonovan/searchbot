module Searchbot
  class Results::Base < Hashie::Dash
    include Hashie::Extensions::Dash::PropertyTranslation
    extend Searchbot::Utils::Parsing

    property :searcher

    property :identifier,   required: true
    property :link,         required: true

    property :price,        transform_with: ->(v) { str2i(v) }
    property :cashflow,     transform_with: ->(v) { str2i(v) }
    property :revenue,      transform_with: ->(v) { str2i(v) }

    property :title,        transform_with: ->(v) { sane(v) }
    property :teaser,       transform_with: ->(v) { sane(v) }

    property :city,         transform_with: ->(v) { sane(v) }
    property :state,        transform_with: ->(v) { sane(v) }

    property :established,  transform_with: ->(v) { sane(v) }

    property :listed_at

    # We don't want to report it, but keep the raw HTML or JSON internally for examination
    # later (e.g. for FEInternational, can determine detail from raw listing alone)
    property :raw_listing

    # Many sites have cashflow and/or EBITDA and/or net profit, and brokers
    # don't use them consistently. Go with the lowest non-zero number.
    property :cashflow_from

    # Use this to filter out city, state as needed
    property :location,   transform_with: ->(v) { sane(v) }

    def cashflow
      self[:cashflow_from] ? Array(self[:cashflow_from]).map {|k| self.class.str2i(k) }.reject {|v| v.to_i.zero? }.min : self[:cashflow]
    end

    def ratio
      if cashflow && price
        price.to_f / cashflow
      end
    end

    def city
      self[:city] || parse_location[0]
    end

    # Always return the two-character state, if possible
    def state
      self.class.state_abbrev( self[:state] || parse_location[1] )
    end

    def search_time_filters
      [:keyword]
    end

    def passes_filters?(filters)
      passes_hardcoded_filters? && filters.all? do |key, value|
        # Skip any filters with nil values. Some filter keys are for search-time only, not after-search filtering.
        if value.nil? || search_time_filters.include?(key)
          true
        else
          # Some filters must be applied to the detailed version - if so, grab the details now
          to_test = (self.respond_to?(:detail) && detail_required_to_filter?(key)) ? self.detail : self
          to_test.passes_filter?(key, value)
        end
      end
    end

    def passes_filter?(key, value)
      constraint, field = explode_filter_key(key)

      # Default to skipping those without enough data
      return unless self.send(field)

      if constraint # Handle two-part value (e.g. min_cashflow)
        passes_complex_filter?(field, constraint, value)
      else # Handle simple value (e.g. State = Washington)
        passes_simple_filter?(key, value)
      end
    end

    # Modify reported keys to include those created from others (e.g. location, cashflow_from)
    # and hide those we don't want to show (e.g. raw, the raw source data)
    def keys
      super.tap do |raw|
        raw << :city  if city  && !raw.index(:city)
        raw << :state if state && !raw.index(:state)
        raw.delete(:location)

        raw << :cashflow if cashflow && !raw.index(:cashflow)
        raw.delete(:cashflow_from)

        raw.delete(:searcher)
        raw.delete(:raw_listing)
        raw.delete(:raw_details)
      end
    end

    private

    def explode_filter_key(key)
      return [nil, key] unless key.to_s.match(/(min|max)_/)

      k          = key.to_s
      constraint = k.include?('_') ? k.split('_').first.to_sym : nil
      field      = constraint ? k.split("#{constraint}_")[1].to_sym : key

      [constraint, field]
    end

    def detail_required_to_filter?(key)
      constraint, field = explode_filter_key(key)
      return false if search_time_filters.include?(field)
      return detail_required_to_filter_ratio? if field == :ratio

      if searcher.fields_from_listing.include?(field)
        false
      elsif searcher.fields_from_detail.include?(field)
        true
      else
        raise "#{searcher.listings_page.name} doesn't know how to parse '#{field}' from either listings or details"
      end
    end

    def detail_required_to_filter_ratio?
      goal = [:cashflow, :price]
      list_fields = searcher.fields_from_listing
      both_fields = searcher.all_fields

      (goal & list_fields).length < 2 && (goal & (both_fields)).length == 2
    end

    def parse_location
      return [] unless self[:location]

      city, state = self[:location].to_s.split(',').map(&:strip)
      state, city = city, state if state.nil? # e.g. "FL"
      city  = nil if city.to_s =~ /county/i
      state = nil if state == 'US'

      [handle_case( city ), self.class.state_abbrev(state)]
    end

    def handle_case(str)
      return unless str

      if str == str.downcase || str == str.upcase
        str.split('. ').map(&:strip).map(&:capitalize).join('. ')
      else
        str
      end
    end

    def passes_complex_filter?(field, min_max, value)
      case min_max
      when :min then self.send(field) >= value
      when :max then self.send(field) <= value
      else raise "Unknown complex filter: #{min_max}"
      end
    end

    def passes_simple_filter?(field, value)
      case field
      when :city # e.g. for Seattle, allow city = "Seattle Metro"
        city.to_s.match(/#{value}/)
      when :state # check both WA and Washington
        state == value || self.class.state_alt_display(state) == value
      when :keyword
        self.values.any? {|v| v.to_s.match(/#{keyword}/)}
      else
        self[field] == value
      end
    end

    # A collection of hardcoded filters
    def passes_hardcoded_filters?
      # If we have decent revenue, but cashflow is almost equal to revenue, that's sketchy
      return if cashflow && revenue && revenue > 200_000 && (cashflow > revenue - 50_000)

      true
    end

  end
end