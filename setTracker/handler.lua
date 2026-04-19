ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer 


local Handler = {}

EPT.init = EPT.init or {}
EPT.init.HandlerConstructor = function(...) return Handler:New(...) end 


function Handler:New() 
    local Obj = setmetatable({}, self) 
    self.__index = self 
    
    Obj.pool = {}
    Obj.objCounter = 0  -- incremental number for uniqueness
    Obj.objects = {}    -- list of all active objects 

    return Obj
end



function Handler:AssignObj( setId )  
    local obj 
    if ZO_IsTableEmpty( self.pool ) then 
        self.objectCounter = self.objectCounter + 1 
        obj = self.setTracker:New( self.objCounter ) 
        obj = self.pool[#self.pool]
        self.pool
    end
    obj:Initialize(setId)
    self.objects[setId] = obj
end 


