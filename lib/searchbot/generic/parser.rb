class Searchbot::Generic::Parser
  include Searchbot::Utils::Web

  attr_reader :source, :context, :url

  # If given HTML or Nokogiri, will process that. Otherwise, will pull from URL
  def initialize(html: nil, source:, context: , url: nil, options: {})
    @context = context
    @source = source
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
    raise "#parse must implemented in Searchbot::Sources::YYY::XxxParser subclasses (called from #{self.class.name})"
  end

  def html
    @html ||= fetch(url)
  end

  def doc
    @doc ||= html.respond_to?(:to_html) ? html : Nokogiri::HTML(html)
  end

  protected

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
    source.class.divider
  end

end