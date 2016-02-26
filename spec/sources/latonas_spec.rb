require 'spec_helper'
require 'sources/shared_specs'

describe Searchbot::Sources::Latonas::Searcher do

  it_behaves_like 'a valid website source',
    source: Searchbot::Sources::Latonas::Searcher,
    source_options: {
      username: ENV['LATONAS_USERNAME'],
      password: ENV['LATONAS_PASSWORD'],
    },
    expected_results: {
      Integer => [:cashflow, :price],
      String  => [:id, :title, :teaser, :link]
    }

end
