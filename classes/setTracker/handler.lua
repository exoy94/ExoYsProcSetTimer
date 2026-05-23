ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer 
local LibExoY = LibExoYsUtilities

local SetTrackerHandler = {}
EPT.setTrackerClass = EPT.setTrackerClass or {}
EPT.setTrackerClass.handler = SetTrackerHandler 




function SetTrackerHandler:New() 
    local obj = setmetatable({}, self)
    self.__index = self  

    obj.classes = {} 
    obj.specialSets = {}
    obj.objectRegistry = {}    -- list of all already created set tracker objects (no pool) 
    obj.activeObjects = {}    -- list of currently active tracker

    return obj 
end



function SetTrackerHandler:ActivateObj( setId )
    -- check if set-specific object already exists
    -- if not, create and initialize it 
    if not self.objectRegistry[setId] then 
        -- object is automatically added to registry 
        self:InitializeObj( setId )
    end 
    -- grabs object from registry 
    local obj = self.objectRegistry[setId] 
    obj:Activate() -- e.g., register events; add fragments to scenes
    -- keeping track of active objects 
    table.insert( self.activeObjects, setId )   
end 



function SetTrackerHandler:InitializeObj( setId )
    -- *setType* defined in database set "setTracker-class" 
    -- (main is the superclass, and all classes are initialized on addon loading)
    -- for any special cases, "specialSets[setId]" defines the unique subclass definition
    local setType = EPT.GetSetType( setId )  
    local obj = self.classes[ setType ]:New( self.specialSets[setId], setId )
    
    -- object specific initialization 
    -- unique elements for each class/subclass
    obj:Initialize()
    -- e.g., populate *setData*; create ui-elements; ....

    -- add object to registry in handler
    self.objectRegistry[setId] = obj
end



function SetTrackerHandler:DeactivateObj( setId ) 
    -- grab obj from registry 
    local obj = self.objectRegistry[setId]
    
    -- remove setId from numeric list of active sets 
    local objIdx = LibExoY.FindNumericKey( self.activeObjects, setId ) 
    table.remove(self.activeObjects, objIdx )

    obj:Deactivate() --e.g., unregister events, remove fragments from scenes...
end