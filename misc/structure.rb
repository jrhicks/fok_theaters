require 'pp'

def name(x)
	x.split("\t")[0]
end

def theater(x)
	name(x).split(",").map{|y| y.strip}[0]
end


def address(x)
	name(x).split(",").map{|y| y.strip}[1]
end

def city(x)
	name(x).split(",").map{|y| y.strip}[2]
end

def state(x)
	begin
		name(x).split(",").map{|y| y.strip}[3].split(" ")[0]
	rescue
	end
end

def zip(x)
	begin
		name(x).split(",").map{|y| y.strip}[3].split(" ")[1]
	rescue
	end
end

pp open("theaters.txt","r").read().split("\n").map{|x| {
	:name=>name(x), 
	:latitude=>x.split("\t")[1].to_f,
	:longitude=>x.split("\t")[2].to_f, 
	:start_date=>'', 
	:url=>'',
	:theater=>theater(x),
	:city=>city(x),
	:state=>state(x),
	:zip=>zip(x),
	:address=>address(x)} }