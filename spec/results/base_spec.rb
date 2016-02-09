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
      'FT. WHEREVER, FLORIDA' => ['FT. WHEREVER', 'FL']
    }

    locations.each do |input, output|

      it "properly handles: #{input}" do
        base = Searchbot::Results::Base.new( base_params.merge(location: input) )
        expect( base.send(:parse_location) ).to eq output
      end

    end
  end

end