--                          ██
--                  ██    ██
--          █████████████  ████                        ███████
--      ████  ███████████████                          █████████
--  ██████    █████████     ██   ████                  █      ███
--  ████████████████████████     ██████                █       ██
--    ██████  ██    ██████         ██████              █       ██
--    ██      ████      ██████   ████████              █       ██
--            ██        ██████   ██████████            █      ███
--        ██  ██        ██████   ██████████            ████████
--          ██        ██████   ██████████████          ████████
--                ██████████ ██    ████  ████
--        █████████████████  ████████████████          ████████
--  ██████████████████████ ██████    ████████          █████████
-- ███████████████████   ████████████████████          █       ██
--██████████████  ██  ███  ████    ██████  ██          █        ██
--██  ████████    ██  ███████  ██████████  ██          ██████████
--█  ████████            ██  ████████████   █          █████
--   ██████    ████        ██          ██              ██ ███
--  ██████       ████                    ██            ██  ███               █████████
--  ███████       ████  ████████████████               ██   ███             ██       ██
--  ████████      █████████████████████                                     ██       ██
--   ████████████████████████████████████                ███████            ██       ██
--     ███████████████████         ████████             ███   ███           ██       ██
--       █████████████         ██    ██████            ███     ███          ██       ██
--         ██████            ██████  ████████          ███████████           █████████
--           ██            ██████    ████████          ███████████
--                          █████████████  ██          ██       ██          ███████████
--         ██████████████████████████████   █          ██       ██          ██
--     ███████    █████████████████  ██                                     ██
--   ████              ██████      ██                   ██████████          ███████████
--   ██  ██              ██                            ███                           ██
-- ██  ██                                              ███   █████                   ██
--   ██           ██  ████████████                     ███      ██          ███████████
--   ██   ███      ██  ████       ██                   ███      ██
-- ██    ███████  ██████         ███                    ██████████
-- ████  ██  █████████         ████
-- ██████  █████████████                                ████████
--   ███████████████  ████                             ██      ██
--     ███████████                                     ██      ██
--              ██                                     ██      ██
--                                                     ██      ██
--                                                      ████████
-- Bugs:
--  	Add_event causes  events.lua to not works [V] Repaired it :3 Also improved clearing vars when closing
-- 
-- To Do Long Term:
--		Improve debugging if possible (Like man it's hard enough rn) 
-- 		Improve Dragging speed 
-- 		Add instalation
--		
-- To Do Short Term: 
-- 		
--		Add closing/minimizing mechanic to window item 
--		Add window_minimized item window <--> window_minimized 
--		Add icon item 
--		Make settings menu 
-- 		Make Basic app framework 
--		Make icon system on desktop


local gpu = require("component").gpu
local internet = require("internet")
local io = require("io")
local event = require("event")
local thread = require("thread")
local banned_player = {"Majkaaa"}
local modules_list = {}
modules_list["charset"] = "nVf9B9dQ"
modules_list["events"] = "" -- Not added to pastebin yett
items = {}  
console = ""
random = math.random -- Fuck math isnt imported globally



local function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

function _load_module (mod)
	dofile("/home/"..mod..".lua")
end 

function install_module (mod)
	if pcall(_load_module, mod) then 
		-- Installed module mod
	else
		os.execute("pastebin get "..modules_list[mod].." "..mod..".lua") 
		_load_module(mod)
	end 
end 
install_module("events")
install_module("charset")


local screen_adress = gpu.getScreen() -- Current Screen #
local max_color_depth = gpu.maxDepth() -- Current max color depth (depends on screen)
local screen_xsize, screen_ysize  = gpu.getResolution() -- Width 
local dragoos_theme = 0 -- Theme index 
local dragoos_double_buffering = true -- turned on or off 
local buffer_1 = gpu.allocateBuffer(screen_xsize,screen_ysize+1)
local buffer_2 = gpu.allocateBuffer(screen_xsize,screen_ysize+1)
local dragoos_currentbuffer = buffer_1 

local ui_hide = false 
dragos_exit = false 
ui_menuactive = false 
rc_menuactive = false 
rc_x = 0
rc_y = 0 

settings_window_exists = false 
settings_window_id = 0 

items_events = {} 

ev_x_1 = false 
local color_themes = {
{0x00ff00,0x00ff00,0x00ff00}
}

local windows = {}

function setcolor (color)
    gpu.setBackground(color)
end

function fsetcolor (color) --  Foreground SetColor
    gpu.setForeground(color)
end 
 
function switch_buffering () 
    if dragoos_double_buffering == false then 
        dragoos_double_buffering = true 
    else
        dragoos_double_buffering = false 
    end 
end 



function add_icon (icon, text, onclick) 
	items[tostring(random(0, 0xffff))] = {"icon", text, onclick}
end 

function add_point (x,y,color, l)
	items[tostring(random(0, 0xffff))] = {"point",x,y,color,l} 
end 

function add_window (x,y,w,h,title,inside)
	items[tostring(random(0, 0xffff))] = {"window", x,y,w,h,title,inside,{},{}}
	-- Last arg is if its dragged 
end 

function add_button (x,y,w,h,text,color,fcolor,onclick)
	items[tostring(random(0, 0xffff))] = {"button", x,y,w,h,text,color,fcolor,onclick}
end 




function delete_item (itemid) 
	items[itemid] = nil -- Logically it should just replace with value nil (But it removes entry ._. )  
end 
 
function draw_wallpaper () 
    setcolor(0x450a45)
    gpu.fill(0,-1,screen_xsize,screen_ysize+4,' ')
end 

function create_window_settings (x,y)
	if settings_window_exists == true then -- forces only one window to exist 
		-- repair it somehow ??? delete_item(settings_window_id)
		settings_window_exists = false 
	end 
	settings_window_id = add_window(10,10,30,18,"Ustawienia",{{"text",0,0,"Ustawienia",0x000000,win_tsk_color},{"text",3,3,"Double Bufforowanie",0x000000,win_in_color},{"text",3,5,"Pokaz Czas",0x000000,win_in_color},{"text",3,7,"DragoOsTheme: Standard",0x000000,win_in_color},{"text",3,9,"RAM:",0x000000,win_in_color},{"livetext",6,9,"NONE",0x000000,win_in_color,RAM_USED}})  -- Fucking retarded me 
	settings_window_exists = true 
	set_uimenuactive(0,0)
	
end 
 
function draw_ui () 
	setcolor(0x000000)
	gpu.fill(0,0,0,screen_xsize," ") -- Top bar 
    setcolor(0x00aa00)
    gpu.fill(0,screen_ysize-2,screen_xsize+1,screen_ysize+1," ") -- taskbar 
	fsetcolor(0x000000)
	setcolor(0x450a45) --Wallpaper bottom color
	gpu.set(0,screen_ysize-3,string.rep("_",160))-- taskbar black shadow
    fsetcolor(0xffffff)
	setcolor(0x0000ff) 
    gpu.fill(1,screen_ysize-2,5,screen_ysize-1," ") -- menu
    gpu.set(1,screen_ysize-1,"Menu")
    setcolor(0xff0000)
    gpu.fill(screen_xsize-4,screen_ysize-2,screen_xsize,screen_ysize+1," ")-- menu 
    gpu.set(screen_xsize-3,screen_ysize-1,"X")
    if ui_menuactive == true then
		setcolor(0xffffff)
        gpu.fill(0,screen_ysize-19,33,17," ")
		fsetcolor(0x000000)
		gpu.set(1,screen_ysize-19,"DragoOS v0.1")
		gpu.set(0,screen_ysize-6,"_________________________________")
		gpu.set(12,screen_ysize-4,"Ustawienia")
		gpu.set(0,screen_ysize-9,"_________________________________")
		gpu.set(12,screen_ysize-7,"Aplikacje")
		gpu.set(0,screen_ysize-12,"_________________________________")
		gpu.set(10,screen_ysize-10,"DragoAppStore")
		ev_x_1 = add_event("touch",{0,screen_ysize-5,33,3,create_window_settings})
		fsetcolor(0xffffff)
    end 
	if rc_menuactive == true then
		setcolor(0xffffff)
		fsetcolor(0x000000)
		gpu.set(rc_x+1,rc_y-1,"Refresh   ")
		gpu.set(rc_x+1,rc_y-2,"New       ")
		if rc_onfile == true then 
			gpu.set(rc_x+1,rc_y-3,"Delete    ")
			gpu.set(rc_x+1,rc_y-4,"Rename    ")
			gpu.set(rc_x+1,rc_y-5,"Propreties")
		end 
		fsetcolor(0xffffff)
	end 
	setcolor(0x00aa00)
	gpu.set(screen_xsize-15,screen_ysize-1,tostring(os.date("%H:%M:%S")))
	setcolor(0xff0000)
end 
 
function switch_buffer () 
	if gpu.getActiveBuffer() == buffer_1 then 
		gpu.setActiveBuffer(buffer_2)
		dragoos_currentbuffer = buffer_2
	else  
		gpu.setActiveBuffer(buffer_1)
		dragoos_currentbuffer = buffer_1
	end 
end 


 
function os_startup ()
    for i = 1,screen_ysize 
    do 
        setcolor(0xff0000)
        gpu.fill(0,0+i,screen_xsize,1," ")
        os.sleep(0)
    end 
end 
 




-- EVENTS 

function set_uimenuactive(x,y)
	if ui_menuactive == true then 
		ui_menuactive = false 
		delete_event(ev_x_1)
	elseif ui_menuactive == false then 
		ui_menuactive = true 
	end     
end 
function exit_os(x,y);dragos_exit = true;end  


event_drag_drag = nil 
current_drag = nil 


function dragging (x,y)
	if current_drag ~= nil then
	
		items[current_drag][2] = x 
		items[current_drag][3] = y
	end 
end 

function drag_drop (x, y)
	if current_drag ~= nil then 
		current_drag = nil 
	end
end 

function set_drag (x,y)
	for _id, vars in pairs(items) do 
		local x_c = 0 
		if vars[1] == "window" then 
			x_c = x_c + 1 
			if checkcoord(x,y, vars[2], vars[3], vars[4]-1, 1) == true then
				table.insert(items, 1, table.remove(items, x_c)) -- Moves window to top ?
				current_drag = _id 
			elseif checkcoord(x,y, vars[2]+vars[4]-2, vars[3], 2, 1) == true then
				delete_item(_id)
			else 
				for _, v in pairs(vars[9]) do -- Other Events on window like check buttons etc 
					-- Basicaly structure is like that:
					-- {X,Y,W,H, EVENT_FUNCTION, EVENT_STATE)
					--
					-- Event function 
					-- event (x , y)up
					--  y - Event state
					--
					-- So to change event state inside do: items[x][9][6] = NEW_EVENT_STATE 
					--
					if checkcoord(x,y, v[1], v[2], v[3], v[4]) == true then 
						v[5](_id,v[6]) 
					end 
				end 
			end 
		end 
	end 
end 

function livetextupdate ()
	for _id, vars in pairs(items) do 
		if vars[1] == "window" then 
			if vars[7][1] == "livetext" then 
				vars[7][4] = RAM_USED
			end
		end 
	end 
end 

add_event("touch",{0,47,6,6,set_uimenuactive})
add_event("touch",{155,47,6,6,exit_os})
add_event("touch",{0,0,160,50,set_drag})


add_event("drop",{0,0,160,50,drag_drop})






-- Previous positions of window 
window_prevpos = {} 
-- Events on window (For moving window )
window_events = {} 


win_in_color = 0xefefef
win_tsk_color = 0x5a5a5a
win_ext_color = 0xfa0000

function draw_items () 
	for _id ,vars in pairs(items) do
		local x = x + 1
		local types = vars[1]
		if types == "point" then 
			setcolor(vars[4])
			gpu.set(vars[2],vars[3],vars[5])
		elseif types == "button" then 
			setcolor(vars[7])
			fsetcolor(vars[8]) 
			gpu.fill(vars[2],vars[3],vars[4],vars[5]," ")
			gpu.set(vars[2],vars[3]+math.floor((vars[5]/2)-0.5),vars[6])
			add_event("touch",{vars[2],vars[3],vars[4],vars[5],vars[9]})
		elseif types == "window" then 
			fsetcolor(0xffffff)
			setcolor(win_in_color)
			gpu.fill(vars[2],vars[3],vars[4],vars[5]," ")
			setcolor(win_tsk_color)
			gpu.fill(vars[2],vars[3],vars[4],1," ")
			gpu.set(vars[2],vars[3],vars[6])
			setcolor(win_ext_color)
			gpu.set(vars[2]+vars[4]-1,vars[3],"X")
			setcolor(win_tsk_color)
			-- Removed minimizing not implementing it yet 
			for _,tab in pairs(vars[7]) do  
				if tab[1] == "rect" then 
					setcolor(tab[6])
					gpu.fill(vars[2]+tab[2],vars[3]+tab[3],tab[4],tab[5]," ")
				elseif tab[1] == "livetext" then 
					tab[4] = tab[7] 
					setcolor(tab[6])
					fsetcolor(tab[5])
					gpu.set(vars[2]+tab[2],vars[3]+tab[3],tab[4])
				elseif tab[1] == "text" then 
					setcolor(tab[6])
					fsetcolor(tab[5])
					gpu.set(vars[2]+tab[2],vars[3]+tab[3],tab[4])
				elseif tab[1] == "button" then 
					-- tab[1] -  x   {"button", x,y,w,h,text,color,fcolor,onclick}
					setcolor(tab[7])
					fsetcolor(tab[8]) 
					gpu.fill()
				elseif tab[1] == "checkbox" then -- Me A dumbass
					-- add_event("touch",{vars[2]+tab[2],vars[3]+tab[3],1,1,ACTIVATED_EVENT})
				end 
				
			end
			
		end 
	end
end 

thread.create(event_loop):detach()

function get_time()
	local H = tonumber(os.date("%H"))
	local M = tonumber(os.date("%M"))-40
	if M > 60 then 
		M = M - 60
		H = H + 1
	elseif M < 0 then 
		H = H - 1 
		M = M + 60 
	end 
	return H..":"..M 
end 

 
RAM_SIZE = tostring(computer.totalMemory()/1024/1024)
RAM_USED = tostring((computer.totalMemory()-computer.freeMemory())/1024/1024)

while (dragos_exit == false) do
	if dragoos_double_buffering == true then 
		switch_buffer() 
	end 
	
	local start_time = os.time()
	
	
	livetextupdate ()
	draw_wallpaper() 
	draw_items()
    draw_ui()
	
	

	if start_console == true then
		setcolor(0x006400)
		gpu.fill(0,0,160,51," ") 
		
		l=0 
		for _, v in pairs(console_log) do 
			gpu.set(1,1+l,v)
			l = l  + 1
		end 
		gpu.set(1,1+l,">"..console)
		l = l + 1
		gpu.set(1,1+l,console_return)
	end 

	local end_time = os.time() - start_time
	
	
	gpu.bitblt(0, 0,0 ,screen_xsize, screen_ysize+1, dragoos_currentbuffer, 0, 0)
	os.sleep(0)
	
	RAM_USED = tostring((computer.totalMemory()-computer.freeMemory())/1024/1024)
end 
gpu.freeBuffer(buffer_1)
gpu.freeBuffer(buffer_2)
gpu.setActiveBuffer(0)
items = {} -- cleans items on exit 
os.execute("cls")