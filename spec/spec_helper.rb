$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'searchbot'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/cassettes"
  config.hook_into :webmock # or :fakeweb
  config.configure_rspec_metadata!
end
