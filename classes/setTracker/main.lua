ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer 

--- Libraries
local LibExoY = LibExoYsUtilities
local LSD = LibSetDetection


--- Object Table
local SetTrackerMain = {}
EPT.setTrackerClass = EPT.setTrackerClass or {} -- distribution table for initialization
EPT.setTrackerClass.main = SetTrackerMain 


--- Constructor for subclasses and tracker objects 
-- definition of classes when *setId* = nil 
-- Obj also used to define subclasses for special sets 
function SetTrackerMain:New( Obj, setId ) 
    Obj = setmetatable(Obj or {}, self)
    self.__index = self 

    if setId then 
        -- general properties relevant for every tracker objet 
        Obj.setId = setId 
        Obj.name = "EPT_SetTracker_"..tostring(setId)
        Obj.sceneFragments = {} -- table of fragements for scenes 
        -- setData properties for every tracker object 
        -- class specific variables defined in class-initialization routine
        local setDataMetaIndex = { 
            setName = LSD.GetSetName( setId ), 
            setType = LSD.GetSetType( setId ), 
        }
        Obj.setData = setmetatable( EPT.GetSetData( setId ), {__index = setDataMetaIndex} )
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
-- scenes ("hud" and "hudui") are hardcoded and applied to all fragments 
function SetTrackerMain:AddToScenes() 
    for _, fragment in ipairs( self.sceneFragements) do 
        HUD_UI_SCENE:AddFragment( fragment )
        HUD_SCENE:AddFragment( fragment )
    end
end

function SetTrackerMain:RemoveFromScenes() 
    for _, fragment in ipairs( self.sceneFragements) do 
        HUD_UI_SCENE:RemoveFragment( fragment )
        HUD_SCENE:RemoveFragment( fragment )
    end
end