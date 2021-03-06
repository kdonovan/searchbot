RSpec.shared_examples "a valid website source" do |config|
  it_behaves_like "a valid source", config
end

RSpec.shared_examples "a valid business source" do |config|
  it_behaves_like "a valid source", {filter_location: true}.merge(config)
end

RSpec.shared_examples "a valid source" do |config|

  vcr_opts = {match_requests_on: [:method, :uri, :body]}

  cname = ->(name) {
    [config[:searcher].name.gsub('::', '_'), name].join('/')
  }

  context "shared specs" do
    let(:filters) { Filters.new(min_cashflow: 10_000) }
    let(:searcher)  do
      config[:searcher].new(filters).tap do |s|
        s.max_pages = config[:max_pages] || 1
      end
    end
    let(:results) { searcher.listings }

    context "faked", vcr: vcr_opts do

      context "listing", vcr: vcr_opts.merge(cassette_name: cname['listing']) do

        it 'returns results' do
          expect(results.length).not_to eq(0)
          expect(results.first).to be_a Searchbot::Results::Listing
        end

        context "result" do
          let(:result) { results.first }

          config[:searcher].new({}).fields_from_listing.each do |key|

            it "has valid #{key}" do
              at_least_one_valid = results.any? do |result|
                val = result.send(key)

                !val.nil? && val.to_s.length > 0
              end

              expect(at_least_one_valid).to be_truthy, "no examples have a valid #{key}"
            end

          end
        end

      end

      context "details", vcr: vcr_opts.merge(cassette_name: cname['detail'], record: :new_episodes) do

        let(:detail) { results.first.detail }

        it "looks up details for results" do
          expect(detail).to be_a Searchbot::Results::Details
        end

        it "returns detailed listings" do
          searcher.detailed_listings.take(10).each do |listing|
            expect(listing).to be_a Searchbot::Results::Details
          end
        end

        config[:searcher].new({}).fields_from_detail.each do |key|

            it "has valid #{key}" do
              at_least_one_valid = results.any? do |result|
                result = result.detail
                val = result.send(key)

                !val.nil? && val.to_s.length > 0
              end

              expect(at_least_one_valid).to be_truthy, "no examples have a valid #{key}"
            end

          end

      end

      custom_filters = {
        ratio: 3,
        hours_required: 2,
        max_revenue: 400_000,
        max_price: 300_000,
      }.merge(config[:custom_filters] || {})

      %i(price cashflow revenue ratio hours_required).each do |field|
        %i(min max).each do |direction|

          key = [direction, field].join('_').to_sym
          vcr_extra = if is_searchable = config[:searcher].searchable_filters.include?(key)
            {}
          else
            {cassette_name: cname["nonsearchable_details"], record: :new_episodes}
          end

          context "filters by #{direction} #{field}", vcr: vcr_opts.merge(vcr_extra) do
            let(:filters) { Filters.new(key => custom_filters[field] || custom_filters[key] || 200_000) }

            def can_handle?(f)
              handled = searcher.all_fields

              if f == :ratio
                handled.include?(:cashflow) && handled.include?(:price)
              else
                handled.include?(f)
              end
            end


            it "correctly (depending on results, doesn't always test every filter, but ensures none that are testable fail)" do
              if can_handle?(field)
                if results.length.zero?
                  msg = "No results at all for #{key}: #{filters.send(key)}"
                  pending msg
                  raise msg
                else
                  tested = 0

                  results.each do |result|
                    result = (result.respond_to?(:detail) && result.send(:detail_required_to_filter?, key)) ? result.detail : result

                    if val = result.send(field)
                      tested += 1
                      if direction == :min
                        expect(val).to be >= filters.send(key), lambda { "Expected #{field} to be larger than #{filters.send(key)}, but was #{val}"}
                      else
                        expect(val).to be <= filters.send(key), lambda { "Expected #{field} to be smaller than #{filters.send(key)}, but was #{val}"}
                      end
                    end
                  end

                  expect(tested).to be > 0, lambda { "Failed to find any results with a valid entry for #{field}" }
                end
              end
            end
          end

        end
      end


      if config[:filter_location]
        context "filters by state" do

          let(:filters) { Filters.new(min_cashflow: 100_000, state: 'Washington') }

          it "correctly" do
            results.each do |result|
              expect(result.state).to eq 'WA'
            end
          end

        end

        context "filters by city" do

          let(:filters) { Filters.new(min_cashflow: 100_000, state: 'Washington', city: 'Seattle') }

          it "correctly" do
            results.each do |result|
              expect(result.state).to eq 'WA'
              expect(result.city).to match /Seattle/i
            end
          end

        end
      end

    end
  end
end