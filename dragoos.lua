-- dragos
-- 0.003
local gpu = require("component").gpu
local internet = require("internet")
local io = require("io")
local event = require "event"
local thread = require("thread")
local banned_player = {"Majkaaa"}

local screen_adress = gpu.getScreen() -- Current Screen #
local max_color_depth = gpu.maxDepth() -- Current max color depth (depends on screen)

local screen_xsize, screen_ysize  = gpu.getResolution() -- Width 

local dragoos_theme = 0 -- Theme index 

local dragoos_double_buffering = false -- turned on or off 
local dragoos_currentbuffer = 0
local buffer_1 = gpu.getActiveBuffer() 
local buffer_2 = gpu.allocateBuffer(screen_xsize,screen_ysize)

local ui_menuactive = false 
local ui_hide = false 

local color_themes = {
{0x00ff00,0x00ff00,0x00ff00}
}

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
    gpu.fill(0,0,screen_xsize,screen_ysize,' ')
end 

function draw_ui () 
    setcolor(0x00ff00)
    gpu.fill(0,screen_ysize,3,3," ") -- taskbar 
    setcolor(0x0000ff) 
    gpu.fill(0,screen_ysize-3,5,screen_ysize," ") -- menu
    gpu.set(0,screen_ysize-2,"Menu")
    setcolor(0xff0000)
    gpu.fill(screen_xsize-4,screen_ysize-3,screen_xsize,screen_ysize," ")-- menu 
    gpu.set(screen_xsize-3,screen_ysize-3,"X")
    if ui_menuactive == true then
        gpu.fill(0,screen_ysize-4,15,20," ")
    end 
    
end 

function create_window()
end 

function draw_windows ()
end 


function switch_buffer () 
end 



function os_startup ()
    for i = 1,screen_ysize 
	do 
        setcolor(0x800080)
        gpu.fill(0,0+i,screen_xsize,1," ")
        os.sleep(0)
    end 
end 












 
function clickevent(type_,adress_,x,y,idk,playername)
    if playername == "Majkaaa" then 
        setcolor(0xff0000)
    else 
        setcolor(0x00ff00)
    end 
    
    
    if (x >= 0 and x <= screen_xsize-3 and y <= screen_ysize-3 and y >= screen_ysize) then
        if ui_menuactive == true then 
            ui_menuactive = false 
        else 
            ui_menuactive = true 
        end     
        
    end 
    event.listen("touch", clickevent)
end


event.listen("touch", clickevent)








os_startup()
while true do
    draw_wallpaper() 
    draw_windows() 
    draw_ui()
    
    if dragoos_double_buffering == true then 
        switch_buffer() 
    end 
    os.sleep(0)
end 