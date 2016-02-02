require 'spec_helper'
require 'sources/shared_specs'

describe Sources::BizBuySell do

  let(:filters) { Filters.new(min_cashflow: 150_000, state: 'Washington') }
  let(:broker)  { Sources::BizBuySell.new(filters) }
  let(:results) { broker.results }

  it_behaves_like 'a valid source', expected_results: {
    Integer => [:cashflow, :price],
    String  => [:id, :title, :teaser, :link]
  }

end
