require 'rubygems'
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
	return params[:address]
end