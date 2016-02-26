RSpec.shared_examples "a valid website source" do |config|
  it_behaves_like "a valid source", config
end

RSpec.shared_examples "a valid business source" do |config|
  it_behaves_like "a valid source", config.merge(filter_location: true)
end

RSpec.shared_examples "a valid source" do |config|

  context "shared specs" do
    let(:filters) { Filters.new(min_cashflow: 100_000) }
    let(:source)  do
      config[:source].new(filters, config[:source_options] || {}).tap do |s|
        s.max_pages = config[:max_pages] || 1
      end
    end
    let(:results) { source.listings }

    context "faked", vcr: {match_requests_on: [:method, :uri, :body]} do

      it 'returns results' do
        expect(results.length).not_to eq(0)
        expect(results.first).to be_a Searchbot::Results::Listing
      end

      context "result" do
        let(:result) { results.first }

        config[:expected_results].each do |klass, keys|
          keys.each do |key|
            it "has valid #{key}" do
              val = result.send(key)
              expect(val.nil?).to be false
              expect(val.to_s).not_to eq ''
              expect(klass === val).to be true
            end
          end
        end

      end

      context "details" do
        let(:detail) { results.first.detail }

        it "looks up details for results" do
          expect(detail).to be_a Searchbot::Results::Details
        end

      end

      %w(price cashflow revenue).each do |field|
        %w(min max).each do |direction|
          context "filters by #{direction} #{field}" do
            let(:filters) { Filters.new("#{direction}_#{field}": 200_000) }

            it "correctly" do
              key = "#{direction}_#{field}".to_sym
              tested = 0

              results.each do |result|
                result = result.detail if filters.detail_only?(key)

                if val = result.send(field)
                  tested += 1
                  if direction == 'min'
                    expect(val).to be >= filters.send(key)
                  else
                    expect(val).to be <= filters.send(key)
                  end
                end
              end

              expect(tested).to be > 0
            end
          end

        end
      end


      if config[:filter_location]
        context "filters by state" do

          let(:filters) { Filters.new(min_cashflow: 100_000, state: 'Washington') }

          # it "correctly" do
          #   results.each do |result|
          #     expect(result.state).to eq 'WA'
          #   end
          # end

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