class Searchbot::Generic::Parser
  include Searchbot::Generic::Concerns::Html
  include Searchbot::Utils::Web
  include Searchbot::Utils::Parsing

  attr_reader :url

  # If given HTML or Nokogiri, will process that. Otherwise, will pull from URL
  def initialize(html: nil, url: nil, options: {})
    @url = url

    if html
      @html = html.respond_to?(:to_html) ? html.to_html : html
    end

    raise ArgumentError, "must provide either :html or :url" unless html || url
  end

  def result
    raise "Must be implemented in Searchbot::Generic::XXX subclasses"
  end

  def parse
    raise "Must be explicitly implemented, or implied by the use of the `parses` declaration"
  end

  def self.parses(*fields)
    fields_list = fields
    fields_list += [:city, :state] if fields.include?(:location)
    fields_list += [:cashflow] if fields.include?(:cashflow_from)

    define_singleton_method :fields_parsed do
      fields_list
    end

    define_method :parse do
      # Implement before hook - if it returns false, parse is never actually run
      do_parsing = !self.respond_to?(:before_parse) || before_parse
      return unless do_parsing

      fields.each_with_object({}) do |field, hash|
        hash[field] = get_parsed(field)
      end
    end
  end

  protected

  def get_parsed(field)
    if self.respond_to?(field)
      self.send(field)
    else
      raise "Automatic #parse implementation expects a method named '#{field}' in #{self.class.name}"
    end
  end

  def divider
    "\n\n\n"
  end

end