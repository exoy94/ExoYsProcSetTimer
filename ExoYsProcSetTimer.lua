ExoYsProcSetTimer = ExoYsProcSetTimer or {}


local EM = GetEventManager()
local LibExoY = LibExoYsUtilities
local LSD = LibSetDetection

local EPT = ExoYsProcSetTimer 

EPT.name = "ExoYsProcSetTimer"
EPT.version = "3.0.0"



--[[ ------------ ]]
--[[ -- Events -- ]]
--[[ ------------ ]]


local function OnSetChange( setId, changeType, _, _, activeType )    
    if EPT.debug then
        local debugStr = zo_strformat("SetId = <<1>>, changeType = <<2>>; activeType = <<3>>", setId, changeType, activeType)
        LibExoY.Debug( debugStr, {"EPT-SetChange"})
    end
    -- supported set was equipped 
    if changeType == LSD_CHANGE_TYPE_ACTIVATED then 
        EPT.setTracker:ActivateObj( setId ) 
    end 
    -- supported set was unequipped 
    if changeType == LSD_CHANGE_TYPE_DEACTIVATED then 
        EPT.setTracker:DeactivateObj( setId ) 
    end 

    if changeType == LSD_CHANGE_TYPE_UPDATED then 
        
    end
end


--[[ -------------------- ]]
--[[ -- Initialization -- ]]
--[[ -------------------- ]]


local function Initialize() 

    --- Variable Definition
    EPT.debug = true 
    --if ExoYsDevelopmentTool then 
    --    EPT.debug = ExoYsDevelopmentTool.addonDebug[EPT.name] 
    --end

    --- Saved Variables 


    --- User Interace 
    EPT.ui = {}

    --- SetTracker 
    -- initialize handler and classes 
    local SetTracker = EPT.setTrackerClass  -- distribution table for initializatino 
    EPT.setTracker = SetTracker.handler:New() 
    -- define class for each set-type (main is superclass)
    EPT.setTracker.classes.proc = SetTracker.main:New( SetTracker["proc"] )
    -- table for sets with unique behavior ()
    EPT.setTracker.unique = SetTracker.unique  
    EPT.setTrackerClass = nil   -- clean up distribution table
    
    --- Register with LibSetDetection 
    -- list of sets supported by EPT for LSD event filter
    local supportedSets = {}
    for setId, _ in pairs( EPT.database) do
        table.insert( supportedSets, setId) 
    end
    local resultLSD = LSD.RegisterEvent( LSD_EVENT_SET_CHANGE, EPT.name, OnSetChange, LSD_UNIT_TYPE_PLAYER, supportedSets)
    if EPT.debug then 
        if resultLSD == 0 then 
            local debugStr = "Registration with LibSetDetection "..LibExoY.ColorString("successful", "green") 
            LibExoY.Debug( debugStr, {"EPT-Init"}) 
        else 
            local debugStr = "Registration with LibSetDetection "..LibExoY.ColorString("failed", "red") 
            LibExoY.Debug( debugStr, {"EPT-Init"}) 
        end
    end  

end



local function OnAddonLoaded(_, addonName)
    if addonName == EPT.name then 
        EM:UnregisterForEvent( EPT.name, EVENT_ADD_ON_LOADED)
        Initialize() 
    end
end

EM:RegisterForEvent( EPT.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)
