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


SOURCES = %w(biz_buy_sell business_broker website_closers biz_quest latonas f_e_international)

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

require "searchbot/generic/searcher"
require "searchbot/generic/parser"
require "searchbot/generic/listings_page"
require "searchbot/generic/listing_parser"
require "searchbot/generic/detail_parser"

SOURCES.each do |source|
  require "searchbot/sources/#{source}/searcher"
  require "searchbot/sources/#{source}/listings_page"
  require "searchbot/sources/#{source}/listing_parser"
  require "searchbot/sources/#{source}/detail_parser"
end

require "searchbot/sources/base"
require "searchbot/sources/empire_flippers"


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