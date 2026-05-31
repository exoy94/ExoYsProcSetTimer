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

    self.name = name 

    Obj:CreateControls( ) 
    Obj:CreateHeader( ) 
    Obj:CreateMenu( )
    Obj:CreatePreview( ) 
    Obj:CreateSelection( )

    -- selector 
    -- settings 
    -- preview 

    SLASH_COMMANDS["/eptdev"] = function() 
        EPT.ui.customizer.controls.win:ToggleHidden()  
        --local isHidden = win:IsHidden() 
        --win:SetHidden( not isHidden )
    end

    return Obj 
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


function Customizer:CalculateCtrlDimensions() 
--[[ 
    +----------------------width------------------------+
  heightH                 (Header)                      |
    +-----widthC------+-widthD-+------------------------+        
    |                 |        |                        |
  heightB (Selection) | (Menu) |                        |
    |                 |        |       (Settings)    heightA
    +-----------------+--------+                        |
  heightC    (Preview)         |                        |
    +---------widthB-----------+---------widthA---------+

    phi = heightB/heightC = widthA/widthB = widthC/widthD

]]  
    local sizeCoef = 0.6    -- size as screen percentage 
    local phi = 1.618 -- golden ratio (61.8% and 38.2%)
    local screenWidth, screenHeight = GuiRoot:GetDimensions()
    local heightH = 80 -- header
    local d = {}    -- dimensions
    -- horizontal dimensions
    d.width = sizeCoef*screenWidth
    d.widthA = math.floor( d.width/phi )
    d.widthB = d.width - d.widthA 
    d.widthC = math.floor( d.widthB/phi ) 
    d.widthD = d.widthB - d.widthC
    -- vertical dimensions
    d.height = sizeCoef*screenHeight
    d.heightA = d.height - heightH 
    d.heightB = math.floor( d.heightA/phi ) 
    d.heightC = d.heightA - d.heightB 
    d.heightH = heightH
    return d 
end


function Customizer:CreateControls( )
    local controls = {}
    local name = self.name

    --- Dimensions      
    local dim = self:CalculateCtrlDimensions() 

    local win = WM:CreateTopLevelWindow( name.."_Window" ) 
    win:ClearAnchors() 
    win:SetAnchor( CENTER, GuiRoot, CENTER, 0, 0 ) 
    win:SetHidden(false)
    win:SetDrawTier( DT_HIGH )
    win:SetDimensions( dim.width, dim.height )
    --- ToDo Handlers

    controls.win = win

    local ctrl = WM:CreateControl( name.."_Ctrl", win, CT_CONTROL )
    ctrl:ClearAnchors() 
    ctrl:SetAnchor(TOPLEFT, win, TOPLEFT)
    ctrl:SetDimensions( dim.width, dim.height )  
    controls.ctrl = ctrl

    local back = WM:CreateControl( name.."_Back", ctrl, CT_BACKDROP )
    back:ClearAnchors() 
    back:SetAnchor( TOPLEFT, ctrl, TOPLEFT, -2, -2)
    back:SetDimensions( dim.width+4, dim.height+4) 
    back:SetCenterColor(0,0,0,0) 
    back:SetEdgeColor( 0,0,0,1 )
    back:SetEdgeTexture(nil, 4,4,4)
    controls.back = back 

    --- root controls for components  
    local header = WM:CreateControl( name.."_HeaderCtrl", ctrl, CT_CONTROL )
    header:ClearAnchors() 
    header:SetAnchor(TOPLEFT, ctrl, TOPLEFT, 0, 0) 
    header:SetDimensions( dim.width, dim.heightH )  
    controls.header = header

    local selection = WM:CreateControl( name.."_SelectionCtrl", ctrl, CT_CONTROL )
    selection:ClearAnchors() 
    selection:SetAnchor(TOPLEFT, ctrl, TOPLEFT, 0, dim.heightH) 
    selection:SetDimensions( dim.widthC, dim.heightB)  
    controls.selection = selection

    local menu = WM:CreateControl( name.."_MenuCtrl", ctrl, CT_CONTROL )
    menu:ClearAnchors() 
    menu:SetAnchor(TOPLEFT, ctrl, TOPLEFT, dim.widthC, dim.heightH) 
    menu:SetDimensions(dim.widthD, dim.heightB) 
    controls.menu = menu

    local settings = WM:CreateControl( name.."_SettingsCtrl", ctrl, CT_CONTROL )
    settings:ClearAnchors() 
    settings:SetAnchor(TOPLEFT, ctrl, TOPLEFT, dim.widthB, dim.heightH) 
    settings:SetDimensions( dim.widthA, dim.heightA ) 
    controls.settings = settings

    local preview = WM:CreateControl( name.."_PreviewCtrl", ctrl, CT_CONTROL )
    preview:ClearAnchors() 
    preview:SetAnchor(TOPLEFT, ctrl, TOPLEFT, 0, dim.heightH + dim.heightB ) 
    preview:SetDimensions( dim.widthB, dim.heightC)
    controls.preview = preview

    --- Temporary to show settings
    local back = WM:CreateControl( name.."SettingsBG", settings, CT_BACKDROP) 
    back:ClearAnchors() 
    back:SetAnchor(TOPLEFT, settings, TOPLEFT, 0, 0) 
    back:SetDimensions( settings:GetDimensions() )
    back:SetCenterColor(0,1,0,0.3)
    local label = WM:CreateControl( name.."SettingsLabel", settings, CT_LABEL) 
    label:ClearAnchors() 
    label:SetAnchor(CENTER, back, CENTER, 0, 0) 
    label:SetColor(1,1,1,1) 
    label:SetFont(LibExoY.GetFont(40))
    label:SetText("Settings")
    LibExoY.AnchorLabelText(label, CENTER) 

    --[[
    --- Header    
    
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

    --- Display Demonstrator 
    -- GetSettingsBasedOnSelection( template, id) 
    --Customier.demo = LibExoY.CustomTracker() --- todo

    --Customizer.header = EPT.init.Customizer_header( Prefix.."_Header", ctrl, {offsetY = 50}) 
    --Customizer.menu = LibExoY.CreateMenu( Prefix.."_Menu", ctrl, {offsetY = 100} ) 

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
    ]]
    self.controls = controls
