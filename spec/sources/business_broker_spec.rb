require 'spec_helper'
require 'sources/shared_specs'

describe Searchbot::Sources::BusinessBroker::Searcher do

  it_behaves_like 'a valid business source',
    searcher: Searchbot::Sources::BusinessBroker::Searcher,
    expected_results: {
      Integer => [:cashflow, :revenue, :price],
      String => [:id, :title, :teaser, :link]
    }

end
