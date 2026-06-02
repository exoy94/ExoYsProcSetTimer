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

EPT.setTrackerClassList = {
    "proc", 
}

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


--[[ Config - Temporary ]]

local function GetConfig( setId )

    --- pseudo-code 
    -- get setSV 
    --      check, if there are any sv for this set 
    --      ToDo, start a setSV table only if there is at least one parameter different then class template 
    --      if the last one is removed also remove the sv table to keep sv-file as small as possible 
    -- get setDefault (only unique set properties) 
    -- get setClass 
    -- get classSV 
    -- get classDefault (only unique class properties)  
    -- get standardSv 
    -- get standardDefault 

    -- build config table 

    --- Note: define meta-tables for standard and class sv one time 
    -- have the class sv table already include the standard table?! 

    -- maybe do this during class initialization  
    -- unclude the function to get the final set config in main class file 
    -- can even include the stuff for the class config and defaults in main clas 
    -- just need to be consistent with naming 

end


--[[ -------------------- ]]
--[[ -- Initialization -- ]]
--[[ -------------------- ]]

EPT.defaults = EPT.defaults or {} 

EPT.defaults["global"] = {


} 

EPT.defaults["profile"] = {
    setTracker = {
        main = {},
        classes = {}, 
        sets = {},
    }
} 

do 
    for _, class in ipairs( EPT.setTrackerClassList ) do 
        EPT.defaults.profile.setTracker.classes[class] = {}
    end
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
        globalDefaults = EPT.defaults.global,
        profileDefaults = EPT.defaults.profile,
        OnProfileChange = function(newProfile, oldProfile) LibExoY.Print(newProfile, "EPT-ProfileChange") end, 
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
    EPT.userInterface = nil 

    --- SetTracker 
    -- initialize handler and classes 
    local SetTracker = EPT.setTrackerClass  -- distribution table for initializatino 
    EPT.setTracker = SetTracker.handler:New() 
    -- define subclass for each set-type (main is superclass)
    for _, class in ipairs( EPT.setTrackerClassList ) do 
        EPT.setTracker.classes[class] = SetTracker.main:New( SetTracker[class] ) 
    end 
    --EPT.setTracker.classes.proc = SetTracker.main:New( SetTracker["proc"] )   --- Replaced by previous loop 
    -- table for sets with special behavior to define individual classes instances
    EPT.setTracker.specialSets = SetTracker.specialSets or {}
    EPT.setTrackerClass = nil   -- clean up distribution table for initialization 
    SetTracker = EPT.setTracker -- changed to handler 


    --- Build Config Tables  
    EPT.configs = {}

    --- @ToDo passt noch nicht ganzm weil so brauch ich schon in den sv eine tabelle für jede config, auch wenn sie leer ist (potentiell das gleiche für sets) 
    -- aber die class liste wäre erst nach der Handler definition verfügbar, bräuchte sie aber für die erzeugung der default 
    --. tabelle für die sv 
    EPT.configs["setTracker"] = {} 

    local SetTrackerConfig = EPT.configs.setTracker
    local SetTrackerDefault = EPT.defaults.setTracker
    SetTrackerConfig["main"] = setmetatable(EPT.sv.p.setTracker.main, {__index = SetTrackerDefault.main})
    for _, class in ipairs( EPT.setTrackerClassList ) do 
        local classConfigDefault = setmetatable( SetTrackerDefault[class], {__index = SetTrackerConfig["main"]} )
        SetTrackerConfig[ class ] = setmetatable(EPT.sv.p.setTracker.classes[class], {__index = classConfigDefault } )
    end
    
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
