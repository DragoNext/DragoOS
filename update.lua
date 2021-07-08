-- Update
local wifi = require("internet")
lnk = "http://raw.githubusercontent.com/DragoNext/DragoOS/main/"
upd = {"dragoos.lua","update.lua"}
for i = 1,2
do 
	local handle = wifi.request(lnk..upd[i])
	local result = ""
	for chunk in handle do result = result..chunk end 
	print(upd[i].." Updated")
	file = io.open(upd[i],"w")
	file.write(result)
	file.close()
end 

