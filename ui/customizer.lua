ExoYsProcSetTimer = ExoYsProcSetTimer or {}

local EPT = ExoYsProcSetTimer  
EPT.init = EPT.init or {}

local WM = GetWindowManager() 

local Customizer = { 
    name = "ExoYsProcSetTimer_Customizer", 
    displayId = 0,
    isTemplate = true, 
} 

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

--[[ ----------------------------- ]]
--[[ -- Initialization Function -- ]]
--[[ ----------------------------- ]]

function EPT.init.Customizer_main( ) 
    local Controls = {}

    local Prefix = Customizer.name

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

    Customizer.header = EPT.init.Customizer_header( Prefix.."_Header", ctrl, {offsetY = 50}) 
    Customizer.menu = LibExoY.CreateMenu( Prefix.."_Menu", ctrl, {offsetY = 100} ) 

    --- create option panels 
    for name, data in panelData do 
        local func = EPT.init["Customizer_panel_"..name]
        Customizer.panels[name] = func( Customizer )
        Customizer.menu:AddTab( name, {
            label = data.label, 
            texture = data.texture,  
        } )
        Customizer.menu[name]:AssignPanel( Customizer.panels[name] )
    end

    --- Display Demonstrator 
    Customier.demo = LibExoY.CreateTracker() --- todo 


end


