-- Update
local wifi = require("internet")
lnk = "https://raw.githubusercontent.com/DragoNext/DragoOS/main/"
upd = {lnk.."dragoos.lua" ,lnk.."update.lua"}
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

