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


function EPT.GetProcSetData() 
    return ProcSetData
end
