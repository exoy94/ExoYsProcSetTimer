ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer 

local SetTracker = {}

local EM = GetEventManager() 

EPT.init = EPT.init or {}
EPT.init.Constructor_SetTracker  = function(...) return SetTracker:New(...) end 



function SetTracker:New( id ) 
    local Obj = setmetatable({}, self)
    self.__index = self 

    local ctrlBaseName = EPT.name..""..tostring(id) 
    --- Obj.indicator = LibExoY.NewIndicator( ctrlBaseName ) 

    return Obj
end



function SetTracker:LoadSetData()  
    local setData = EPT.database[self.setId] 
    if setData.populated then return setData end 

    --- Populate Set Data 
    local _, setName, _, _, _, _ = GetItemLinkSetInfo(setData.itemLink)
    setData.setName = zo_strformat( SI_ABILITY_NAME, setName )
    setData.texture = setData.texture or GetAbilityIcon( setData.abilityId )
    
    setData.populated = true
    return setData
end



function SetTracker:Initialize( setId, uniqueClass ) 
    self.setId = setId 
    self.setData = self:LoadSetData() 
    self.setType = self.setData.setType
    self.settings = self:LoadSettings()

    --- somehow apply unique behavior
    for funcName, callback end  

    --- self.indicator:Initialize( self.settings ) 

    --- if the set is unique, i need to temporary overwrite all necessary functions, does this work? 
    if self.setData.isUnique then  
        function self:RegisterForEvents() 
            d("overwritten") 
        end
    end

    self:RegisterEvents() 


end



function SetTracker:RegisterEvents() 
    if self.setType == EPT_SET_TYPE_PROC then 
        EM:RegisterForEvent(self.name..tostring(setId), EVENT_COMBAT_EVENT, function(...) self:OnProcEvent(...) end)
        EM:AddFilterForEvent(self.name..tostring(setId), EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, self.setData.abilityId)
        EM:AddFilterForEvent(self.name..tostring(setId), EVENT_COMBAT_EVENT, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE , COMBAT_UNIT_TYPE_PLAYER)
    end
end



function SetTracker:OnProcEvent(event, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId, overflow)
    -- i probably only need "result"
    -- filter result 
    --start timer 
end



function SetTracker:CleanUp() 
    -- unregister events 
    --- this should delete all temporary changes and data 
    --for k, _ in pairs(self) do 
    --    self[k] = nil 
    --end
    --- cant do this, because i would delete the indicator and such 
end