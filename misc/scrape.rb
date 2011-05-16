require 'rubygems'
require 'httparty'
require 'geocoder'

response = HTTParty.get('http://www.forksoverknives.com/showtimes/')
response.gsub!("\302\240"," ")
regex = /<p style="padding-left: 30px;"><strong>([A-Z| ]+,* [A-Z][A-Z]).*?<\/strong>(.*?)<\/p>/m
results = response.scan(regex)
print results.length
theaters = []
for match in results
	city = match[0]
	body = match[1]
	body.gsub!(/\|.*?<\/a>/m,'')
	body.gsub!(/<em>.*?<\/em>/m,'')
	body.gsub!(/<a.*?<\/a>/m,'')
	lines = body.split("<br />")
	lines = lines.map {|l|l.strip}.select {|l| not l.empty?}
	theaters << lines
	theaters.flatten!
	#latitude,longitude = Geocoder::coordinates(city)
	#print "#{city}\t#{latitude}\t#{longitude}\n"
end

regex = /<p style="padding-left: 30px;">(.*?)<\/p>/m
results = response.scan(regex)
for match in results
	body = match[0]
	if body["strong"]
		next
	end
	body.gsub!(/\|.*?<\/a>/m,'')
	body.gsub!(/<em>.*?<\/em>/m,'')
	body.gsub!(/<a.*?<\/a>/m,'')
	lines = body.split("<br />")
	lines = lines.map {|l|l.strip}.select {|l| not l.empty?}
	theaters << lines
	theaters.flatten!
end


print "Theaters #{theaters.length}\n"

for t in theaters
	t.gsub!(/\(.*?\)/,"")
	latitude,longitude = Geocoder::coordinates(t)
	print "#{t}\t#{latitude}\t#{longitude}\n"
end
