ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer 

--- Libraries 
local LibExoY = LibExoYsUtilities
local LSD = LibSetDetection

--- ZOS Objects 
local EM = GetEventManager()


--[[ Notes ]]
--- Task-List 
-- [ } check which event (2240 or 2245) is more working for more sets for basic proc 


--- 
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
    --- supported set was equipped 
    if changeType == LSD_CHANGE_TYPE_ACTIVATED then 
        EPT.setTracker:ActivateObj( setId ) 
    end 
    --- supported set was unequipped 
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

    --- Variable Definition (Temporary)
    if GetUnitDisplayName("player") == "@ExoY94" then EPT.debug = true end

    --- Saved Variables 
    local AddonSettingsParameter = {
        name =  "ExoYsProcSetTimer",-- will build sv name and panel name from that 
        displayName = "|c00FF00ExoY|rs Proc Set Timer", -- for menu and dialogs 

        --- Saved Variables 
        storeVersion = 1, 
        globalDefaults = { },
        profileDefaults = { },
        OnProfileChange = function(newProfile, oldProfile ) end, 

        --- Settings Menu
        addonVersion = "3.0.0", 
        globalSettingsControls = { },
        profileSettingsControls = { },
        esoui = "info2783-ExoYsProcSetTimer.html", 
    }  

  local SV, ProfileManager = LibExoY.InitializeAddonSettings( AddonSettingsParameter )

    --- User Interace 
    EPT.ui = {}

    --- SetTracker 
    -- initialize handler and classes 
    local SetTracker = EPT.setTrackerClass  -- distribution table for initializatino 
    EPT.setTracker = SetTracker.handler:New() 
    -- define subclass for each set-type (main is superclass)
    EPT.setTracker.classes.proc = SetTracker.main:New( SetTracker["proc"] )
    -- table for sets with special behavior to define individual classes instances
    EPT.setTracker.specialSets = SetTracker.specialSets or {}
    EPT.setTrackerClass = nil   -- clean up distribution table for initialization 
    
    --- Register with LibSetDetection 
    -- list of sets supported by EPT for LSD event filter
    local supportedSets = {}
    for setId, _ in pairs( EPT.GetDatabase() ) do
        table.insert( supportedSets, setId) 
    end
    local resultLSD = LSD.RegisterEvent( LSD_EVENT_SET_CHANGE, EPT.name, OnSetChange, LSD_UNIT_TYPE_PLAYER, supportedSets)
    if EPT.debug then 
        if resultLSD == 0 then 
            local debugStr = "Registration with LibSetDetection "..LibExoY.ColorString("successful", "green") 
            LibExoY.Print( debugStr, {"EPT-Init"}) 
        else 
            local debugStr = "Registration with LibSetDetection "..LibExoY.ColorString("failed", "red") 
            LibExoY.Print( debugStr, {"EPT-Init"}) 
        end
    end  

    --- Register Events 
    -- combat state 


    --- Slash Commands 
    local subCmdTable = {
        ["supportedSets"] = { 
            info = "lists all supported sets", 
            callback = function() 
                table.sort(supportedSets) 
                LibExoY.Print("complete list of all sets included", {"EPT - Supported Sets"})
                for idx, setId in ipairs( supportedSets ) do 
                    local setInfo = zo_strformat("[<<1>>] <<2>>", LibExoY.ColorString( tostring(setId), "white"), EPT.GetSetData(setId).itemLink) 
                    d(setInfo)
                end
            end,
        }, 
    }

    local tmpCmd = function() 
                table.sort(supportedSets) 
                LibExoY.Print("complete list of all sets included", {"EPT - Supported Sets"})
                for idx, setId in ipairs( supportedSets ) do 
                    local setInfo = zo_strformat("[<<1>>] <<2>>", LibExoY.ColorString( tostring(setId), "white"), EPT.GetSetData(setId).itemLink) 
                    d(setInfo)
                end
            end
    LibExoY.AddSlashCmd( "/ept", tmpCmd)--, "ExoYsProcSetTimer - ChatCommands", subCmdTable)

end



local function OnAddonLoaded(_, addonName)
    if addonName == EPT.name then 
        EM:UnregisterForEvent( EPT.name, EVENT_ADD_ON_LOADED)
        Initialize() 
    end
end

EM:RegisterForEvent( EPT.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)
