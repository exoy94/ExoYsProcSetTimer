ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer

local ProcSetData = {}
EPT.database = ProcSetData

--[[ ---------------------- ]]
--[[ -- Global Constants -- ]]
--[[ ---------------------- ]]

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

--[[ ------------------------- ]]
--[[ -- ProcSet Definitions -- ]]
--[[ ------------------------- ]]

--- Guidelines Perfected/Non-Perfected 
--      + only include the setId of the non-perfected version 
--      + procs should be identical, the difference should only be a stat-line 
--      + 

--- Guidelines ItemLink
--      + Quality: Gold (except mysticals) 
--      + No Enchantment 
--      + CP160     
--      + Heavy (if there are multiple weights)     
--      + Specific Piece:  
--          + Chest 


do --- U31 (DLC - Waking Flame)
    ProcSetData[602] = {    -- Crimson Oath's Rive
        itemLink = "|H0:item:177430:364:50:0:0:0:0:0:0:0:0:0:0:0:1:123:0:1:0:10000:0|h|h", 
        setType = EPT_SET_TYPE_PROC, 
        abilityId = 159291,
    }
end 

