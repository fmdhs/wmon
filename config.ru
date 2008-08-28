#!/usr/bin/env ruby
$:.unshift File.dirname(__FILE__) + "/../lib"
require 'rubygems'
require 'camping'
require 'rack/adapter/camping'
  
Camping.goes :Website
 
module Website

end
 
module Website::Controllers
    class Index < R '/'
        def get
            render :index
        end
    end
 
    class View < R '/view/(\w+)', '/view/(\w+)/(\d+)' 
        def get(*args)
            @name = args[0]
            # Get all lines matching the name
            # Reverse the order so most current entry is first
            @lines = File.open("./log/fmdhs.log") {|f| f.grep /#{@name}+/}.reverse
            @lines = @lines[0...args[1].to_i] if args[1].to_i > 0
            render :view
        end
    end
     
    class Style < R '/styles.css'
        def get
            @headers["Content-Type"] = "text/css; charset=utf-8"
            @body = %{
body {
font-family: Utopia, Georga, serif;
}
h1.header {
background-color: #fef;
margin: 0; padding: 10px;
}
div.content {
padding: 10px;
}
}
        end
    end
end
 
module Website::Views
 
    def layout
      html do
        head do
          text "<meta http-equiv='Refresh' content='60'>"
          title 'FMDHS Website Monitor Log'
          link :rel => 'stylesheet', :type => 'text/css',
               :href => '/styles.css', :media => 'screen'
        end
        body do
          h1.header { a "FMDHS Website Monitor Log", :href => R(Index) }
          div.content do
            self << yield
          end
        end
      end
    end
 
    def index
      p do
         text "Choose a default filter "
         text "OR enter a URL of /view/'your search string'/'limit'"
         text ". Limit is optional"
      end
      ['ERROR','WARN', 'INFO'].each do |link_name|
        a link_name, :href => R(View, link_name, 30)
        br
      end
    end

    def view
      p { b "#{@lines.size.to_s} line(s) matching #{@name}" }
        for line in @lines
          text line
          br
        end
    end
 
end

run Rack::Adapter::Camping.new(Website)
