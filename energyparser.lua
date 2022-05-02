


function string_split(_,start_index,end_index) -- Usefull | Better than other methods -.-  confusing methods...
	local str = "" 
	local x = 0
	for v in string.gmatch(_,".") do  
		if (x >= start_index and x <= end_index) then 
			str = str .. v 
		end 
		x  = x + 1
	end 
	return str 
end 

function energy_parser (energy_amount)
	local _o = string.len(tostring(energy_amount)) - 2
	if _o < 3 then      -- Return self 
	
	elseif (_o>3 and _o<=6) then -- Return K 
		return string_split(tostring(energy_amount),0,_o-4) ..".".. string_split(tostring(energy_amount),_o-3,(_o-3)+2) .. "K" 
	elseif (_o>6 and _o<=9) then -- Return M
		return string_split(tostring(energy_amount),0,_o-7) ..".".. string_split(tostring(energy_amount),_o-6,(_o-6)+2) .. "M" 
	elseif (_o>9) then -- Return G 
		return string_split(tostring(energy_amount),0,_o-10) ..".".. string_split(tostring(energy_amount),_o-9,(_o-9)+2) .. "G" 
	end
end 