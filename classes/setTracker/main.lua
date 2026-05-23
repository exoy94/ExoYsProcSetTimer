ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer 
local LSD = LibSetDetection
local LibExoY = LibExoYsUtilities

local SetTrackerMain = {}
EPT.setTrackerClass = EPT.setTrackerClass or {} 
EPT.setTrackerClass.main = SetTrackerMain 



function SetTrackerMain:New( Obj, setId ) 
    Obj = setmetatable(Obj or {}, self)
    self.__index = self 

    if setId then 
        Obj.setId = setId 
        Obj.name = "EPT_SetTracker_"..tostring(setId)
        --- Populate Set Data (Generic Properties) 
        local setData = EPT.GetSetData( setId ) 
        setData.setName = LSD.GetSetName( setId ) 
        Obj.setData = setData 
    end

    return Obj
end


function SetTrackerMain:CallMetaMethod( method, ... )
    local mt = getmetatable(self) 
    local MetaMethod = mt.__index[method]  
    return MetaMethod(self, ...) 
end