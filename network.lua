-- Network.lua
event = require("event")
network = require("component").modem 
server_adress = nil 
network.open(256)

function get_server_address() 
	x=0
	while x==0 do 
		type_, my_adress, their_adress, port, idk, message = event.pull()
		if message == "server_adress" then 
			server_adress = their_adress
		end 
		if server_adress ~= nil then 
			x=1
		end 
	end 
end 

function check_server()
	if server_adress == nil then 
		get_server_address()
	end 
end 


function ping()
	check_server()
	local t = os.clock()
	network.send(server_adress,256,"ping")
	os.sleep(0)
	local gt=0
	local timeout=0 
	while gt == 0 do 
		_, _, _, _, _, message = event.pull()
		if message == "@-=3[]52l5[aclt£OD-%(£%" then -- 16 bytes 
			ping_ = os.clock() - t 
			gt = 1
		timeout = timeout + 1 
		elseif timeout > 10 then 
			gt=1;ping_ = nil 
		end 
	end 
	
	return ping_
end 

function get_season()
	check_server()
	
	network.send(server_adress,256,"get_season")
	local gt=0
	while gt == 0 do 
		type_, my_adress, their_adress, port, idk, message = event.pull()
		if message ~= nil  then 
			if string.sub(message,1,11) == "get_season:" then -- 16 bytes 
				gt = 1 
			end 
		end 
	end 
	return tonumber(string.sub(message,12,12))
end 