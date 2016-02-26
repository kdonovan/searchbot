require 'spec_helper'
require 'sources/shared_specs'

describe Searchbot::Sources::WebsiteClosers do

  it_behaves_like 'a valid website source',
    source: Searchbot::Sources::WebsiteClosers,
    max_pages: 2,
    expected_results: {
      Integer => [:cashflow, :price],
      String  => [:id, :title, :teaser, :link]
    }

end
