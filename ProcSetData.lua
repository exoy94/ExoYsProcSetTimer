ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer

--- To be moved somewhere else: 
EPT_SET_TYPE_PROC = 1
EPT_SET_TYPE_GROUP = 2
EPT_SET_TYPE_STACK = 3
EPT_SET_TYPE_TOGGLE = 4 

function EPT.GetSetTypeList() 
    return {
        EPT_SET_TYPE_PROC = "proc", 
        EPT_SET_TYPE_GROUP = "group", 
        EPT_SET_TYPE_STACK = "stack", 
        EPT_SET_TYPE_STACK = "toggle"
    }
end


local ProcSetData = {}

do --- overland sets 

    ProcSetData[101] = {    -- actual set name for easy find  
        itemlink = "", 
        setType = EPT_SET_TYPE_GROUP, 
        -- here more type specific properties
    } 

end 


do --- U31 (DLC - Waking Flame)
    ProcSetData[602] = {    -- Crimson Oath's Rive
        ["itemlink]"] = "|H0:item:177430:364:50:0:0:0:0:0:0:0:0:0:0:0:1:123:0:1:0:10000:0|h|h", 

    }


end 

--[[ ---------------------- ]]
--[[ -- Access Functions -- ]]
--[[ ---------------------- ]]

function EPT.IsSetSupported( setId ) 

end

function EPT.GetSetEntry( setId ) 
    return ProcSetData[setId] 
end


function EPT.GetProcSetData() 
    return ProcSetData
end


local crimsonOathRive = { --602
  ["setName"] = GetSetName("|H0:item:177430:364:50:0:0:0:0:0:0:0:0:0:0:0:1:123:0:1:0:10000:0|h|h"),
  ["abilityId"] = 159291, --152288 debuff
  ["cooldown"] = 12000,
  ["origin"] = EPT_ORIGIN_DUNGEON,
}