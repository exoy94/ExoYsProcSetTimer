ExoYsProcSetTimer = {}

local EPT = ExoYsProcSetTimer 

--- Addon Variables 
EPT.name = "ExoYsProcSetTimer"
EPT.version = "3.0.0"



EPT.defaults = {}   -- for saved variables and templates  
EPT.initialize = {}   -- distribution table for initialization 

--[[ ---------------- ]]
--[[ -- SetTracker -- ]] 
--[[ ---------------- ]]

--- Class List 
-- overview of all defined classes 
-- used to iterate over classes for 
--  + define classes from super-class
--  + define config tables 
--  + allocate subtables in saved variables 
EPT.setTrackerClassList = {
    "proc", 
}

EPT.initialize["setTracker"] = {} 
EPT.initialize.setTracker["specialSets"] = {}


--- Defaults for Templates 
EPT.defaults["setTracker"] = {}
EPT.defaults.setTracker["sets"] = {}


--[[ --------------------- ]]
--[[ -- User Interfacer -- ]]
--[[ --------------------- ]]

--- Distribution Table 
EPT.initialize.userInterface = {} 



--[[ --------------------- ]]
--[[ -- Saved Variables -- ]]
--[[ --------------------- ]]

--- Global
EPT.defaults["global"] = {

} 


--- Profile
EPT.defaults["profile"] = {
    setTracker = {
        main = {},
        classes = {}, -- contains subtables for each subclass 
        sets = {},
    }
} 

do 
    for _, class in ipairs( EPT.setTrackerClassList ) do 
        EPT.defaults.profile.setTracker.classes[class] = {}
    end
end



---@todo do i need those 
--[[ ---------------------- ]]
--[[ -- Global Constants -- ]]
--[[ ---------------------- ]]

--[[
EPT_SET_CLASS_PROC = "proc"
EPT_SET_TYPE_GROUP = "group"
EPT_SET_TYPE_STACK = "stack"
EPT_SET_TYPE_TOGGLE = "toggle"

function EPT.GetSetTypeList() 
    return {
        EPT_SET_TYPE_PROC,
        EPT_SET_TYPE_GROUP, 
        EPT_SET_TYPE_STACK,  
        EPT_SET_TYPE_STACK,
    }
end

EPT_STACK_TYPE_SELF = 1
EPT_STACK_TYPE_TARGET = 2 

function EPT.GetStackTypeList() 
    return {
        EPT_STACK_TYPE_SELF = "self", 
        EPT_STACK_TYPE_TARGET = "target", 
    }
end 
]]