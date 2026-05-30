ExoYsProcSetTimer = ExoYsProcSetTimer or {}
local EPT = ExoYsProcSetTimer  

--- Libraries 
local LibExoY = LibExoYsUtilities

local WM = GetWindowManager() 

--- Object Table 
local Customizer = {}
EPT.userInterface = EPT.userInterface or {} -- distribution table for initialization 
EPT.userInterface.customizer = Customizer



--[[ ---------------------- ]]
--[[ -- Panel Definition -- ]]
--[[ ---------------------- ]]

local settingsPanel = {
    ["general"] = {
        label = EPT_CUSTOMIZER_PANEL_GENERAL, 
        texture = "", 
    }
}

--[[ ----------------------- ]]
--[[ -- Object Definition -- ]]
--[[ ----------------------- ]]


function Customizer:New( name ) 
    local Obj = setmetatable({}, self) 
    self.__index = self 

    Obj:CreateControls( name ) 

    -- header 
    -- selector
    -- menu 
    -- settings 
    -- preview 

    SLASH_COMMANDS["/eptdev"] = function() 
        EPT.ui.customizer.controls.win:ToggleHidden()  
        --local isHidden = win:IsHidden() 
        --win:SetHidden( not isHidden )
    end

    return Obj 
end


function Customizer:CreateControls( name ) 
    local controls = {}

    --- Dimensions  
    local screenWidth, screenHeight = GuiRoot:GetDimensions()
    local param = {
        width = 0.6*screenWidth, 
        height = 0.6*screenHeight, 
        posX = 0.2*screenWidth,
        posY = 0.2*screenHeight,
        menuWidth = 200, 
    }

    local win = WM:CreateTopLevelWindow( name.."_Window" ) 
    win:ClearAnchors() 
    win:SetAnchor( TOPLEFT, GuiRoot, TOPLEFT, param.posX, param.posY ) 
    win:SetHidden(false)
    win:SetDrawTier( DT_HIGH )
    --- ToDo Handlers
    controls.win = win

    local ctrl = WM:CreateControl( name.."_Ctrl", win, CT_CONTROL )
    ctrl:ClearAnchors() 
    ctrl:SetAnchor(TOPLEFT, win, TOPLEFT)
    ctrl:SetDimensions( param.width, param.height )  
    controls.ctrl = ctrl

    local back = WM:CreateControl( name.."_Back", ctrl, CT_BACKDROP )
    back:ClearAnchors() 
    back:SetAnchor( TOPLEFT, ctrl, TOPLEFT, -2, -2)
    back:SetDimensions(param.width+4,param.height+4) 
    back:SetCenterColor(0,0,0,0.5) 
    back:SetEdgeColor( 211/255,175/255,55/255 )

    --- All the Controls 
    local header = WM:CreateControl( name.."_HeaderRoot", ctrl, CT_CONTROL )
    header:ClearAnchors() 
    header:SetAnchor(TOPLEFT, ctrl, TOPLEFT, 0, 0) 
    header:SetDimensions(param.width, 100)  
    local backHeader = WM:CreateControl( name.."_HeaderBg", header, CT_BACKDROP) 
    backHeader:ClearAnchors() 
    backHeader:SetAnchor(TOPLEFT, header, TOPLEFT, 0, 0) 
    backHeader:SetDimensions( backHeader:GetParent():GetDimensions() )
    backHeader:SetCenterColor(1,1,1,0.3)

    local selection = WM:CreateControl( name.."_SelectionRoot", ctrl, CT_CONTROL )
    selection:ClearAnchors() 
    selection:SetAnchor(TOPLEFT, ctrl, TOPLEFT, 0, 100) 
    selection:SetDimensions(param.width, 200)  
    local backSelection = WM:CreateControl( name.."_SelectionBg", selection, CT_BACKDROP) 
    backSelection:ClearAnchors() 
    backSelection:SetAnchor(TOPLEFT, selection, TOPLEFT, 0, 0) 
    backSelection:SetDimensions( backSelection:GetParent():GetDimensions() )
    backSelection:SetCenterColor(1,0,1,0.3)

    local menu = WM:CreateControl( name.."_MenuRoot", ctrl, CT_CONTROL )
    menu:ClearAnchors() 
    menu:SetAnchor(TOPLEFT, ctrl, TOPLEFT, 0, 300) 
    menu:SetDimensions(param.menuWidth, param.height-300)  
    local backMenu = WM:CreateControl( name.."_MenuBg", menu, CT_BACKDROP) 
    backMenu:ClearAnchors() 
    backMenu:SetAnchor(TOPLEFT, menu, TOPLEFT, 0, 0) 
    backMenu:SetDimensions( backMenu:GetParent():GetDimensions() )
    backMenu:SetCenterColor(1,0,0,0.3)

    local settings = WM:CreateControl( name.."_SettingsRoot", ctrl, CT_CONTROL )
    settings:ClearAnchors() 
    settings:SetAnchor(TOPLEFT, ctrl, TOPLEFT, param.menuWidth, 300) 
    settings:SetDimensions(param.width-param.menuWidth, (param.height-300)/2) 
    local backSettings = WM:CreateControl( name.."_SettingsBg", settings, CT_BACKDROP) 
    backSettings:ClearAnchors() 
    backSettings:SetAnchor(TOPLEFT, settings, TOPLEFT, 0, 0) 
    backSettings:SetDimensions( backSettings:GetParent():GetDimensions() )
    backSettings:SetCenterColor(0,1,0,0.3) 

    local preview = WM:CreateControl( name.."_PreviewRoot", ctrl, CT_CONTROL )
    preview:ClearAnchors() 
    preview:SetAnchor(TOPLEFT, ctrl, TOPLEFT, param.menuWidth, 300+(param.height-300)/2) 
    preview:SetDimensions(param.width-param.menuWidth, (param.height-300)/2)  
    local backPreview = WM:CreateControl( name.."_PrevieBg", preview, CT_BACKDROP) 
    backPreview:ClearAnchors() 
    backPreview:SetAnchor(TOPLEFT, preview, TOPLEFT, 0, 0) 
    backPreview:SetDimensions( backPreview:GetParent():GetDimensions() )
    backPreview:SetCenterColor(0,0,1,0.3)

    --- Header 
    local logo = WM:CreateControl( name.."_Logo", ctrl, CT_TEXTURE ) 
    logo:ClearAnchors() 
    logo:SetAnchor( TOPLEFT, ctrl, TOPLEFT )
    logo:SetDimensions(50, 50)
    logo:SetTexture( "/ExoYsProcSetTimer/textures/logo_100.dds" ) 

    local title = WM:CreateControl( name.."_Title", ctrl, CT_LABEL )
    title:ClearAnchors() 
    title:SetAnchor( TOPLEFT, ctrl, TOPLEFT, 100, 0 ) 
    title:SetFont( LibExoY.GetFont(50) ) 
    title:SetColor( 211/255,175/255,55/255 )
    title:SetText("ExoY's ProcSet Timer - Customizer")
    title:SetDimensions( title:GetTextWidth(), 50 )
    LibExoY.AnchorLabelText( title, LEFT )
    
    

    --- Set/Profile Selection 
    local currentSet = WM:CreateControl( name.."_CurrentSet", ctrl, CT_LABEL) 
    currentSet:ClearAnchors() 
    currentSet:SetAnchor( TOPLEFT, ctrl, TOPLEFT, 50, 100) 
    currentSet:SetFont( LibExoY.GetFont() )
    currentSet:SetText( EPT.supportedSetNames[1] ) 

    local setSelectionConfig = {
        choices = EPT.supportedSetNames,
        offsetX = 200,
        offsetY = 100, 
        OnItemSelected = function(_, selected) currentSet:SetText(selected) end,  
    }
    local setSelection = LibExoY.CreateDropdown( name.."_SetSelection", ctrl, setSelectionConfig )  

    local currentProfile = WM:CreateControl( name.."_CurrentProfile", ctrl, CT_LABEL) 
    currentProfile:ClearAnchors() 
    currentProfile:SetAnchor( TOPLEFT, ctrl, TOPLEFT, 50, 200) 
    currentProfile:SetFont( LibExoY.GetFont() )
    currentProfile:SetText( EPT.pm:GetActiveProfileName() )

    --- Submenu     
    local slider1 = LibExoY.CreateSlider( name.."Slider1", ctrl, {offsetX = 300, offsetY = 300}) 
    local slider2 = LibExoY.CreateSlider( name.."Slider2", ctrl, {offsetX = 500, offsetY = 300})
    
    local menuConfig = {
        offsetX = 50, 
        offsetY = 200, 
        width = 200, 
        height = 50, 
    }
    local menuObj = LibExoY.CreateMenu( name.."_Menu", ctrl, menuConfig ) 
    menuObj:AddTab( "general" )
    menuObj:AddTab( "test" )
    self.menuObj = menuObj 


    

    --- Display Demonstrator 
    -- GetSettingsBasedOnSelection( template, id) 
    --Customier.demo = LibExoY.CustomTracker() --- todo


    --Customizer.header = EPT.init.Customizer_header( Prefix.."_Header", ctrl, {offsetY = 50}) 
    --Customizer.menu = LibExoY.CreateMenu( Prefix.."_Menu", ctrl, {offsetY = 100} ) 

    --[[

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

    ]] 

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

    self.controls = controls
end




function Customizer:OpenWindow( setId, isTemplate )
    -- when isTemplate dann is setId = setClass constant 

    -- input tells the window how to initialize itself, 
    -- with respect to which template/set to load 
    -- this way i can move the setup of all the panels and stuff outside of the initialization end

end



function Customizer:CloseWindow() 
    -- apply new settings to all relevant active tracker objeects 
    -- 
end


