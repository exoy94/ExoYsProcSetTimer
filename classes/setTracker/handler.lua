ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer 

local SetTrackerHandler = {}
EPT.setTrackerClass = EPT.setTrackerClass or {}
EPT.setTrackerClass.handler = SetTrackerHandler 


function SetTrackerHandler:New() 
    local obj = setmetatable({}, self)
    self.__index = self  

    obj.classes = {}
    obj.specialSets = {}
    obj.objectRegistry = {}    -- list of all already created set tracker objects 
    obj.activeObjects = {}    -- list of currently active tracker 

    return obj 
end



function SetTrackerHandler:ActivateObj( setId )

    if not self.objects[setId] then 
        self:InitializeObj( setId ) 
    end 

    local obj = self.objectRegistry[setId] 

    -- add fragments 
    -- register events 
    self.activeObjects[setId] = obj

    -- chose position 
end 







function SetTrackerHandler:InitializeObj( setId )

    local setType = EPT.GetSetType( setId )  
    local obj = self.classes[ setType ]:New( self.uniqueSets[setId], setId )
    
    --- class specific initialization

    obj:Initialization( setId )


    self.objectRegistry[setId] = obj
    -- get setData 
    -- populate set data --> there should be a basic function for stuff like setName and a subclass specific function
    -- check unique 
    -- create appropriate obj
    -- get saved variables 
end



function SetTrackerHandler:DeactivateObj( setId ) 
    local obj = self.objects[setId]
    

    self.activeObjects[setId] = nil 
    -- remove fragments
    -- unregister events 
    -- remove from active list 
end