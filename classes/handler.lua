ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer 


local Handler = {}

EPT.init = EPT.init or {}
EPT.init.Constructor_Handler = function(...) return Handler:New(...) end 


function Handler:New( classes ) 
    local Obj = setmetatable({}, self) 
    self.__index = self 
    
    for class, constructor in pairs(classes) do 
        Obj[class] = {
            pool = {}, 
            objects = {}, 
            counter = 0, 
            Constructor = constructor,
        }
    end 

    return Obj
end



function Handler:AssignObj( class, setId )  
    local obj 
    local hdlr = self[class] 
    if ZO_IsTableEmpty( hdlr.pool ) then 
        hdl.counter = self.counter + 1 
        obj = hdlr.Constructor( hdlr.counter ) 
        obj = hdlr.pool[#hdlr.pool]
        hdlr.pool[#hdlr.pool] = nil 
    end
    obj:Initialize(setId)
    hdlr.objects[setId] = obj
end 



function Handler:ReleaseObj( class, setId ) 
    local obj = self[class].objects[setId]
    obj:CleanUp()
    table.insert( self[class].pool, obj)
    self[class].objects[setId] = nil 
end

