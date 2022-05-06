-- events system for dragoos
local event = require("event")
event_list = {}  
event_update = false 
start_console = false 
console_return = ""
console_log = {} 
rc_menuactive = false 

local function uuid()
    return math.random(0x0000,0xffff)
end



-- Works <3
function add_event (event_type, args)
	-- event_type - Touch, Drag etc...
	-- Arguments in list
	--   - Touch 
	--     [x,y, x2,y2, function_onclick]
	--   - Drag 
	--      [Function]        ?? No Initializer ? 
	--   - Drop 
	--      [Function] 
	
	-- Function needs certain args for specyfic events 
	-- Touch - None 
	-- Drag - X,Y
	-- Drop - X,Y 
	-- key_up
	-- key_down
	
	local _ID = uuid() 
	
	event_list[_ID] = {event_type, args}
	
	event_update = true
	return _ID 
end 
function delete_event(ID) -- Pff lucky me that this is quite easy
	event_list[ID] = nil 
	event_update = true  -- Updates event loop 
end 

function edit_event (ID, args)  -- yup :)
	event_list[ID] = args 
	event_update = true  
end 





-- Check if coord is in 
function checkcoord(cx,cy,x,y,w,h);if (cx > x and cx < x+w) then ;if (cy >= y and cy < y+h) then ;return true  ;else ;return false ;end ;else;return false;end ;end 





function event_loop()
	-- to do - Move Click into this 
	events_touch = {}
	events_drag =  {}
	events_drop = {} 
	
	
	while (dragos_exit == false) do 
		
		if (event_update == true) then 
			event_update = false 
			events_touch = {}
			events_drag =  {}
			events_drop = {} 
			for _, event_ in pairs(event_list) do 
				if event_[1] == "touch" then 
					table.insert(events_touch, {event_[2][1],event_[2][2],event_[2][3],event_[2][4],event_[2][5]})
				elseif event_[1] == "drag" then 
					table.insert(events_drag, {event_[2][1],event_[2][2],event_[2][3],event_[2][4],event_[2][5]})
				elseif event_[1] == "drop" then 
					table.insert(events_drop, {event_[2][1],event_[2][2],event_[2][3],event_[2][4],event_[2][5]})
				end
				
			end 
		end 
	
		type_, adress_, x,y, button, username = event.pull() -- Lastest event 
		if type_ == "drag" and current_drag == nil then 
			type_, adress_, x,y, button, username = event.pull() 
			if type_ == "drag" and current_drag == nil then 
				type_, adress_, x,y, button, username = event.pull() 
				if type_ == "drag" and current_drag == nil then 
					type_, adress_, x,y, button, username = event.pull() 
				end 
			end 
		end 
	
		if type_ == "touch" then 
			if button == 0.0 then 
				if rc_menuactive == true then 
					rc_menuactive = false 
				end 
				color = 0xff0000
				if username == "Majkaaa" then 
					color = 0xff0000
				else 
					color = 0x4B0082
				end 
				for _, ev in pairs(events_touch)  do 
					if ev ~= nil then 
						if (checkcoord(x,y,ev[1],ev[2],ev[3],ev[4]) == true) then  
							ev[5](x,y)
						end
					end 
				end 
			else 
				if y < 49 then 
					rc_x = x  
					rc_y = y
					if rc_menuactive == false then 
						rc_menuactive = true 
					end 
				end
			end 		
		elseif type_ == "key_up" then 
			if x == 47 then 
				if start_console == false then 
					console = "" 
					start_console = true  
				else 
					start_console = false 
				end 
			elseif start_console == true then 
				if x > 31 then 
					console = console .. string.char(x)
				elseif x == 8 then 
					console = console:sub(1,-2)
				elseif x == 13 then 
					command = load(console)
					_,console_return = pcall(command) 
					if type(console_return) == "table" then
						crt = ""
						for k, v in pairs(console_return) do 
							crt = crt .." "..v 
						end 
						console_return = crt 
					end
					console_return = tostring(console).." | "..tostring(console_return)
					table.insert(console_log, console_return)
					console = "" 
				end 
			end 
		-- For now drop and drag events are direct as it impacts direct perfomance of os :<
		elseif type_ == "drop" then 
			if current_drag ~= nil then 
				drag_drop(x, y)
			end
		elseif type_ == "drag" then 
			if current_drag ~= nil then 
				dragging(x, y)
			end 
		end 
	end 
	-- Cleans global vars 
	events_touch = {}
	events_drag =  {} 
	events_drop = {} 
	events_list = {}
end 


