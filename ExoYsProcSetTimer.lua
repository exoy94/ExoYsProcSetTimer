ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer 

--- Libraries 
local LibExoY = LibExoYsUtilities
local LSD = LibSetDetection

--- ZOS Objects 
local EM = GetEventManager()


--[[ Notes ]]
--- Task-List 
-- [ ] check which event (2240 or 2245) is more working for more sets for basic proc 
-- [ ] update naming in slider and add resize function
-- [ ] profile change in customizer 
-- [ ] debug and comment profile manager 
-- [ ] set selection dropdown (search field + update dropdown selection)
-- [ ] automatic update of search dropdown based on search text 
-- [ ] detection if search text is number and then only compare with setId 
-- [ ] show setIds as option 
-- [ ] 

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

local function GetGlobalDefaults() 
    defaults = {
        customizer = {
            scale = 1,  
        },
    }
    return defaults 
end

local function GetProfileDefaults() 
    defaults = {}
    return defaults   
end



local function Initialize() 

    --- Variable Definition (Temporary)
    if GetUnitDisplayName("player") == "@ExoY94" then EPT.debug = true end

    --- Supported Sets 
    EPT.sets = {}   -- collection of lookup tables 
    local Sets = EPT.sets
    Sets.setIds = {}    -- numeric table with all supported setIds
    Sets.setClass = {}  -- key is setId, value is setClass (used fot template mapping) 
    Sets.setName = {}   -- key is setId, value is setname 
    for setId, setData in pairs( EPT.GetDatabase() ) do 
        table.insert( Sets.setIds, setId ) 
        Sets.setName[setId] = LSD.GetSetName( setId ) 
        Sets.setClass[setId] = setData.class 
    end
    table.sort( Sets.setIds )

    --- Saved Variables 
    local AddonSettingsParameter = {
        name =  EPT.name,-- will build sv name and panel name from that 
        displayName = "|c00FF00ExoY|rs Proc Set Timer", -- for menu and dialogs 

        --- Saved Variables 
        storeVersion = 1, 
        globalDefaults = GetGlobalDefaults(),
        profileDefaults = GetProfileDefaults(),
        OnProfileChange = function(newProfile, oldProfile) end, 

        --- Settings Menu
        addonVersion = "3.0.0", 
        globalSettingsControls = { },
        profileSettingsControls = { },
        esoui = "info2783-ExoYsProcSetTimer.html", 
    }  
    EPT.sv, EPT.pm = LibExoY.InitializeAddonSettings( AddonSettingsParameter )

    --- User Interace 
    EPT.ui = {}
    EPT.ui.customizer = EPT.userInterface.customizer:New( EPT.name.."_Customizer" ) 
    EPT.userInterface = nil 

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
    local resultLSD = LSD.RegisterEvent( LSD_EVENT_SET_CHANGE, EPT.name, OnSetChange, LSD_UNIT_TYPE_PLAYER, Sets.setIds)
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
                table.sort(Sets.setIds) 
                LibExoY.Print("complete list of all sets included", {"EPT - Supported Sets"})
                for idx, setId in ipairs( Sets.setIds ) do 
                    local setInfo = zo_strformat("[<<1>>] <<2>>", LibExoY.ColorString( tostring(setId), "white"), EPT.GetSetData(setId).itemLink) 
                    d(setInfo)
                end
            end,
        }, 
    }
    local tmpCmd = function() 
                table.sort(Sets.setIds) 
                LibExoY.Print("complete list of all sets included", {"EPT - Supported Sets"})
                for idx, setId in ipairs( Sets.setIds ) do 
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
