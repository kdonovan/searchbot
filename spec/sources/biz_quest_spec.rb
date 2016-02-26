require 'spec_helper'
require 'sources/shared_specs'

describe Searchbot::Sources::BizQuest::Searcher do

  it_behaves_like 'a valid business source', source: Searchbot::Sources::BizQuest::Searcher, expected_results: {
    Integer => [:cashflow, :price],
    String  => [:id, :title, :teaser, :link]
  }

end
