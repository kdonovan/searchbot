require 'hashie'
require 'nokogiri'
require 'httparty'

begin
  require 'pry'
rescue LoadError
end

class PreviouslySeen < StandardError; end


module Searchbot
  module Sources
  end

  module Results
  end

  module Utils
  end
end


require "searchbot/version"
require "searchbot/utils/parsing"
require "searchbot/filters"
require "searchbot/results/base"
require "searchbot/results/details"
require "searchbot/results/listing"
require "searchbot/sources/base"
require "searchbot/sources/business_broker"
require "searchbot/sources/biz_buy_sell"
require "searchbot/sources/biz_quest"

require "searchbot/sources/empire_flippers"


module Searchbot

  def self.sources
    [
      Searchbot::Sources::BizBuySell,
      Searchbot::Sources::BizQuest,
      Searchbot::Sources::BusinessBroker,
    ]
  end

end