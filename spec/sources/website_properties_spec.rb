require 'spec_helper'
require 'sources/shared_specs'

describe Searchbot::Sources::WebsiteProperties::Searcher do

  it_behaves_like 'a valid website source',
    searcher: Searchbot::Sources::WebsiteProperties::Searcher

end
