ExoYsProcSetTimer = ExoYsProcSetTimer or {}


local EM = GetEventManager()
local LibExoY = LibExoYsUtilities
local LSD = LibSetDetection

local EPT = ExoYsProcSetTimer 

EPT.acronym = "EPT"
EPT.name = "ExoYsProcSetTimer"
EPT.displayName = "ExoY's ProcSet-Timer"
EPT.version = "3.0.0"


--[[ --------------------- ]]
--[[ -- Update Callback -- ]]
--[[ --------------------- ]]

local function OnUpdate() 
    local currentGameTimeMS = GetGameTimeMilliseconds() 
    for setId, handler in pairs(EPT.ProcSetHandler.list) do 
        d( zo_strformat("OnUpdate for <<1>> (<<2>>)", LSD.GetSetName(setId), setId))
        handler:OnTimeUpdate( currentGameTimeMS ) 
    end
end

--[[ -------------------- ]]
--[[ -- Event Callback -- ]]
--[[ -------------------- ]]

local function OnCombatStart() 

end


local function OnCombatEnd() 

end


local function OnSetChange( setId, changeType, _, _, activeType ) 
    LibExoY.Debug("dev", EPT.debug, EPT.acronym, 
        zo_strformat("SetChange: <<1>> (<<2>>), changeType = <<3>>; activeType = <<4>>", LSD.GetSetName(setId), setId, changeType, activeType)) 

    if changeType == LSD_CHANGE_TYPE_ACTIVATED then 
        EPT.ProcSetHandler:Create(setId)
    elseif 
        changeType == LSD_CHANGE_TYPE_DEACTIVATED then 
        EPT.ProcSetHandler:Destroy(setId)
    end 
end


local function OnPlayerActivated() 

end 


local function OnInitialPlayerActivated() 


end



--[[ -------------------- ]]
--[[ -- Initialization -- ]]
--[[ -------------------- ]]

local function Initialize() 
    --- Variable Definition
    EPT.debug = false 
    if ExoYsDevelopmentTool then 
        EPT.debug = ExoYsDevelopmentTool.addonDebug[EPT.name] 
    end

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
    
    LSD.RegisterEvent( LSD_EVENT_SET_CHANGE, EPT.name, OnSetChange, LSD_UNIT_TYPE_PLAYER )
    
    --- Update Registration 
    EM:RegisterForUpdate( EPT.name, 5000, OnUpdate )
    
end



local function OnAddonLoaded(_, addonName)
    if addonName == EPT.name then 
        EM:UnregisterForEvent( EPT.name, EVENT_ADD_ON_LOADED)
        Initialize() 
    end
end

EM:RegisterForEvent( EPT.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)
