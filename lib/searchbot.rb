# It doesn't feel like I should have to do this if they're already in the gemspec...
require 'hashie'
require 'nokogiri'

require 'open-uri'

class PreviouslySeen < StandardError; end

def str2i(str)
  i = str.to_s.gsub(/[^\d.]/, '').to_i
end

# Some websites have some weird characters
def clean(string)
  string.force_encoding("ISO-8859-1").encode("UTF-8").squeeze(' ').strip
end

module Sources
end

require "searchbot/version"
require "searchbot/filters"
require "searchbot/result"
require "searchbot/sources/base"
require "searchbot/sources/business_broker"


module Searchbot
  # Your code goes here...
end

