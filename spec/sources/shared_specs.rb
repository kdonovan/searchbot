RSpec.shared_examples "a valid source" do |config|

  context "faked", :vcr do

    it 'returns results' do
      expect(results.length).not_to eq(0)
      expect(results.first).to be_a Result
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
        expect(detail).to be_a DetailResult
      end

    end

  end


end