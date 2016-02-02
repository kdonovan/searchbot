require 'spec_helper'
require 'sources/shared_specs'

describe Sources::BusinessBroker do

  let(:filters) { Filters.new(min_cashflow: 150_000, state: 'Washington') }
  let(:broker)  { Sources::BusinessBroker.new(filters) }
  let(:results) { broker.results }

  it_behaves_like 'a valid source', expected_results: {
    Integer => [:cashflow, :revenue, :price],
    String => [:id, :title, :teaser, :link]
  }

end
