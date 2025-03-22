ExoYsProcSetTimer = ExoYsProcSetTimer or {}

local EPT = ExoYsProcSetTimer



--[[ -------------------- ]]
--[[ -- ProcSet Object -- ]]
--[[ -------------------- ]]

local ProcSet = {}
ProcSet.__index = ProcSet 

function ProcSet:New( setId ) 
    local obj = setmetatable( {}, ProcSet ) 
    obj.setId = setId
    return obj
end


function ProcSet:Destroy() 

end

function ProcSet:OnTimeUpdate( timeMS )

end




--[[ ------------------------------------- ]]
--[[ -- Handler for all ProcSet Objects -- ]]
--[[ ------------------------------------- ]]

EPT.ProcSetHandler = {}

local Handler = EPT.ProcSetHandler
Handler.list = {}

function Handler:Create( setId )
    local obj = ProcSet:New( setId ) 
    self.list[setId] = obj
end

function Handler:Destroy(setId) 
    self.list[setId]:Destroy( ) 
    self.list[setId]= nil
end