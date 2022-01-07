-- Update
local wifi = require("internet")
upd = {"https://rawcdn.githack.com/DragoNext/DragoOS/34287c7e6fa27b5a34d892af64547256f369d715/dragoos.lua" ,"https://rawcdn.githack.com/DragoNext/DragoOS/34287c7e6fa27b5a34d892af64547256f369d715/update.luas"}
names = {"dragoos.lua","update.lua"}
for i = 1,2
do 
	local handle = wifi.request(upd[i])
	local result = ""
	for chunk in handle do result = result..chunk end 
	print(upd[i].." Updated")
	file = io.open(names[i],"w")
	file:write(result)
	file:close()
end 

