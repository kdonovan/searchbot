require 'spec_helper'

describe Sources::BusinessBroker do

  let(:filters) { Filters.new(min_cashflow: 150_000) }
  let(:broker)  { Sources::BusinessBroker.new(filters) }
  let(:results) { broker.results }

  it 'returns values', :vcr do
    expect(results.length).not_to eq(0)
  end

end
