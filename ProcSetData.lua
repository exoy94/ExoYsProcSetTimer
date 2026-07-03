--- Addon Namespace
local EPT = ExoYsProcSetTimer 

local ProcSetData = {}
EPT.database = ProcSetData

--[[ --------------------- ]]
--[[ -- Access Function -- ]]
--[[ --------------------- ]]

function EPT.GetDatabase() 
    return ProcSetData
end

function EPT.GetSetData( setId ) 
    return ProcSetData[setId]
end

function EPT.GetSetClass( setId ) 
    return ProcSetData[setId].class
end


--[[ ------------------------- ]]
--[[ -- ProcSet Definitions -- ]]
--[[ ------------------------- ]]

--- Guidelines Perfected/Non-Perfected 
--      + only include the setId of the non-perfected version 
--      + procs should be identical, the difference should only be a stat-line 

--- Guidelines ItemLink
--      + Quality: Gold (except mysticals) 
--      + No Enchantment 
--      + CP160     
--      + Heavy (if there are multiple weights)     
--      + Specific Piece:  
--          + normal Sets: Chest
--          + undaunted sets: Helm  
--          + arena sets:  

--- Guidelines abilityId  
--      + used for dynamically filling the setData
--      + setClass "proc" = procId
--      + setClass "stack" = stackId
--      + setClass "group" = procId 
--      + setClass "toggle" = 


do --- U27 (DLC - Stonethorn)
    ProcSetData[518] = {
        itemLink = "|H0:item:165254:362:50:0:0:0:11:0:0:0:0:0:0:0:2049:107:0:1:0:10000:0|h|h", 
        class = "proc", 
        procId = 142660,
    } 
end

do --- U31 (DLC - Waking Flame)
    ProcSetData[602] = {    -- Crimson Oath's Rive
        itemLink = "|H0:item:177430:364:50:0:0:0:0:0:0:0:0:0:0:0:1:123:0:1:0:10000:0|h|h", 
        class = "proc", 
        procId = 159288, -- legacy: 159291,
    }
end 


