require 'spec_helper'

describe Searchbot::Results::Base do
  base_params = {identifier: 1, link: 'testing'}

  context "#parse_location" do
    locations = {
      'Seattle, WA' => ['Seattle', 'WA'],
      'Seattle Metro, Washington' => ['Seattle Metro', 'WA'],
      'Washington' => [nil, 'WA'],
      'WA' => [nil, 'WA'],
      'Canada' => [nil, nil],
      'FT. WHEREVER, FLORIDA' => ['Ft. Wherever', 'FL'],
      'FT.NOSPACE, FLORIDA' => ['Ft. Nospace', 'FL'],
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

  context "keyword filter" do
    let(:filter) { Filters.new(keyword: 'awesome') }
    let(:awesome1) { Searchbot::Results::Base.new(base_params.merge(title: 'This is awesome'))}
    let(:awesome2) { Searchbot::Results::Base.new(base_params.merge(title: 'This is cool', teaser: 'Awesome things happen here!'))}
    let(:awesome3) { Searchbot::Results::Details.new(base_params.merge(title: 'This is cool', description: 'Awesome things happen here!'))}
    let(:boring)   { Searchbot::Results::Base.new(base_params.merge(title: 'This is kinda boring', ))}

    it "properly parses" do
      expect( awesome1.passes_filters?(filter) ).to be true
      expect( awesome2.passes_filters?(filter) ).to be true
      expect( awesome3.passes_filters?(filter) ).to be true
      expect( boring.passes_filters?(filter) ).to be false
    end
  end

end