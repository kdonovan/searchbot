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

  BUSINESS_SOURCES = %w(biz_buy_sell biz_quest business_broker)
  WEBSITE_SOURCES  = %w(empire_flippers f_e_international latonas website_closers acquisitions_direct)

  def self.business_sources
    BUSINESS_SOURCES
  end

  def self.website_sources
    WEBSITE_SOURCES
  end

  def self.sources
    business_sources + website_sources
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
    Searchbot.sources.each do |source|
      const_set( Inflectors.camelize(source), Module.new)
    end
  end
end

common = %w(searcher listings_page listing_parser detail_parser)

common.each {|file| require "searchbot/generic/#{file}" }

Searchbot.sources.each do |source|
  common.each do |file|
    require "searchbot/sources/#{source}/#{file}"
  end
end