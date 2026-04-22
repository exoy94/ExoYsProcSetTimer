ExoYsProcSetTimer = ExoYsProcSetTimer or {}

local EPT = ExoYsProcSetTimer  
EPT.init = EPT.init or {}

local WM = GetWindowManager() 


--[[ ---------------------- ]]
--[[ -- Panel Definition -- ]]
--[[ ---------------------- ]]

local settingsPanel = {
    ["general"] = {
        label = EPT_CUSTOMIZER_PANEL_GENERAL, 
        texture = "", 
    }
}

local function Initialize_panel_general() 
    local controls = {}

    
    return controls 
end

--[[ ----------------------- ]]
--[[ -- Object Definition -- ]]
--[[ ----------------------- ]]

local Customizer = {}

function Customizer:New(  ) 
    local UI = setmetatable({}, self) 
    self.__index = self 

    UI:CreateControls() 

    return UI 
end


function Customizer:CreateControls() 
    local Controls = {}

    local win = WM:CreateTopLevelWindow( Prefix.."_Window" ) 
    win:ClearAnchors() 
    win:SetAnchor( TOPLEFT, GuiRoot, TOPLEFT, offsetX, offsetY ) 
    controls.win = win

    local ctrl = WM:CreateControl( Prefix.."_Ctrl", win, CT_CONTROL )
    ctrl:ClearAnchors() 
    ctrl:SetAnchor() 
    controls.ctrl = ctrl

    local back = WM:CreateControl( Prefix.."_Back", ctrl, CT_BACKDROP )

    local title = WM:CreateControl( Prefix.."_Title", ctrl, CT_LABEL )
    title:ClearAnchors() 
    title:SetAnchor( TOP, ctrl, TOP, 0, 0 ) 
    title:SetFont(24) 
    title:SetText("ExoY's ProcSet Timer\nCustomizer")
    title:SetHorizontalAlignment(TEXT_ALIGN_CENTER)

    --- Display Demonstrator 
    -- GetSettingsBasedOnSelection( template, id) 
    Customier.demo = LibExoY.CustomTracker() --- todo


    Customizer.header = EPT.init.Customizer_header( Prefix.."_Header", ctrl, {offsetY = 50}) 
    Customizer.menu = LibExoY.CreateMenu( Prefix.."_Menu", ctrl, {offsetY = 100} ) 

    --- create option panels 
    for name, data in panelData do 
        local func = EPT.init["Initialize_panel_"..name]
        Customizer.panel[name] = func( xxx )
        Customizer.menu:AddTab( name, {
            label = data.label, 
            texture = data.texture,  
        } )
        Customizer.menu[name]:AssignPanel( Customizer.panels[name] )
    end

    ---ToDo concept / pseudo-code
    --local settings = SettingsOfCurrentSelection 
    --selectTheGeneralPanel 

    --Customizer.panel[name].ApplySettings( currentSettings )




    --- ToDo ctrls: 
    -- set selection window 

    --- ToDo Notes
    -- Setter function for settings controls based on current selection 
    -- only need to be performed for current panel and when a panel is activated 
    -- event/Getter: 
        -- wenn a setting is changed apply it to the demo obj 
        -- save it to the currently selected settings (template/ setId) 


end




function Customizer:OpenWindow( setId, isTemplate )
    -- when isTemplate dann is setId = setType constant 

    -- input tells the window how to initialize itself, 
    -- with respect to which template/set to load 
    -- this way i can move the setup of all the panels and stuff outside of the initialization end

end

function Customizer:CloseWindow() 
    -- apply new settings to all relevant active tracker objeects 
    -- 
end



function EPT.init.Customizer_main( ... )
    return Customizer:New(...)     
end