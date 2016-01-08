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
end