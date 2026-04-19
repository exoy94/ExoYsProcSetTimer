ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer 


local SetTracker = {}

EPT.init = EPT.init or {}
EPT.init.SetTrackerConstructor  = function(...) return SetTracker:New(...) end 


function SetTracker:New( id ) 
    local Obj = setmetatable({}, self)
    self.__index = self 

    local ctrlBaseName = EPT.name..""..tostring(id) 
    Obj.indicator = LibExoY.NewIndicator( ctrlBaseName ) 

    return Obj
end


function SetTracker:Initialize() 

end

