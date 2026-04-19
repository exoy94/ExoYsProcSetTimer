ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer 

local SetTrackerMain = {}
EPT.setTrackerClass = EPT.setTrackerClass or {}
EPT.setTrackerClass.main = SetTrackerMain 



function SetTrackerMain:New( Obj, setId ) 
    setmetatable(Obj or {}, self)
    self.__index = self 

    self.setId = setId 
    self.setName = EPT.GetSetName( setId ) 

    return Obj
end



function SetTrackerMain:BasicInitialization( setId ) 
    self.setId = setId 
    
    local setData = EPT.database[setId] 

    --- Populate Set Data 
    local _, setName, _, _, _, _ = GetItemLinkSetInfo(setData.itemLink)
    setData.setName = zo_strformat( SI_ABILITY_NAME, setName )
    setData.texture = setData.texture or GetAbilityIcon( setData.abilityId )
    
    -- create indicator 
    -- 
end


function SetTrackerMain:LoadSetData()  
    local setData = EPT.database[self.setId] 
    if setData.populated then return setData end 

    --- Populate Set Data 
    local _, setName, _, _, _, _ = GetItemLinkSetInfo(setData.itemLink)
    setData.setName = zo_strformat( SI_ABILITY_NAME, setName )
    setData.texture = setData.texture or GetAbilityIcon( setData.abilityId )
    
    setData.populated = true
    return setData
end



function SetTrackerMain:Initialize( setId, uniqueClass ) 
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



function SetTrackerMain:RegisterEvents() 
    if self.setType == EPT_SET_TYPE_PROC then 
        EM:RegisterForEvent(self.name..tostring(setId), EVENT_COMBAT_EVENT, function(...) self:OnProcEvent(...) end)
        EM:AddFilterForEvent(self.name..tostring(setId), EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, self.setData.abilityId)
        EM:AddFilterForEvent(self.name..tostring(setId), EVENT_COMBAT_EVENT, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE , COMBAT_UNIT_TYPE_PLAYER)
    end
end



function SetTrackerMain:OnProcEvent(event, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId, overflow)
    -- i probably only need "result"
    -- filter result 
    --start timer 
end



function SetTrackerMain:CleanUp() 
    -- unregister events 
    --- this should delete all temporary changes and data 
    --for k, _ in pairs(self) do 
    --    self[k] = nil 
    --end
    --- cant do this, because i would delete the indicator and such 
end



function SetTrackerMain:CallMetaMethod( method, ... )
    local mt = getmetatable(self) 
    local MetaMethod = mt.__index[method]  
    return MetaMethod(self, ...) 
end