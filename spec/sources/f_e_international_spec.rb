require 'spec_helper'
require 'sources/shared_specs'

describe Searchbot::Sources::FEInternational do

  it_behaves_like 'a valid website source',
    source: Searchbot::Sources::FEInternational,
    expected_results: {
      Integer => [:cashflow, :price],
      String  => [:id, :title, :teaser, :link]
    }

end
