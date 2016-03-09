require 'spec_helper'
require 'sources/shared_specs'

describe Searchbot::Sources::BusinessMart::Searcher do

  # These need to be static for VCR to reuse requests
  class Searchbot::Sources::BusinessMart::Searcher < Searchbot::Generic::Searcher
    def submit_x
      13
    end

    def submit_y
      20
    end
  end

  it_behaves_like 'a valid business source',
    searcher: Searchbot::Sources::BusinessMart::Searcher


  describe '#price_for_search' do
    {
      [nil, 50_000] => 100,
      [110_000, 220_000] => 250,
      [220_000, 500_000] => 0,
      [450_000, 459_000] => 500,
      [450_000, 500_000] => 500,
      [450_000, 500_001] => 0,
      [nil, 2_000_000] => 9,
      [250_000, 2_000_000] => 0,
    }.each do |(min, max), expected|
      context "given min #{min || 'is nil'} and max #{max}" do
        let(:filters)  { Filters.new(min_price: min, max_price: max) }
        let(:searcher) { Searchbot::Sources::BusinessMart::Searcher.new(filters) }

        it "is #{expected}" do
          expect( searcher.send(:price_for_search) ).to eq expected
        end
      end
    end
  end

end
