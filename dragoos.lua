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
 
function draw_wallpaper () 
    setcolor(0x800080)
    gpu.fill(0,-1,screen_xsize,screen_ysize+4,' ')
end 

function create_window_settings ()
	add_window(10,10,20,6,"Ustawienia",{"rect",0,0,10,1,0xff0000},false) 
end 
 
function draw_ui () 
	setcolor(0x000000)
	gpu.fill(0,0,0,screen_xsize," ") -- Top bar 
    setcolor(0x00aa00)
    gpu.fill(0,screen_ysize-2,screen_xsize+1,screen_ysize+1," ") -- taskbar 
	fsetcolor(0x000000)
	setcolor(0x800080) --Wallpaper bottom color
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
		ev_x_1 = add_event("touch",{0,screen_ysize-3,26,2,create_window_settings})
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
 
function create_window()
	-- Windows args  
	-- 0-1 > Position
	-- 2-4 > Width,Height
	-- 5 > Window Title  
	table.insert(windows,{0,0,0,0,""})
end 
 
function draw_windows ()
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
 
function add_point (x,y,color, l)
	items[tostring(random(0, 0xffff))] = {"point",x,y,color,l} 
end 

function add_window (x,y,w,h,title,inside)
	items[tostring(random(0, 0xffff))] = {"window", x,y,w,h,title,inside,false}
	-- Last arg is if its dragged 
end 

function add_button (x,y,w,h,text,color,fcolor,onclick)
	items[tostring(random(0, 0xffff))] = {"button", x,y,w,h,text,color,fcolor,onclick}
end 

function nowindow_drag()
	-- disabless all window drags 
	for _id ,vars in pairs(items) do
		if vars[1] == "window" then 
			vars[8] = false 
		end 
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
add_event("touch",{0,47,6,6,set_uimenuactive})
add_event("touch",{155,47,6,6,exit_os})




function draw_items () 
	for _id ,vars in pairs(items) do
		x = x + 1
		types = vars[1]
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
			setcolor(0xefefef)
			gpu.fill(vars[2],vars[3],vars[4],vars[5]," ")
			setcolor(0x5a5a5a)
			gpu.fill(vars[2],vars[3],vars[4],1," ")
			gpu.set(vars[2],vars[3],vars[6])
			setcolor(0xfa0000)
			gpu.set(vars[2]+vars[4]-1,vars[3],"X")
			setcolor(0x00fa00)
			gpu.set(vars[2]+vars[4]-2,vars[3],"-")
			for _,tab in pairs(vars[7]) do  
				
				if tab[1] == "rect" then 
					setcolor(tab[6])
					gpu.fill(vars[2]+tab[2],vars[3]+tab[3],tab[4],tab[5]," ")
				end
				if tab[1] == "text" then 
					fsetcolor(tab[5])
					gpu.set(vars[2]+tab[2],vars[3]+tab[3],tab[4])
				end
				if tab[1] == "button" then 
					-- tab[1] -  x   {"button", x,y,w,h,text,color,fcolor,onclick}
					setcolor(tab[7])
					fsetcolor(tab[8]) 
					gpu.fill()
				end	
				--if tab[1] == "checkbox" then 
					-- add_event("touch",{vars[2]+tab[2],vars[3]+tab[3],1,1,ACTIVATED_EVENT})
				--end 
			end
			
		end 
	end
end 


thread.create(event_loop):detach()

function get_time()
	H = tonumber(os.date("%H"))
	M = tonumber(os.date("%M"))-40
	if M > 60 then 
		M = M - 60
		H = H + 1
	elseif M < 0 then 
		H = H - 1 
		M = M + 60 
	end 
	return H..":"..M 
end 

 
 

while (dragos_exit == false) do
	if dragoos_double_buffering == true then 
		switch_buffer() 
	end 
	
	local start_time = os.time()
	
	draw_wallpaper() 
	draw_items()
    draw_windows() 
    draw_ui()
	
	
	gpu.set(1,10,tostring(start_console))

	
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
end 
gpu.freeBuffer(buffer_1)
gpu.freeBuffer(buffer_2)
gpu.setActiveBuffer(0)
items = {} -- cleans items on exit 
os.execute("cls")