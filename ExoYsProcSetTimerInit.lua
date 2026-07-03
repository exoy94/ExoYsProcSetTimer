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

EPT.defaults["setTracker"] = {}
EPT.defaults.setTracker["sets"] = {}


--[[ --------------------- ]]
--[[ -- User Interfacer -- ]]
--[[ --------------------- ]]

EPT.initialize.userInterface = {} 



--[[ --------------------- ]]
--[[ -- Saved Variables -- ]]
--[[ --------------------- ]]

EPT.defaults["global"] = {

} 


EPT.defaults["profile"] = {
    setTracker = {
        main = {},
        classes = {}, -- contains subtables for each class, initialized hereafter 
        sets = {},
    }
} 

do 
    for _, class in ipairs( EPT.setTrackerClassList ) do 
        EPT.defaults.profile.setTracker.classes[class] = {}
    end
end

