require 'spec_helper'

describe Searchbot::Results::Base do

  context "#parse_location" do
    base_params = {id: 1, link: 'testing'}
    locations = {
      'Seattle, WA' => ['Seattle', 'WA'],
      'Seattle Metro, Washington' => ['Seattle Metro', 'WA'],
      'Washington' => [nil, 'WA'],
      'WA' => [nil, 'WA'],
      'Canada' => [nil, nil],
      'FT. WHEREVER, FLORIDA' => ['Ft. Wherever', 'FL'],
      'King County, WA' => [nil, 'WA'],
      'seattle, wa' => ['Seattle', 'WA'],
      'sEATtle, Wa' => ['sEATtle', 'WA'],
    }

    locations.each do |input, output|
      context "'#{input}' -> '#{output.compact.join(', ')}'" do
        let(:input)  { input }
        let(:result) { Searchbot::Results::Base.new( base_params.merge(location: input) ) }

        it "properly parses" do
          expect( result.send(:parse_location) ).to eq output
        end

        it "properly displays" do
          expect( result.city ).to eq output[0]
          expect( result.state ).to eq output[1]
        end
      end

    end
  end

end