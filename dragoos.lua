-- dragos
local gpu = require("component").gpu
local internet = require("internet")
local io = require("io")


local screen_adress = gpu.getScreen() -- Current Screen #
local max_color_depth = gpu.maxDepth() -- Current max color depth (depends on screen)

local screen_xsize, local screen_ysize  = gpu.getResolution() -- Width 

local dragoos_theme = 0 -- Theme index 

local dragoos_double_buffering = false -- turned on or off 
local dragoos_ = 0

function switch_buffering () 
    if dragoos_double_buffering == false then 
        dragoos_double_buffering = true 
    else
        dragoos_double_buffering = false 
    end 
end 

function os_startup ()
    for i = 1,screen_ysize 
	do 
        gpu.fill(0,0+i,screen_xsize,1)
    end 
end 

os_startup()

