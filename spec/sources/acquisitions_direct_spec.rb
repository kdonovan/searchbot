require 'spec_helper'
require 'sources/shared_specs'

describe Searchbot::Sources::AcquisitionsDirect::Searcher do

  it_behaves_like 'a valid website source',
    searcher: Searchbot::Sources::AcquisitionsDirect::Searcher

end
