require 'rubygems'
require 'cgi'
require 'HTTParty'
require 'sinatra'
require 'theaters.rb'


# LOCAL HOST
# GOOGLE_API_CODE = 'ABQIAAAA9OOBC0JIUjp2D8RWTK8KehT2yXp_ZAY8_ufC3CFXhHIE1NvwkxS-XTc7wgiqy8tNe92hPtXqqKOcWg'
# FOK.HEROKU.COM
GOOGLE_API_CODE = 'ABQIAAAAb0Sv2hCd8UdPqsnJb4tlxhSuHW_e0bmW98OEDUUx7DH-1gkwmhR-nrpauXqPZUkA_fl4urXeYuDCDA' 
index_erb = open("map.html.erb","r").read()

set :public, 'static'

get '/' do
	erb index_erb
end

get	 '/search' do
	sources = params[:address]
	destinations = THEATERS.map{|t| "#{t.address}, #{t.city}  #{t.state}"}.join("|")
    url = "http://maps.googleapis.com/maps/api/distancematrix/json?origins=#{sources}&destinations=#{destinations}&mode=driving&sensor=false"
    escaped_url = CGI.escape_url(url)
	response = HTTParty.get(escaped_url).parsed_response
	elements = response[0]["elements"] # only one source
	
	index = 0
	results = THEATERS.map do |t|
		element = elements[index]
		index = index+1
		t["distance_text"] = element["distance"]["text"]
		t["distance_value"] = element["distance"]["value"]
		t["duration_text"] = element["duration"]["text"]
		t["duration_value"] = element["duration"]["value"]
		t["status"] = element["status"]
		end
	return results
end
		
	
