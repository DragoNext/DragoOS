-- Drago Operations
-- Add Ftp functionality 
-- Add File Downloader 
-- etc.
local json = require("json") --JSON FOR SERIALIZATION AND DESERIALIZATION OF TABLES


CWD = "/" 

DIRS = {}
DIRS["users"] = {}



function _create_file (filename,data)
	table.insert(DIRS[CWD], {filename,data})
end 

function _create_directory (directory)
	DIRS[directory] = {} 
end 

function update()
	paste = "bArVCdqZ" 
end 