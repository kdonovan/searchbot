require 'spec_helper'
require 'sources/shared_specs'

describe Searchbot::Sources::BizBroker24::Searcher do

  it_behaves_like 'a valid website source',
    searcher: Searchbot::Sources::BizBroker24::Searcher

end
