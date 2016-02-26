class Searchbot::Sources::Latonas < Searchbot::Sources::Base

  private

  attr_reader :username, :password

  def parse_options(opts)
    @username = opts[:username]
    @password = opts[:password]

    if username && password
      login
    else
      raise ArgumentError, "The Latonas source requires :username and :password keys"
    end
  end

  def authentication_hash
    {
      email: username,
      password: password,
    }
  end

  def login
    return true if logged_in?

    response = HTTParty.post(LOGIN_URL, headers: common_headers, body: authentication_hash)
    result   = JSON.parse(response)

    if result['ret'] == 1
      set_cookies_from(response)
    else
      raise "Unable to log into Latonas with '#{username}' and provided password"
    end
  end

  def logged_in?
    return true
    # TODO: TURN THIS BACK ON!!
    !! cookies
  end

end