=begin
Class works as a virtual browser making request and returning the reply
=end

class Browser
  include Container
  class << self
    attr_accessor :form
  end
  def set_proxy(*proxy)
    @proxy_host, @proxy_port = proxy
  end
  def goto(url)
    @agent = WWW::Mechanize.new
    @agent.pluggable_parser.html = SoupParser
    @agent.set_proxy(proxy[0], proxy[1]) if @proxy_host
    @page = @agent.get(url)
  rescue
    raise "Unable to navigate to #{url}"
  end
end


