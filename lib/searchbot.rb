require 'hashie'
require 'nokogiri'
require 'httparty'
require 'dotenv'
Dotenv.load

begin
  require 'pry'
rescue LoadError
end

class PreviouslySeen < StandardError; end


module Searchbot

  BUSINESS_SOURCE_NAMES = %w(biz_buy_sell biz_quest business_broker)
  WEBSITE_SOURCE_NAMES  = %w(empire_flippers f_e_international latonas website_closers acquisitions_direct i_acquisitions website_properties quiet_light biz_broker_24)

  def self.business_source_names
    BUSINESS_SOURCE_NAMES
  end

  def self.website_source_names
    WEBSITE_SOURCE_NAMES
  end

  def self.source_names
    business_source_names + website_source_names
  end

  module Generic; end

  module Results; end

  module Utils; end

end

require "searchbot/version"
require "searchbot/inflectors"
require "searchbot/utils/parsing"
require "searchbot/utils/web"
require "searchbot/filters"
require "searchbot/results/base"
require "searchbot/results/details"
require "searchbot/results/listing"

require "searchbot/generic/concerns/html"
require "searchbot/generic/parser"

module Searchbot
  module Sources
    Searchbot.source_names.each do |source|
      const_set( Inflectors.camelize(source), Module.new)
    end
  end
end

common = %w(searcher listings_page listing_parser detail_parser)

common.each {|file| require "searchbot/generic/#{file}" }

Searchbot.source_names.each do |source|
  common.each do |file|
    require "searchbot/sources/#{source}/#{file}"
  end
end

module Searchbot
  def self.business_sources
    classes BUSINESS_SOURCE_NAMES
  end

  def self.website_sources
    classes WEBSITE_SOURCE_NAMES
  end

  def self.sources
    business_sources + website_sources
  end

  def self.classes(names)
    names.map do |source|
      Searchbot::Sources.const_get( Inflectors.camelize(source) )
    end
  end
end
