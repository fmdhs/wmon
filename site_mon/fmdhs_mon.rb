require "./lib/hui"
require 'timeout'
require "log4r"
require "rufus/scheduler"
include Log4r

LOG_FILE = './log/fmdhs.log'
MAX_LOAD_TIME = 1

# Main FarCry instance
class FacultySite
  URL = "http://www.meddent.uwa.edu.au"
  def self.monitor
    browser = Browser.new
    browser.read_timeout MAX_LOAD_TIME
    browser.goto URL
    # Navigate a few links
    browser.link(:text, "Teaching & Learning").click
    browser.link(:text, "Education Centre").click
    # raise exception if the 'Teaching on the Run' link not found
    raise "is not able to get to Education Centre" unless browser.text.include?("Teaching on the Run")    
  end
end

class SphSite
  URL = "http://www.sph.uwa.edu.au"
  def self.monitor
    browser = Browser.new
    browser.read_timeout MAX_LOAD_TIME
    Timeout::Error
    begin
      browser.goto URL
    rescue Timeout::Error
      raise "is taking > #{MAX_LOAD_TIME} seconds to load"
    end
    raise "is not able to load home page" unless browser.text.include?("Faculty of Medicine, Dentistry and Health Sciences: School of Population Health")
  end
end

class OhcwaSite
  URL = "http://www.ohcwa.uwa.edu.au"
  def self.monitor
    browser = Browser.new
    browser.goto URL
    raise "is not able to load home page" unless browser.text.include?("http://www.ohcwa.uwa.edu.au/go/dentistry")
  end
end

class RcsSite
  URL = "http://www.rcs.uwa.edu.au"
  def self.monitor
    browser = Browser.new
    browser.goto URL
    raise "is not able to load home page" unless browser.text.include?("The Rural Clinical School of Western Australia")
  end
end

class MedicineSite
  URL = "http://www.medicine.uwa.edu.au"
  def self.monitor
    browser = Browser.new
    browser.goto URL
    raise "is not able to load home page" unless browser.text.include?("School of Medicine and Pharmacology")
  end
end

class RaineSite
  URL = "http://www.raine.uwa.edu.au"
  def self.monitor
    browser = Browser.new
    browser.goto URL
    raise "is not able to load home page" unless browser.text.include?("Raine Medical Research Foundation")
  end
end

class PaedsSite
  URL = "http://www.paediatrics.uwa.edu.au"
  def self.monitor
    browser = Browser.new
    browser.goto URL
    raise "is not able to load home page" unless browser.text.include?("School of Paediatrics and Child Health")
  end
end

# Web applications
class SupportSite
  URL = "https://support.meddent.uwa.edu.au"
  def self.monitor
    browser = Browser.new
    browser.goto URL
    raise "is not able to load home page" if browser.button(:name, "login").nil?
  end
end

class SurveysSite
  URL = "https://surveys.meddent.uwa.edu.au"
  def self.monitor
    browser = Browser.new
    browser.goto URL
    raise "is not able to load home page" if browser.button(:name, "ImgSubmit").nil?
  end
end

class DekiSite
  URL = "https://deki.meddent.uwa.edu.au"
  def self.monitor
    browser = Browser.new
    browser.goto URL  
    raise "is not able to load home page" unless browser.text.include?("MindTouch Deki Wiki")
  end
end

class OptionsSite
  URL = "https://options.meddent.uwa.edu.au"
  def self.monitor
    browser = Browser.new
    browser.goto URL
    browser.link(:text, "Log In").click
    browser.button(:text, "Log in").exists?
    raise "is not able to get to login page" if browser.button(:value, "Log in").nil?
  end
end

class WebmailSite
  URL = "https://webmail.meddent.uwa.edu.au"
  def self.monitor
    browser = Browser.new
    browser.goto URL
    raise "is not able to get to login page" if browser.button(:name, "SubmitCreds").nil?
  end
end

class FacboardSite
  URL = "http://www.meddent.uwa.edu.au/facboard/admin/"
  def self.monitor
    browser = Browser.new
    browser.goto URL
    raise "is not able to get to login page" if browser.button(:name, "Login").nil?
  end
end

# External hosted websites
class WirfSite
  URL = "http://www.wirf.com.au"
  def self.monitor
    browser = Browser.new
    browser.goto URL  
    raise "is not able to load home page" unless browser.text.include?("WIRF: Home")
  end
end

class LeiSite
  URL = "http://www.lei.org.au"
  def self.monitor
    browser = Browser.new
    browser.goto URL   
    raise "is not able to load home page" unless browser.text.include?( "Lions Eye Institute: Home")
  end
end

class HealthRightSite
  URL = "http://www.healthright.org.au"
  def self.monitor
    browser = Browser.new
    browser.goto URL   
    raise "is not able to load home page" unless browser.text.include?( "HealthRight: Welcome to HealthRight")
  end
end

# A test
# class TestSite
#   URL = "http://options.localhost"
#   def self.monitor
#     browser = Browser.new
#     browser.goto URL   
#     raise "is not able to load home page" unless browser.text.include?("Log In")
#   end
# end

$sitelog = Logger.new 'sitelog'

# Uncomment for output to log file
# format = PatternFormatter.new(:pattern => "[ %d ] %l\t %m")
# $sitelog.add FileOutputter.new('fileOutputter', :filename => LOG_FILE, :trunc => false, :formatter => format)

# Uncomment for stdout to console
$sitelog.outputters = Outputter.stdout

scheduler = Rufus::Scheduler.new

trap("INT") do
  $sitelog.info "stopping SiteMon..."
  scheduler.stop
end

scheduler.start
monitered_websites = [SphSite,FacultySite,SupportSite,DekiSite,OptionsSite,
                      WirfSite,LeiSite,HealthRightSite,MedicineSite,OhcwaSite,
                      PaedsSite,SurveysSite,RcsSite,WebmailSite,FacboardSite]

def notify(website,message)
  $sitelog.error "#{website.const_get('URL')}, #{message}" if message.include? "Unable to navigate"
  $sitelog.warn "#{website.const_get('URL')} #{message}" if message.include? "is not able to"
  $sitelog.warn "#{website.const_get('URL')} #{message}" if message.include? "is taking"
  $sitelog.warn "#{website.const_get('URL')} #{message}" if message.include? "not found"
  $sitelog.info "#{website.const_get('URL')} #{message}" if message.include? "is up"
end

$sitelog.info "starting SiteMon..."
scheduler.schedule_every "180s", :first_in => "5s" do
  monitered_websites.each do |site|
    begin
      start_time = Time.now
      site.monitor
      end_time = Time.now
      # Uncomment if log of 'up' websites is required => large log!
      notify site, "is up (load time #{end_time - start_time} secs)"
    rescue Timeout::Error
      notify(site, "is taking > #{MAX_LOAD_TIME} seconds to load")
      puts "Timeout error"
    rescue => ex
      notify site, ex.message
    end
  end
end

scheduler.join
