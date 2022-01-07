-- dragos
-- 0.003
local gpu = require("component").gpu
local internet = require("internet")
local io = require("io")
local event = require "event"
local thread = require("thread")
local banned_player = {"Majkaaa"}

local modules_list = {}

modules_list["charset"] = "nVf9B9dQ"

items = {}  

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

install_module("charset")

 
local screen_adress = gpu.getScreen() -- Current Screen #
local max_color_depth = gpu.maxDepth() -- Current max color depth (depends on screen)
 
local screen_xsize, screen_ysize  = gpu.getResolution() -- Width 
 
local dragoos_theme = 0 -- Theme index 
 
local dragoos_double_buffering = true -- turned on or off 

local buffer_1 = gpu.allocateBuffer(screen_xsize,screen_ysize+1)
local buffer_2 = gpu.allocateBuffer(screen_xsize,screen_ysize+1)
local dragoos_currentbuffer = buffer_1 

local ui_menuactive = false 
local ui_hide = false 



local color_themes = {
{0x00ff00,0x00ff00,0x00ff00}
}

local windows = {}


 
function setcolor (color)
    gpu.setBackground(color)
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
 
function draw_ui () 
	setcolor(0x000000)
	gpu.fill(0,0,0,screen_xsize," ") -- Top bar 
    setcolor(0x00aa00)
    gpu.fill(0,screen_ysize-2,screen_xsize+1,screen_ysize+1," ") -- taskbar 
    setcolor(0x0000ff) 
    gpu.fill(1,screen_ysize-2,5,screen_ysize-1," ") -- menu
    gpu.set(1,screen_ysize-1,"Menu")
    setcolor(0xff0000)
    gpu.fill(screen_xsize-4,screen_ysize-2,screen_xsize,screen_ysize+1," ")-- menu 
    gpu.set(screen_xsize-3,screen_ysize-1,"X")
    if ui_menuactive == true then
		setcolor(0xffffff)
        gpu.fill(0,screen_ysize-19,33,17," ")
    end 
    setcolor(0xff0000)
	
	gpu.set(screen_xsize-20,screen_ysize-1,tostring(date))----------------------------------------------------------------------------------------------------------------------
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

function add_window (x,y,w,h,title)
	items[tostring(random(0, 0xffff))] = {"window", x,y,w,h,title}
end 




function draw_items () 
	for _id ,vars in pairs(items) do
		types = vars[1]
		if types == "point" then 
			setcolor(vars[4])
			gpu.set(vars[2],vars[3],vars[5])
		elseif types == "window" then 
			-- draw window 
		end 
	end
end 
 
 
function event_loop()
	-- to do - Move Click into this 
	while true do 
	
		type_, adress_, x,y, _whatisthat, username = event.pull() -- Lastest event 
		
		
		
		if  type_ == "touch" then 
			color = 0xff0000
			if username == "Majkaaa" then 
				color = 0xff0000
			else 
				color = 0x4B0082
			end 

			add_point(x,y,color,"X - "..x..","..y)


			if (y > 47 and y < 50) then 
				if (x > 0 and x < 6) then
					if ui_menuactive == true then 
						ui_menuactive = false 
					elseif ui_menuactive == false then 
						ui_menuactive = true 
					end     
				end 
			end 
		end

	end 
end 

thread.create(event_loop):detach()
 
 
 
function add_event(type_,trg)
	-- Type > Drag, Drop, Touch
	-- Trg > Triggers (function) 
	
	
	
	
end  
 
 

while true do
	if dragoos_double_buffering == true then 
		switch_buffer() 
	end 
	
	local start_time = os.time()
	
	draw_wallpaper() 
	draw_items()
    draw_windows() 
    draw_ui()
	
	
	
	x=0
	for k,v in pairs(items) do
		gpu.set(1,1+x,tostring(k))
		gpu.set(22,1+x,tostring(v[1]))
		x = x + 1
	end 

	local end_time = os.time() - start_time
	
	gpu.set(5,5,tostring(end_time))
	gpu.set(6,6,tostring( ui_menuactive ))
	
	gpu.bitblt(0, 0,0 ,screen_xsize, screen_ysize+1, dragoos_currentbuffer, 0, 0)
	
    os.sleep(0)
end 