end


function Customizer:CreateHeader() 
    local name = self.name.."_Header"
    local ctrl = self.controls.header
    local header = {}

    local width, height = ctrl:GetDimensions() 

    --- Temporary to show ctrlSize 
    local back = WM:CreateControl( name.."Back", ctrl, CT_BACKDROP) 
    back:ClearAnchors() 
    back:SetAnchor(TOPLEFT, ctrl, TOPLEFT, 0, 0) 
    back:SetDimensions( width, height )
    back:SetCenterColor(1,1,1,0.3)

    local logo = WM:CreateControl( name.."Logo", ctrl, CT_TEXTURE ) 
    logo:ClearAnchors() 
    logo:SetAnchor( TOPLEFT, ctrl, TOPLEFT, 2.5, 2.5 )
    logo:SetDimensions(height-5, height-5)
    logo:SetTexture( "/ExoYsProcSetTimer/textures/logo_100.dds" ) 
    header.logo = logo 

    local mainTitle = WM:CreateControl( name.."MainTitle", ctrl, CT_LABEL )
    mainTitle:ClearAnchors() 
    mainTitle:SetAnchor( TOP, ctrl, TOP ) 
    mainTitle:SetFont( LibExoY.GetFont(35) ) 
    mainTitle:SetColor( 211/255,175/255,55/255 )
    mainTitle:SetText("ExoY's ProcSet Timer")
    mainTitle:SetDimensions( mainTitle:GetTextDimensions() )
    LibExoY.AnchorLabelText( mainTitle, TOP )
    header.mainTitle = mainTitle

    local subTitle = WM:CreateControl( name.."SubTitle", ctrl, CT_LABEL )
    subTitle:ClearAnchors() 
    subTitle:SetAnchor( TOP, mainTitle, BOTTOM, 0, 0 ) 
    subTitle:SetFont( LibExoY.GetFont(25) ) 
    subTitle:SetColor( 1,1,1,1 )
    subTitle:SetText("Customizer")
    subTitle:SetDimensions( subTitle:GetTextWidth(), 50 )
    LibExoY.AnchorLabelText( subTitle, TOP )
    header.subTitle = subtitle 

    local exitButton = WM:CreateControl( name.."ExitButton", ctrl, CT_BUTTON ) 
    exitButton:ClearAnchors() 
    exitButton:SetAnchor(TOPLEFT, ctrl, TOPLEFT)
    header.exitButton = exitButton 

    self.header = header 
end


