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


require "searchbot/version"
require "searchbot/inflectors"

SOURCES = %w(biz_buy_sell biz_quest business_broker empire_flippers f_e_international latonas website_closers)

module Searchbot
  module Generic; end

  module Results; end

  module Utils; end

  module Sources
    SOURCES.each do |source|
      const_set( Inflectors.camelize(source), Module.new)
    end
  end
end

require "searchbot/utils/parsing"
require "searchbot/utils/web"
require "searchbot/filters"
require "searchbot/results/base"
require "searchbot/results/details"
require "searchbot/results/listing"

require "searchbot/generic/concerns/html"
require "searchbot/generic/parser"

common = %w(searcher listings_page listing_parser detail_parser)

common.each {|file| require "searchbot/generic/#{file}" }

SOURCES.each do |source|
  common.each do |file|
    require "searchbot/sources/#{source}/#{file}"
  end
end


module Searchbot

  def self.business_sources
    [
      Searchbot::Sources::BizBuySell,
      Searchbot::Sources::BizQuest,
      Searchbot::Sources::BusinessBroker,
    ]
  end

  def self.website_sources
    [
      Searchbot::Sources::EmpireFlippers,
      Searchbot::Sources::WebsiteClosers,
      Searchbot::Sources::FEInternational,
      Searchbot::Sources::Latonas,
    ]
  end

  def self.sources
    business_sources + website_sources
  end

end