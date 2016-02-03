require 'spec_helper'
require 'sources/shared_specs'

describe Sources::BusinessBroker do

  it_behaves_like 'a valid source', source: Sources::BusinessBroker, expected_results: {
    Integer => [:cashflow, :revenue, :price],
    String => [:id, :title, :teaser, :link]
  }

end
