ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer 

local EM = GetEventManager() 

--- Libraries
local LibExoY = LibExoYsUtilities
local LSD = LibSetDetection

--- Object Table 
local SetTrackerProc = {}
EPT.setTrackerClass = EPT.setTrackerClass or {}
EPT.setTrackerClass.proc = SetTrackerProc 

EPT.defaults = EPT.defaults or {} 
EPT.defaults.setTracker = EPT.defaults.setTracker or {}
EPT.defaults.setTracker["proc"] = {

}


function SetTrackerProc:Initialize( ) 

    local setDataMetaIndex = {
        duration = GetAbilityDuration( self.setData.procId ), 
        cooldown = GetAbilityCooldown( self.setData.procId ),
    }
    local setDataMeta = getmetatable( self.setData ) 
    LibExoY.DeepMergeTables( setDataMeta.__index, setDataMetaIndex )

    self.procData = {
        eventName = self.name.."_Event",
        updateName = self.name.."_Update",
        updateRunning = false, 
        terminalTime = 0, 
    }
    self.indicator = LibExoY.CreateTracker( self.name.."_Indicator" )

    table.insert( self.sceneFragments, ZO_HUDFadeSceneFragment:New( self.indicator.controls.win ))     
end



function SetTrackerProc:OnProcEvent(_, result)

    local setData = self.setData 
    local procData = self.procData 

    if EPT.debug then 
        local resultList = {
            [ACTION_RESULT_EFFECT_GAINED] = "action result effect gained", --2240
            [ACTION_RESULT_EFFECT_GAINED_DURATION] = "action result effect gained duration ", --2245
        }
        local setId = LibExoY.ColorString( tostring(self.setId), "orange") 
        local setName = LibExoY.ColorString( setData.setName, "orange") 
        local debugStr = zo_strformat("(<<1>>) <<2>> - Action Result: <<3>> (<<4>>)", setId, setName, LibExoY.ColorString(tostring(result), "white"), resultList[result] ) 
        LibExoY.Print(debugStr, {"EPT-ProcEvent"})
    end

    local time = GetGameTimeMilliseconds()
    local endDuration = time + setData.duration
    local endCooldown = time + setData.cooldown
    procData.terminalTime = zo_max(endDuration, endCooldown) 

    --- register update 
    if not procData.updateRunning then 
        EM:RegisterForUpdate(procData.updateName, 100, function() self:OnUpdate() end ) 
        procData.updateRunning = true 
    end
end



function SetTrackerProc:OnUpdate() 
    local procData = self.procData 
    local setData = self.setData
    
    local timeRemaining = procData.terminalTime - GetGameTimeMilliseconds()

    local bar = self.indicator.barObj.controls.bar 
    bar:SetMinMax(0,15000) 
    bar:SetValue(timeRemaining)

    self.indicator.iconObj.controls.labels[1]:SetText( tostring(timeRemaining) ) 
    
    if timeRemaining < 0 then 
        EM:UnregisterForUpdate( procData.updateName) 
        procData.updateRunning = false 
        LibExoY.Print("UpdateStop", {"EPT-Proc"})
    end
end


function SetTrackerProc:RegisterEvents() 
    local setData = self.setData
    local name = self.procData.eventName
    EM:RegisterForEvent(name, EVENT_COMBAT_EVENT, function(...) self:OnProcEvent(...) end)
    EM:AddFilterForEvent(name, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, setData.procId)
    EM:AddFilterForEvent(name, EVENT_COMBAT_EVENT, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE , COMBAT_UNIT_TYPE_PLAYER)
end

function SetTrackerProc:UnregisterEvents() 
    local name = self.procData.eventName
    EM:UnregisterForEvent(name, EVENT_COMBAT_EVENT)
end