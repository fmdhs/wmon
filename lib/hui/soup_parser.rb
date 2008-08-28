class SoupParser < WWW::Mechanize::Page
  attr_reader :soup
  def initialize(uri = nil, response = nil, body = nil, code = nil)
    @soup = BeautifulSoup.new(body)
    super(uri, response, body, code)
  end
end
