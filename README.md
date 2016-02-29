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

Check the specs for intended usage.

## Data Flows

Given a set of filters:

```ruby
filters = Filters.new(min_cashflow: 100_000)
```

To search e.g. BizQuest:

```ruby
searcher = Searchbot::Sources::BizQuest::Searcher.new(filters)
searcher.listings
```

|Generic Class| Description|
|---|---|
|Searcher| Responsible for figuring out how to generate the search url (some sources allow filtering directly in the search, while for others we have to run the broader searches and then filter from the returned results|
|ListingsPage| Given the listing results page's url from Searcher, retrieves the data on that page. Responsible for breaking raw data into chunks to be passed off to ListingParser|
|ListingParser| Given a chunk of data (usually HTML) from ListingsPage, parse it into a standardized Result class. When we want additional information only available on the result's standalone page (e.g. the listings page usually shows a teaser, but the full description is only shown on a result-specific page), we invoke DetailParser|
|DetailParser|Given the general +Searchbot::Results::Listing+, parses out all the remaining details (usually by loading the listing's link and parsing remaining details from that page).|


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/searchbot.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

