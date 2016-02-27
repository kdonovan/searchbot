class Searchbot::Sources::BusinessBroker < Searchbot::Sources::Base



    def retrieve_results
      @results = []
      more_pages = true
      curr_page = 1

      while more_pages do
        prev_length = @results.length

        begin
          unfiltered_results = parse_data_for_page(curr_page)
          unfiltered_results.select do |result|
            result.passes_filters?(filters)
          end.each do |result|
            raise PreviouslySeen if seen.include?(result.id)
            @results << result
          end
        rescue PreviouslySeen
          break
        end

        more_pages = @results.length > prev_length
        curr_page += 1
        break if max_pages && curr_page > max_pages
      end
    end


end
