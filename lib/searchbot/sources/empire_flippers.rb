class Searchbot::Sources::EmpireFlippers < Searchbot::Sources::Base

  # This class actually uses the API directly for all search results, then applies
  # the filters to the returned items.

  BASE_URL = 'https://empireflippers.com/marketplace/'

  private

    def retrieve_results
      listings = all_listings_from_json

      # Simulate only grabbing a page of data, to speed up tests
      listings = listings.take(max_pages * 20) if max_pages

      @results = listings.select {|r| r.passes_filters?(filters) && !seen.include?(r.id) }
    end

    def all_listings_from_json
      section = HTTParty.get(BASE_URL).body.match(/window.efMarketplaceList = (.+?);\s*<\/script>/)

      JSON.parse(section[1]).map do |raw|
        next unless raw['listing_status'] == 'for_sale'

        Searchbot::Results::Listing.new(
          source_klass: self.class,
          price:        raw['price'].to_i,
          cashflow:     raw['net_profit'].to_i * 12,
          title:        [raw['monetization'], raw['niche']].join(' // '),
          link:         "https://empireflippers.com/listing/#{raw['listing_id']}/",
          id:           raw['listing_id'].to_s,
          teaser:       "Created: #{raw['date_created']}. Posted: #{raw['post_date']}.",
        )
      end.compact
    end

    def self.parse_result_details(listing, doc)
      reason = if h3 = doc.css('.listing--content h3').detect {|n| n.text == 'Reason for Sale'}
        h3.next.text
      end

      hours = if node = doc.at('.listing--hours')
        if hrs = node.text.scan(/(\d+)\s*hours/i).flatten.first
          hrs.to_i
        end
      end

      revenue = if rv = doc.at('.revenue')
        Searchbot::Utils::Parsing.str2i( rv.text ) * 12
      end

      {
        revenue:        revenue,
        description:    doc.at('.listing--description p').text,
        hours_required: hours,
        reason_selling: sane(reason),
      }
    end

end