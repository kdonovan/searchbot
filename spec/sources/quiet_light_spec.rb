require 'spec_helper'
require 'sources/shared_specs'

describe Searchbot::Sources::QuietLight::Searcher do

  it_behaves_like 'a valid website source',
    searcher: Searchbot::Sources::QuietLight::Searcher

end
