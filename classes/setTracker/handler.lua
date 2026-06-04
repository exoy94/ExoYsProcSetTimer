ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer 

--- Libraries 
local LibExoY = LibExoYsUtilities

--- Object Table 
local SetTrackerHandler = {}    
EPT.setTrackerClass = EPT.setTrackerClass or {}     -- distribution table for initialization 
EPT.setTrackerClass.handler = SetTrackerHandler 

--- Info 
-- providdes all standard set classes  
-- contains subclass definition for special sets
-- keeps track of existing tracker objects
-- keeps track of currently active tracker 

-- Note: 
--  Little bit of a weird Class, as I currently dont intend to  have more then one object of it. 
--  I decided to leave it as a class, incase I come across a special application later

function SetTrackerHandler:New() 
    local obj = setmetatable({}, self)
    self.__index = self  

    obj.classes = {} -- template objects of all standard set classes 
    obj.specialSets = {} -- subclass definitions for unique sets 
    obj.objectRegistry = {}    -- list of all existing set tracker objects (no pool) 
    obj.activeObjects = {}    -- list (numeric) of all active tracker objects by *setId* 

    obj.configTemplates = { main = {} } 
    for _, class in ipairs( EPT.setTrackerClassList ) do 
        obj.configTemplates[class] = {}
    end

    return obj 
end



function SetTrackerHandler:ActivateObj( setId )
    -- check if set-specific object already exists
    -- if not, create and initialize it 
    if not self.objectRegistry[setId] then 
        -- object is automatically added to registry 
        self:InitializeObj( setId ) -- e.g. name, standard *setData*
    end 
    -- grabs object from registry 
    local obj = self.objectRegistry[setId] 
    obj:Activate() -- e.g., register events; add fragments to scenes
    -- keeping track of active objects 
    table.insert( self.activeObjects, setId )   
end 



function SetTrackerHandler:InitializeObj( setId )
    -- *class* defined in database (main is the superclass, and all classes are initialized on addon loading)
    -- for any special cases, "specialSets[setId]" defines the unique subclass definition
    local class = EPT.GetSetClass( setId )  
    local obj = self.classes[ class ]:New( self.specialSets[setId], setId )
    
    -- object specific initialization 
    -- unique function for each class/subclass
    obj:Initialize() -- e.g., populate unique *setData*; create ui-elements; ....

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



function SetTrackerHandler:BuildConfigTemplates()
    local config = self.configTemplates 
    local defaults = EPT.defaults.setTracker 
    
    local defaults = EPT.defaults.setTracker
    config["main"] = setmetatable(EPT.sv.p.setTracker.main, {__index = defaults.main})
    for _, class in ipairs( EPT.setTrackerClassList ) do 
        local classConfigDefault = setmetatable( defaults[class], {__index = config["main"]} )
        config[ class ] = setmetatable(EPT.sv.p.setTracker.classes[class], {__index = classConfigDefault } )
    end        
end


function SetTrackerHandler:UpdateConfigTables() 
    --- @ToDo 
    -- for each existing set tracker do 
    -- build config table 
    -- apply configs 
end