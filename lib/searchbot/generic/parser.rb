class Searchbot::Generic::Parser
  include Searchbot::Generic::Concerns::Html
  include Searchbot::Utils::Web

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
    @@fields.each_with_object({}) do |field, hash|
      hash[field] = get_parsed(field)
    end
  end

  def self.parses(*fields)
    @@fields = fields
  end

  protected

  def get_parsed(field)
    # Put any custom mappings here
    field = 'identifier' if field = 'id'

    if self.respond_to?(field, true)
      self.send(field)
    else
      raise "Automatic #parse implementation expects a method named '#{field}' in #{self.class.name}"
    end
  end

  # Hook for subclasses to narrow down scope
  def prepare_doc(string)
    string
  end

  # Parsing utilities
  def sane(string)
    return unless string

    string.strip!
    if string && string.upcase == string
      string.downcase.split('.').map(&:capitalize).join('.')
    else string
    end
  end

  def divider
    "\n\n\n"
  end

end