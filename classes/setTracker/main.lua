--- Addon Namespace
local EPT = ExoYsProcSetTimer 

--- Libraries
local LibExoY = LibExoYsUtilities
local LSD = LibSetDetection

--- Object Table
local SetTrackerMain = {}

--- Distribution Tables
EPT.initialize.setTracker["main"] = SetTrackerMain
EPT.defaults.setTracker["main"] = {
    size = 50,
}



--- Constructor for SetTracker-Classes  
-- definition of classes when *setId* = nil 
-- Obj also used to define subclasses for special sets 
function SetTrackerMain:New( Obj, setId ) 
    Obj = setmetatable(Obj or {}, self)
    self.__index = self 

    if setId then 
        -- general properties relevant for every tracker objet 
        Obj.setId = setId 
        Obj.name = "EPT_SetTracker_"..tostring(setId)   -- used for controlls 
        Obj.sceneFragments = {} -- table of fragements for scenes 
        -- setData properties for every tracker object provided as metatable
        local setDataMetaIndex = { 
            setName = LSD.GetSetName( setId ), 
            setType = LSD.GetSetType( setId ), 
        }
        -- class specific variables are defined in class-initialization routine
        Obj.setData = setmetatable( EPT.GetSetData( setId ), {__index = setDataMetaIndex} )
        Obj:BuildConfigTable() 
    end
    return Obj
end


--- Activation / Deactivation 
-- called when a set is (un)equipped 
-- all classes and subclasses must define their own version of  
-- RegisterEvents() and UnregisterEvents() for it to work 
function SetTrackerMain:Activate() 
    self:RegisterEvents()
    self:AddToScenes() 
end

function SetTrackerMain:Deactivate() 
    self:UnregisterEvents() 
    self:RemoveFromScenes() 
end

-- every setTrackerObj has a "sceneFragments" table, defined in constructor
-- scenes ("hud" and "hudui") are hardcoded and applied to all fragments for now @todo
function SetTrackerMain:AddToScenes() 
    for _, fragment in ipairs( self.sceneFragments) do 
        HUD_UI_SCENE:AddFragment( fragment )
        HUD_SCENE:AddFragment( fragment )
    end
end

function SetTrackerMain:RemoveFromScenes() 
    for _, fragment in ipairs( self.sceneFragments) do 
        HUD_UI_SCENE:RemoveFragment( fragment )
        HUD_SCENE:RemoveFragment( fragment )
    end
end


--- Configuration 
function SetTrackerMain:BuildConfigTable() 
    local setId = self.setId 
    local class = EPT.GetSetClass( setId )
    
    local templates = EPT.setTracker.configTemplates

    -- loading set specific save variables, if they exist
    local setSV = EPT.savedVariables.p.setTracker.sets[setId] or {}

    -- check if there are any set specific default values
    -- this in theory can also be the case without the set being a special class
    -- if it is only a derivative of an existing class 
    local setDefaults = EPT.defaults.setTracker.sets[setId] or {}

    -- check if set has entires in 
    --local meta = setmetatable(  )
    --EPT.sv.p.setConfig[setId],  
    
    if class == "special" then
        -- no class template 
        local setConfigDefault = setmetatable( setDefaults, {__index = templates[ "main" ]})
        self.config =   setmetatable( setSV, {__index = setConfigDefault })
    else 
        local setConfigDefault = setmetatable( setDefaults, {__index = templates[ class ]})
        self.config =   setmetatable( setSV, {__index = setConfigDefault })
    end 
end