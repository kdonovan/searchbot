require 'spec_helper'
require 'sources/shared_specs'

describe Searchbot::Sources::WebsiteClosers::Searcher do

  it_behaves_like 'a valid website source',
    searcher: Searchbot::Sources::WebsiteClosers::Searcher,
    max_pages: 2

end