function Customizer:CreateSelection( )
    local name = self.name.."_Selection" 
    local ctrl = self.controls.selection

    --- Temporary to show ctrlSize 
    local back = WM:CreateControl( name.."Back", ctrl, CT_BACKDROP) 
    back:ClearAnchors() 
    back:SetAnchor(TOPLEFT, ctrl, TOPLEFT, 0, 0) 
    back:SetDimensions( ctrl:GetDimensions() )
    back:SetCenterColor(0,1,1,0.3)
    local label = WM:CreateControl( name.."Label", ctrl, CT_LABEL) 
    label:ClearAnchors() 
    label:SetAnchor(CENTER, back, CENTER, 0, 0) 
    label:SetColor(1,1,1,1) 
    label:SetFont(LibExoY.GetFont(40))
    --label:SetText("Selection")
    LibExoY.AnchorLabelText(label, CENTER) 

    --- Profile Selection 
    --local 
    local profileSelectionConfig = {
        choices = EPT.pm:GetProfileList(),
        -- for current value:  EPT.pm:GetActiveProfileName()
        offsetX = 50,
        offsetY = 100, 
        OnItemSelected = function(_, selected) LibExoY.Print("Change Profile", "EPT-Customizer") end,  
    }
    local profileSelection = LibExoY.CreateDropdown( name.."_ProfileDropdown", ctrl, profileSelectionConfig )

    --- Set Selection  
    --local currentSet = WM:CreateControl( name.."_CurrentSet", ctrl, CT_LABEL) 
    --currentSet:ClearAnchors() 
    --currentSet:SetAnchor( TOPLEFT, ctrl, TOPLEFT, 50, 100) 
    --currentSet:SetFont( LibExoY.GetFont() )
    --currentSet:SetText( EPT.supportedSetNames[1] ) 
    local setSelectionConfig = {
        choices = EPT.sets.setName,
        offsetX = 50,
        offsetY = 200, 
        OnItemSelected = function(_, selected) LibExoY.Print("Changed Set", "EPT-Customizer") end,  
    }
    local setSelection = LibExoY.CreateDropdown( name.."_SetsDropdown", ctrl, setSelectionConfig ) 
    
    local searchBox = WM:CreateControl( name.."SearchBox", ctrl, CT_EDITBOX)
    searchBox:ClearAnchors() 
    searchBox:SetAnchor(TOPLEFT, ctrl, TOPLEFT, 100, 150) 
    searchBox:SetDimensions( 100, 40 ) 
    searchBox:SetFont( LibExoY.GetFont() ) 
    searchBox:SetText() 
    searchBox:SetMouseEnabled(true) 
    searchBox:SetTextType(TEXT_TYPE_ALL)
    searchBox:SetHandler("OnMouseDown", function() searchBox:TakeFocus() end)
    searchBox:SetHandler("OnTextChanged", function() d(searchBox:GetText() ) end )
    searchBox:SetHandler("OnFocusLost", function() d(searchBox:GetText() ) end) 

    local searchBack = WM:CreateControl( name.."SearchBg", ctrl, CT_BACKDROP )
    searchBack:ClearAnchors() 
    searchBack:SetAnchor(CENTER, searchBox, CENTER, 0, 0) 
    searchBack:SetDimensions( searchBox:GetDimensions() ) 
    searchBack:SetCenterColor(0.2, 0.2, 0.2, 0.8 ) 
    searchBack:SetEdgeColor(0,0,0,0.9) 
    searchBack:SetEdgeTexture(nil, 2,2,2)
end


function Customizer:CreateMenu()
    local name = self.name.."_Menu"   
    local ctrl = self.controls.menu 

    --- Temporary to show ctrlSize 
    local back = WM:CreateControl( name.."Back", ctrl, CT_BACKDROP) 
    back:ClearAnchors() 
    back:SetAnchor(TOPLEFT, ctrl, TOPLEFT, 0, 0) 
    back:SetDimensions( ctrl:GetDimensions() )
    back:SetCenterColor(1,0,0,0.3)
    local label = WM:CreateControl( name.."Label", ctrl, CT_LABEL) 
    label:ClearAnchors() 
    label:SetAnchor(CENTER, back, CENTER, 0, 0) 
    label:SetColor(1,1,1,1) 
    label:SetFont(LibExoY.GetFont(40))
    label:SetText("Menu")
    LibExoY.AnchorLabelText(label, CENTER) 

    local configMenu = {
        tabDirection = "vertical", 
        offsetX = 50, 
        offsetY = 200, 
        width = 200, 
        height = 50, 
    }

    local menu = LibExoY.CreateMenu( name, ctrl, configMenu ) 
    self.menu = menu 
end


function Customizer:CreatePreview( )
    local name = self.name.."_Preview" 
    local ctrl = self.controls.preview 

    --- Temporary to show ctrlSize 
    local back = WM:CreateControl( name.."Back", ctrl, CT_BACKDROP) 
    back:ClearAnchors() 
    back:SetAnchor(TOPLEFT, ctrl, TOPLEFT, 0, 0) 
    back:SetDimensions( ctrl:GetDimensions() )
    back:SetCenterColor(0,0,0,1)
    back:SetAlpha(0.5)
    local label = WM:CreateControl( name.."Label", ctrl, CT_LABEL) 
    label:ClearAnchors() 
    label:SetAnchor(CENTER, back, CENTER, 0, 0) 
    label:SetColor(1,1,1,1) 
    label:SetFont(LibExoY.GetFont(40))
    label:SetText("Preview")
    LibExoY.AnchorLabelText(label, CENTER) 

    local alphaSliderConfig = {
        min = 0, 
        max = 1, 
        step = 0.1,
        value = 0.5, 
        text = "Background Transparency", 
        anchorChild = BOTTOMLEFT, 
        anchorParent = BOTTOMLEFT, 
        OnValueChanged = function(value) 
            back:SetAlpha(value) 
        end,
    }
    local alphaSlider = LibExoY.CreateSlider( name.."AlphaSlider", ctrl, alphaSliderConfig)

    --local demoScaleSlider =

end









