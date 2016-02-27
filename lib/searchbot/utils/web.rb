module Searchbot::Utils::Web

  def fetch(url)
    html = HTTParty.get(url, headers: headers).body
    Nokogiri::HTML( html )
  end

  def fetch_json(url, params)
    response = HTTParty.post(
      url,
      headers: headers.merge('Content-Type' => 'application/json; charset=UTF-8'),
      body: params.to_json
    )

    JSON.parse( response.body )
  end

  private

  FIREFOX = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:43.0) Gecko/20100101 Firefox/43.0'

  # By default set user agent. If @cookies around, set those as well (to
  # handle logging in when necessary)
  def headers
    {
      'User-Agent' => FIREFOX,
      'Cookie'     => cookie_string,
    }.select {|k,v| !v.nil? }
  end

  attr_reader :cookies

  def cookie_string
    cookies ? cookies.to_cookie_string : nil
  end

  # Allow sending cookies with all requests by setting @cookies
  def set_cookies_from(resp)
    @cookies = parse_cookie(resp)
  end

  def parse_cookie(resp)
    cookie_hash = HTTParty::CookieHash.new
    resp.get_fields('Set-Cookie').each { |c| cookie_hash.add_cookies(c) }
    cookie_hash
  end

end