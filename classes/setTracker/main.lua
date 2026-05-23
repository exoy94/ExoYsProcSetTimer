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
    end

    return Obj
end


function SetTrackerMain:Activate() 
    self:RegisterEvents()
    self:AddToScenes() 
end


function SetTrackerMain:Deactivate() 
    self:UnregisterEvents() 
    self:RemoveFromScenes() 
end


function SetTrackerMain:AddToScenes() 
    HUD_UI_SCENE:AddFragment( self.fragment )
    HUD_SCENE:AddFragment( self.fragment )
end


function SetTrackerMain:RemoveFromScenes() 
    HUD_UI_SCENE:RemoveFragment( self.fragment )
    HUD_SCENE:RemoveFragment( self.fragment )
end