module Searchbot::Utils::LoggedInSearching

  # NOTE: this was extracted from a partial implementation for Latona.
  # Closer inspection showed logging in wasn't actually necessary to
  # extract the data we needed.
  #
  # This is currently unused, but should be 80% there if we find another
  # source that requires it in the future (roughly, this would get included
  # in the Searcher class, although it was written before the big architecture
  # overhaul, so will need a bit of testing and tuning to make it all smooth).

  attr_reader :username, :password

  def parse_options(opts)
    @username = opts[:username]
    @password = opts[:password]

    if username && password
      login
    else
      raise ArgumentError, "This source requires :username and :password keys"
    end
  end

  def login_url
    raise "login_url needs to be implemented"
  end

  def authentication_hash
    {
      email: username,
      password: password,
    }
  end

  def login
    return true if logged_in?

    response = HTTParty.post(login_url, headers: common_headers, body: authentication_hash)
    result   = JSON.parse(response)

    # TODO: This worked for Latonas - replace with generic // logic for the site in question
    if result['ret'] == 1
      set_cookies_from(response)
    else
      raise "Unable to log into Latonas with '#{username}' and provided password"
    end
  end

  def logged_in?
    !! cookies
  end

end