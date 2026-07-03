ExoYsProcSetTimer = {}
local EPT = ExoYsProcSetTimer 

--[[ Notes ]]
--- Task-List 
-- [x] change to new lsd constants
-- [x] build addon/ init tables... move explanation/ concepts there
-- [ ] check which event (2240 or 2245) is more working for more sets for basic proc 
-- [ ] update naming in slider and add resize function
-- [ ] profile change in customizer 
-- [ ] debug and comment profile manager 
-- [ ] set selection dropdown (search field + update dropdown selection)
-- [ ] automatic update of search dropdown based on search text 
-- [ ] detection if search text is number and then only compare with setId 
-- [ ] show setIds as option 

--- Concept: 
-- in dem moment, wo ich bei meinem setTracker obj von der lib mehr mache als die standard ui elements zu nutzen 
--  zählt das set zu special sets  / subclass e.g. second icon, second tracker etc 
-- aber subclass/ new class heißt nicht, dass etwas beim tracker geändert werden muss e.g. stack and proc (mit 1 icon und 1 bar)  

--- Configuration 
-- advanced implementation of settings, enables inheritance structure 
-- only settings different to the default values are written to saved variables to reduce file-size 
-- templates for each classes are defined in handler based on current profile 'BuildConfigTemplate()'
--    and saved in EPT.defaults.setTracker
-- each class instance has its own config table 'BuildConfigTable()'


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

