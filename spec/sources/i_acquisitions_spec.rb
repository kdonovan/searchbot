require 'spec_helper'
require 'sources/shared_specs'

describe Searchbot::Sources::IAcquisitions::Searcher do

  it_behaves_like 'a valid website source',
    searcher: Searchbot::Sources::IAcquisitions::Searcher

end
