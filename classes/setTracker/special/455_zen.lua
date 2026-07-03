--- Addon Namespace
local EPT = ExoYsProcSetTimer 


local ZensRedress = {}
EPT.initialize.setTracker.specialSets[455] = ZensRedress

--- Note 
--[[ 
I think making a file for each set could be a little over the top 
(and might also be less performand). 

so I should group sets.... 

there are roughly 900 sets in the game atm, so maybe split it up in 50 or 100er groups? 

or a similar structure as i will use in ProcSetData, something like overland, pvp, 
specific updates etc 

so this will still be id based grouping but a limits would be less arbitrary 
]]