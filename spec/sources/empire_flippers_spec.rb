require 'spec_helper'
require 'sources/shared_specs'

describe Searchbot::Sources::EmpireFlippers do

  it_behaves_like 'a valid website source', source: Searchbot::Sources::EmpireFlippers, expected_results: {
    Integer => [:cashflow, :price],
    String  => [:id, :title, :teaser, :link]
  }

end
