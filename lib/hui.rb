$:.unshift File.dirname(__FILE__)
require 'rubygems'
require 'mechanize'
require 'rubyful_soup'
require 'lib/hui/soup_parser'
require 'lib/hui/container'
require 'lib/hui/webobjects'
require 'lib/hui/browser'



=begin
The tool is built to test a web application from server side by mocking a
browser. The tool uses Mechanize as the engine to work with web application and
validation.
=end

#~ startTime = Time.now
#~ browser = Browser.new
#~ browser.set_proxy('proxy.cognizant.com','6050')
#~ browser.goto('http://localhost:9999')
#~ browser.link(:text, 'Preferences').click
#~ browser.select_list(:name, 'hl').select "fr"
#~ browser.radio_button(:value, 'some').set 'ON'
#~ browser.check_box(:value, 'lang_fr').set 'ON'
#~ browser.button(:value, 'Save Preferences ').click
#~ browser.text_field(:name, 'q').set 'Hello'
#~ browser.button(:value, 'Google Search').click
#~ browser.links.each {|l| puts l.text if l.text =~ /[h|H]ello/}
#~ endTime = Time.now
#~ puts "Total time for running #{endTime - startTime} seconds"

#~ browser = Browser.new
#~ browser.goto "http://localhost:9999"
#~ browser.link(:text, "buttons1.html").click
#~ browser.button(:value,"Click Me").click
#~ puts browser.text.include?("PASS")
