require "../hui"
require "log4r"
require "rufus/scheduler"
include Log4r

class TestSite1
  URL = "http://localhost:9999"
  def self.monitor
    browser = Browser.new
    browser.goto URL
    browser.link(:text, "buttons1.html").click
    browser.button(:value,"Click Me").click
    raise "Not able to get PASS" unless browser.text.include?("PASS")    
  end
end

class TestSite2
  URL = "http://localhost:8888"
  def self.monitor
    browser = Browser.new
    browser.goto URL
    browser.link(:text, "links1.html").click
    browser.link(:text,"test1").click    
    raise "Not able to get Links2-Pass" unless browser.text.include?("Links2-Pass")
  end
end

$sitelog = Logger.new 'sitelog'
$sitelog.outputters = Outputter.stdout

scheduler = Rufus::Scheduler.new

trap("INT") do
  $sitelog.info "stopping SiteMon..."
  scheduler.stop
end

scheduler.start
monitered_websites = [TestSite1,TestSite2]

def notify(website,message)
  $sitelog.error "#{website.const_get('URL')} #{message}" if message.include? "Unable to navigate"
  $sitelog.warn "#{website.const_get('URL')} #{message}" if message.include? "not found"
end

$sitelog.info "starting SiteMon..."
scheduler.schedule_every "60s", :first_in => "5s" do
  monitered_websites.each do |site|
    begin
      site.monitor
    rescue => ex
      notify site, ex.message
    end
  end
end

scheduler.join
