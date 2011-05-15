require 'rubygems'
require 'sinatra'


THEATERS = open("theaters.txt","r").read().split("\n").map{|x| {:name=>x.split("\t")[0], :latitude=>x.split("\t")[1], :longitude=>x.split("\t")[2]}}.select {|t|not (t[:latitude]==nil or t[:latitude]=='')}

GOOGLE_API_CODE = 'ABQIAAAA9OOBC0JIUjp2D8RWTK8KehT2yXp_ZAY8_ufC3CFXhHIE1NvwkxS-XTc7wgiqy8tNe92hPtXqqKOcWg' # localhost

get '/map' do
	erb open("map.html.erb","r").read()
end

def '/search' do
	
end
