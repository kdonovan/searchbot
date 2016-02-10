require 'spec_helper'
require 'sources/shared_specs'

describe Searchbot::Sources::BizQuest do

  it_behaves_like 'a valid source', source: Searchbot::Sources::BizQuest, expected_results: {
    Integer => [:cashflow, :price],
    String  => [:id, :title, :teaser, :link]
  }

end
