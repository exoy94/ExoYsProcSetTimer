ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer 

local EM = GetEventManager() 

local SetTrackerProc = {}
EPT.setTrackerClass = EPT.setTrackerClass or {}
EPT.setTrackerClass.proc = SetTrackerProc 




function SetTrackerProc:Initialize( ) 

    local setData = self.setData 
    --- populate setData 
    -- only for properties specific to this subclass
    -- properties used by multiple sub classes should be included in the constructor of the superclass
    setData.duration = setData.duration or GetAbilityDuration( setData.abilityId )
    setData.cooldown = setData.cooldown or GetAbilityCooldown( setData.abilityId ) 

    self:RegisterEvents()
end


function SetTrackerProc:OnProcEvent(_, result) 
    d("something happened") --- ToBeContinued
end


function SetTrackerProc:RegisterEvents() 
    local name = self.name.."_ProcEvent"
    EM:RegisterForEvent(name, EVENT_COMBAT_EVENT, function(...) self:OnProcEvent(...) end)
    EM:AddFilterForEvent(name, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, self.setData.abilityId)
    EM:AddFilterForEvent(name, EVENT_COMBAT_EVENT, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE , COMBAT_UNIT_TYPE_PLAYER)
end