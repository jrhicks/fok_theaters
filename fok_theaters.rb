require 'rubygems'
require 'sinatra'
require 'theaters.rb'
require 'cgi'
require 'net/http'
require 'uri'

GOOGLE_API_CODE = 'ABQIAAAAb0Sv2hCd8UdPqsnJb4tlxhSuHW_e0bmW98OEDUUx7DH-1gkwmhR-nrpauXqPZUkA_fl4urXeYuDCDA' 

COUNT = 3

set :public, 'static'

get '/' do
	erb :index
end

get	 '/search' do
	# Geocode Source Address
	url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{CGI.escape(params[:address])}&sensor=false"
	data = Net::HTTP.get(URI.parse(url))
	return data
	response = HTTParty.get(url).parsed_response
	
	if response["status"]=="OK"
		@source_lat = response["results"][0]["geometry"]["location"]["lat"].to_f
		@source_lon = response["results"][0]["geometry"]["location"]["lng"].to_f
	else
		return "Unable to locate #{params[:address]}"
	end

	sorted_theaters = THEATERS.sort {|a,b| Math.sqrt((@source_lat-a[:latitude])**2+(@source_lon-a[:longitude])**2) <=> Math.sqrt((@source_lat-b[:latitude])**2+(@source_lon-b[:longitude])**2)}

	sources = params[:address]
	destinations = sorted_theaters.slice(0,COUNT).map{|t| "#{t[:address]}, #{t[:city]}  #{t[:state]}" }.join("|")
    url = "http://maps.googleapis.com/maps/api/distancematrix/json?origins=#{CGI.escape(sources)}&destinations=#{CGI.escape(destinations)}&mode=driving&sensor=false"
	
    response = HTTParty.get(url).parsed_response
	elements = response["rows"][0]["elements"] # only one source
	
	index = 0
	results = sorted_theaters.slice(0,COUNT).each do |t|
		element = elements[index]
		index = index+1
		t[:distance_text] = element["distance"]["text"]
		t[:distance_value] = element["distance"]["value"]
		t[:duration_text] = element["duration"]["text"]
		t[:duration_value] = element["duration"]["value"]
		t[:status] = element["status"]
		end
		
	@nearest = results.min {|a,b| a[:duration_value] <=> b[:duration_value]}
	
	erb :search
end
		
	
