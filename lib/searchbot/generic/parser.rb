class Searchbot::Generic::Parser
  include Searchbot::Generic::Concerns::Html
  include Searchbot::Utils::Web
  include Searchbot::Utils::Parsing

  attr_reader :url

  # If given HTML or Nokogiri, will process that. Otherwise, will
  # automatically pull the HTML in from the provided URL.
  def initialize(html: nil, url: nil, options: {})
    @url = url

    if html
      @html = html.respond_to?(:to_html) ? html.to_html : html
    end

    raise ArgumentError, "must provide either :html or :url" unless html || url
  end

  def parse
    raise "Must be explicitly implemented in subclass (or implied by the use of the `parses` declaration)"
  end

  def self.parses(*fields)
    fields_list = fields
    fields_list += [:city, :state] if fields.include?(:location)
    fields_list += [:cashflow] if fields.include?(:cashflow_from)

    define_singleton_method :fields_parsed do
      fields_list
    end

    define_method :parse do
      # Implement +before_parse+ hook - if it is present and returns false, skip parsing
      return if self.respond_to?(:before_parse) && before_parse

      fields.each_with_object({}) do |field, hash|
        hash[field] = get_parsed(field)
      end
    end
  end

  protected

  # Centralize logic here, so we can rely on this format when parsing description
  # from our own results down the line
  def description_section(title, body)
    "[#{sane title}]: #{sane body}"
  end

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