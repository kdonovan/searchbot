# It doesn't feel like I should have to do this if they're already in the gemspec...
require 'hashie'
require 'nokogiri'
require 'httparty'

class PreviouslySeen < StandardError; end

module Sources
end

require "searchbot/version"
require "searchbot/filters"
require "searchbot/result"
require "searchbot/detail_result"
require "searchbot/sources/base"
require "searchbot/sources/business_broker"
require "searchbot/sources/biz_buy_sell"


module Searchbot
  # Your code goes here...
end

