require '..\hui.rb'

startTime = Time.now
ie = Browser.new
ie.set_proxy('proxy.cognizant.com','6050')
ie.goto('http://www.google.com')
ie.link(:text, 'Preferences').click
ie.select_list(:name, 'hl').select "fr"
ie.radio_button(:value, 'some').set 'ON'
ie.check_box(:value, 'lang_fr').set 'ON'
ie.button(:value, 'Save Preferences ').click
ie.text_field(:name, 'q').set 'Hello'
ie.button(:value, 'Google Search').click
ie.links.each {|l| puts l.text if l.text =~ /[h|H]ello/}
endTime = Time.now
puts "Total time for running #{endTime - startTime} seconds"