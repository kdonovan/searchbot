class Searchbot::Generic::Parser
  include Searchbot::Utils::Web

  attr_reader :doc, :html, :source, :context

  def initialize(html: nil, source:, context: , url: nil)
    @context = context
    @source = source

    html = fetch(url) if html.nil?

    @html = html.respond_to?(:to_html) ? html.to_html : html
    @doc  = html.respond_to?(:to_html) ? html : Nokogiri::HTML(html)
  end



  def result
    raise "Must be implemented in Searchbot::Generic::XXX subclasses"
  end

  def parse
    raise "Must be implemented in Searchbot::Sources::YYY::XxxParser subclasses"
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


end