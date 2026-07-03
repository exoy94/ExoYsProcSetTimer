ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer 

--- Libraries 
local LibExoY = LibExoYsUtilities
local LSD = LibSetDetection
local LSD_C = LSD.constants 

--- ZOS Objects 
local EM = GetEventManager()

--[[ Notes ]]
--- Task-List 
-- [x] change to new lsd constants
-- [ ] build addon/ init tables... move explanation/ concepts there
-- [ ] check which event (2240 or 2245) is more working for more sets for basic proc 
-- [ ] update naming in slider and add resize function
-- [ ] profile change in customizer 
-- [ ] debug and comment profile manager 
-- [ ] set selection dropdown (search field + update dropdown selection)
-- [ ] automatic update of search dropdown based on search text 
-- [ ] detection if search text is number and then only compare with setId 
-- [ ] show setIds as option 

--- Concept: 
-- in dem moment, wo ich bei meinem setTracker obj von der lib mehr mache als die standard ui elements zu nutzen 
--  zählt das set zu special sets  / subclass e.g. second icon, second tracker etc 
-- aber subclass/ new class heißt nicht, dass etwas beim tracker geändert werden muss e.g. stack and proc (mit 1 icon und 1 bar)  

--- Configuration 
-- advanced implementation of settings, enables inheritance structure 
-- only settings different to the default values are written to saved variables to reduce file-size 
-- templates for each classes are defined in handler based on current profile 'BuildConfigTemplate()'
--    and saved in EPT.defaults.setTracker
-- each class instance has its own config table 'BuildConfigTable()'


--[[ ------------ ]]
--[[ -- Events -- ]]
--[[ ------------ ]]


local function OnSetChange( setId, changeType, _, _, activeType )    
    if EPT.debug then
        local debugStr = zo_strformat("SetId = <<1>>, changeType = <<2>>; activeType = <<3>>", setId, changeType, activeType)
        LibExoY.Debug( debugStr, {"EPT-SetChange"})
    end
    --- supported set was equipped 
    if changeType == LSD_C.change_type_activated then 
        EPT.setTracker:ActivateObj( setId ) 
    end 
    --- supported set was unequipped 
    if changeType == LSD_C.change_type_deactivated then 
        EPT.setTracker:DeactivateObj( setId ) 
    end 

    --- active bars of set changed, but it remained "activated"
    if changeType == LSD_C.change_type_updated then 
        
    end
end


--[[ -------------------- ]]
--[[ -- Initialization -- ]]
--[[ -------------------- ]]

local function Initialize() 

    local Init = EPT.initialize
    --- @todo corruption check

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
        name =  EPT.name,
        displayName = "|c00FF00ExoY|rs Proc Set Timer", -- for menu and dialogs 

        --- Saved Variables 
        storeVersion = 1, 
        globalDefaults = EPT.defaults.global,
        profileDefaults = EPT.defaults.profile,
        OnProfileChange = function(newProfile, oldProfile) 
            LibExoY.Print(newProfile, "EPT-ProfileChange") 
            EPT.setTracker:BuildConfigTemplates()   
            EPT.setTracker:UpdateConfigs() 
        end, 
        OnProfileListUpdate = function( newList ) LibExoY.Print("Profile List Update", "EPT") d(newList) end,  
        
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
    EPT.userInterface = nil -- clean up initialization distribution table 

    --- SetTracker Class Definitions
        -- initialize handler 
    EPT.setTracker = Init.setTracker.handler:New( ) 
    -- define class (main is superclass)
    for _, class in ipairs( EPT.setTrackerClassList ) do 
        EPT.setTracker.classes[class] = Init.setTracker.main:New( Init.setTracker[class] ) 
    end 
    -- table for sets with special behavior to define subclasses
    EPT.setTracker.specialSets = Init.setTracker.specialSets  



    --- Build Config Templates  
    EPT.setTracker:BuildConfigTemplates() 
    
    
    --- Register with LibSetDetection 
    local resultLSD = LSD.RegisterEvent( LSD_C.event_set_change, EPT.name, OnSetChange, LSD_C.unit_type_player, Sets.setIds)
    if EPT.debug then 
        if resultLSD == 0 then 
            local debugStr = "Registration with LibSetDetection "..LibExoY.ColorString("successful", "green") 
            LibExoY.Print( debugStr, {"EPT-Init"}) 
        else 
            local debugStr = "Registration with LibSetDetection "..LibExoY.ColorString("failed", "red").." (error code: "..tostring(resultLSD)..")"
            LibExoY.Print( debugStr, {"EPT-Init"}) 
        end
    end  


    --- Register Events 
    -- combat state 

    --- Slash Commands @todo
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
