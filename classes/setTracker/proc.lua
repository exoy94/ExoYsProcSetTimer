ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer 

local EM = GetEventManager() 

local SetTrackerProc = {}
EPT.setTrackerClass = EPT.setTrackerClass or {}
EPT.setTrackerClass.proc = SetTrackerProc 





function SetTrackerProc:RegisterEvents() 
    EM:RegisterForEvent(self.name..tostring(setId), EVENT_COMBAT_EVENT, function(...) self:OnProcEvent(...) end)
    EM:AddFilterForEvent(self.name..tostring(setId), EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, self.setData.abilityId)
    EM:AddFilterForEvent(self.name..tostring(setId), EVENT_COMBAT_EVENT, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE , COMBAT_UNIT_TYPE_PLAYER)
end