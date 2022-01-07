-- Update
local wifi = require("internet")
lnk = cz
upd = {"https://raw.githubusercontent.com/DragoNext/DragoOS/main/dragoos.lua" ,"https://raw.githubusercontent.com/DragoNext/DragoOS/main/update.lua"}
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

