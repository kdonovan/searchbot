require 'spec_helper'
require 'sources/shared_specs'

describe Searchbot::Sources::BizQuest::Searcher do

  it_behaves_like 'a valid business source',
    searcher: Searchbot::Sources::BizQuest::Searcher

end
