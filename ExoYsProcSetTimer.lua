ExoYsProcSetTimer = ExoYsProcSetTimer or {}


local EM = GetEventManager()
local LibExoY = LibExoYsUtilities
local LSD = LibSetDetection

local EPT = ExoYsProcSetTimer 

EPT.name = "ExoYsProcSetTimer"
EPT.displayName = "ExoY's ProcSet-Timer"
EPT.version = "3.0.0"




--[[ -------------------- ]]
--[[ -- Event Callback -- ]]
--[[ -------------------- ]]

local function OnCombatStart() 

end


local function OnCombatEnd() 

end


local function OnSetChange( setId, changeType, _, _, activeType ) 
    
end


local function OnPlayerActivated() 

end 


local function OnInitialPlayerActivated() 

end



--[[ -------------------- ]]
--[[ -- Initialization -- ]]
--[[ -------------------- ]]

local function Initialize() 
    --- Saved Variables 

    
    --- Settings Menu 
    local SettingsMenuParameter = {
        name = EPT.name,
        displayName = EPT.displayName,
        version = EPT.version,
        esoui = "info2783-ExoYsProcSetTimer.html",
        profiles = nil, 
        controls = nil,
    } 
    LibExoY.CreateSettingsMenu( SettingsMenuParameter ) 

    --- Event Registration
    LibExoY.RegisterCombatStart( OnCombatStart )
    LibExoY.RegisterCombatEnd( OnCombatEnd ) 
    LibExoY.RegisterForInitialPlayerActivated( OnInitialPlayerActivated )
    LibExoY.RegisterForPlayerActivated( OnPlayerActivated ) 

    LSD:RegisterEvent( LSD_EVENT_SET_CHANGE, EPT.name, OnSetChange, LSD_UNIT_TYPE_PLAYER ) 
end



local function OnAddonLoaded(_, addonName)
    if addonName == EPT.name then 
        EM:UnregisterForEvent( EPT.name, EVENT_ADD_ON_LOADED)
        Initialize() 
    end
end

EM:RegisterForEvent( EPT.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)
