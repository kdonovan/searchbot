# Searchbot

Searchbot is an adapter to various business listing websites, allowing searches to be automated and filters applied. It was created to scratch the very, very annoying itch of existing sites offering email alerts without any of the filters you'd actually care about if you were, you know, actually looking to buy a business.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'searchbot', github: 'kdonovan/searchbot'
```

And then execute:

    $ bundle


## Usage

Check the specs for detailed usage.  In brief, to search e.g. BizQuest:

```ruby
  filters  = Filters.new(min_cashflow: 100_000)
  searcher = Searchbot::Sources::BizQuest::Searcher.new(filters)
  listings = searcher.listings # or searcher.detailed_listings in you want each result to be fully prepopulated with its details
```

This will return an array of Searchbot::Results (specifically either `Searchbot::Results::Listing` or `Searchbot::Results::Detail`, depending on whether that specific result has fetched its detail page data yet).

For a web UI with some other useful goodies, check out [bizsearch](https://github.com/kdonovan/bizsearch).

### Data Flows


|Generic Class| Description|
|---|---|
| Searcher | Responsible for figuring out how to generate the search url (some sources allow filtering directly in the search, while for others we have to run broad searches and then filter from the returned results).|
| ListingsPage | Given the url from Searcher, retrieves that page and breaks the raw data into chunks to be passed off to ListingParser.|
| ListingParser | Given a chunk of data (usually HTML) from ListingsPage, parse it into a standardized Result class. When we want additional information only available on the result's standalone page (e.g. the listings page usually shows a teaser, but the full description is often only shown on a result-specific page), we invoke DetailParser.|
| DetailParser | Given a general `Searchbot::Results::Listing`, parses out all the remaining details (usually by loading the listing's link and parsing remaining details from that page).|

## TODOs

  * Use keyword as a search-based filter for those sites that support it
  * Add abstraction layer to allow applying multiple OR filters to one result set without re-requesting the raw listings data

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To add a new source, try using `bin/generate` to create placeholders for the required files.

  `bin/generate website some_source` or `bin/generate business some_source`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kdonovan/searchbot.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

