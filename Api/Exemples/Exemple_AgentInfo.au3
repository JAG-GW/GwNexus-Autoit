#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <TreeViewConstants.au3>
#include <GuiTreeView.au3>
#include "../Base.au3"
#include "../Queries/AgentInfo.au3"
#include "../Queries/CharacterCtxInfo.au3"

; Global variables
Global $g_hGUI, $g_idCharInput, $g_idConnectBtn, $g_idInfoTree, $g_idAgentIDInput, $g_idEffectIndexInput
Global $g_idGetInfoBtn, $g_idGetAllAgentsBtn, $g_idGetLivingArrayBtn, $g_idGetItemArrayBtn, $g_idGetGadgetArrayBtn, $g_idLog, $g_idClear, $g_idExit
Global $g_bConnected = False

; Create user interface
Func CreateInterface()
    $g_hGUI = GUICreate("GwNexus - Agent Info Explorer", 950, 650)

    ; Connection section
    GUICtrlCreateGroup("Connection", 10, 10, 930, 60)
    GUICtrlCreateLabel("Character name for GwNexus_Initialize:", 20, 30, 250, 20)
    $g_idCharInput = GUICtrlCreateInput("", 270, 30, 550, 20)
    $g_idConnectBtn = GUICtrlCreateButton("Connect", 830, 30, 100, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Agent info navigation section
    GUICtrlCreateGroup("Agent Information", 10, 80, 320, 520)
    $g_idInfoTree = GUICtrlCreateTreeView(20, 100, 300, 450, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_SHOWSELALWAYS))

    ; Input fields for agent ID and effect index
    GUICtrlCreateLabel("Agent ID:", 20, 555, 80, 20)
    $g_idAgentIDInput = GUICtrlCreateInput("", 100, 555, 80, 20)
    GUICtrlCreateLabel("Effect Index:", 20, 580, 80, 20)
    $g_idEffectIndexInput = GUICtrlCreateInput("0", 100, 580, 80, 20)

    ; Buttons for queries
    $g_idGetInfoBtn = GUICtrlCreateButton("Get Selected Info", 190, 555, 130, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Results section
    GUICtrlCreateLabel("Results:", 340, 80, 100, 20)
    $g_idLog = GUICtrlCreateEdit("", 340, 100, 600, 500, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL))
    GUICtrlSetFont($g_idLog, 9, 400, 0, "Consolas") ; Fixed-width font for the log

    ; Bottom buttons
    $g_idGetAllAgentsBtn = GUICtrlCreateButton("Get Agent Summary", 340, 610, 140, 30)
    $g_idGetLivingArrayBtn = GUICtrlCreateButton("Get All Living Agents", 490, 610, 140, 30)
    $g_idGetItemArrayBtn = GUICtrlCreateButton("Get All Item Agents", 640, 610, 140, 30)
    $g_idGetGadgetArrayBtn = GUICtrlCreateButton("Get All Gadget Agents", 790, 610, 140, 30)
    $g_idClear = GUICtrlCreateButton("Clear Log", 10, 610, 100, 30)
    $g_idExit = GUICtrlCreateButton("Exit", 120, 610, 90, 30)

    ; Populate the tree view with agent info options
    PopulateAgentInfoTree()

    ; Disable agent info controls until connected
    GUICtrlSetState($g_idInfoTree, $GUI_DISABLE)
    GUICtrlSetState($g_idAgentIDInput, $GUI_DISABLE)
    GUICtrlSetState($g_idEffectIndexInput, $GUI_DISABLE)
    GUICtrlSetState($g_idGetInfoBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idGetAllAgentsBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idGetLivingArrayBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idGetItemArrayBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idGetGadgetArrayBtn, $GUI_DISABLE)

    ; Display the interface
    GUISetState(@SW_SHOW, $g_hGUI)
EndFunc

; Populate the tree view with agent info options
Func PopulateAgentInfoTree()
    ; Main agent info categories
    Local $hBasicAgentInfo = GUICtrlCreateTreeViewItem("Basic Agent Information", $g_idInfoTree)
    Local $hAgentLivingInfo = GUICtrlCreateTreeViewItem("Agent Living Information", $g_idInfoTree)
    Local $hAgentItemInfo = GUICtrlCreateTreeViewItem("Agent Item Information", $g_idInfoTree)
    Local $hAgentGadgetInfo = GUICtrlCreateTreeViewItem("Agent Gadget Information", $g_idInfoTree)
    Local $hVisibleEffectsInfo = GUICtrlCreateTreeViewItem("Visible Effects Information", $g_idInfoTree)
    Local $hEquipmentInfo = GUICtrlCreateTreeViewItem("Equipment Information", $g_idInfoTree)
    Local $hTagInfo = GUICtrlCreateTreeViewItem("Tag Information", $g_idInfoTree)
    Local $hArrayInfo = GUICtrlCreateTreeViewItem("Agent Arrays", $g_idInfoTree)

    ; Basic agent info items
    GUICtrlCreateTreeViewItem("Agent ID", $hBasicAgentInfo)
    GUICtrlCreateTreeViewItem("Type", $hBasicAgentInfo)
    GUICtrlCreateTreeViewItem("Coordinates", $hBasicAgentInfo)
    GUICtrlCreateTreeViewItem("Rotation", $hBasicAgentInfo)
    GUICtrlCreateTreeViewItem("Rotation2", $hBasicAgentInfo)
    GUICtrlCreateTreeViewItem("Visual Effects", $hBasicAgentInfo)
    GUICtrlCreateTreeViewItem("Name Properties", $hBasicAgentInfo)
    GUICtrlCreateTreeViewItem("Ground", $hBasicAgentInfo)
    GUICtrlCreateTreeViewItem("Plane", $hBasicAgentInfo)
    GUICtrlCreateTreeViewItem("Name Tag Coordinates", $hBasicAgentInfo)
    GUICtrlCreateTreeViewItem("Movement Velocity", $hBasicAgentInfo)
    GUICtrlCreateTreeViewItem("Size1", $hBasicAgentInfo)
    GUICtrlCreateTreeViewItem("Size2", $hBasicAgentInfo)
    GUICtrlCreateTreeViewItem("Size3", $hBasicAgentInfo)
    GUICtrlCreateTreeViewItem("Terrain Normal Coords", $hBasicAgentInfo)
    GUICtrlCreateTreeViewItem("Timers", $hBasicAgentInfo)

    ; Agent living info items
    GUICtrlCreateTreeViewItem("Owner", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Primary Profession", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Secondary Profession", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Level", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Team ID", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Energy", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Energy Regen", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Max Energy", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("HP", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("HP Pips", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Max HP", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Model State", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Effects", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Hex", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Allegiance", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Model Type", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Transmog NPC ID", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Type Map", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("In Spirit Range", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Login Number", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Animation Speed", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Animation Type", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Animation Code", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Animation ID", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Dagger Status", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Weapon Type", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Weapon Attack Speed", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Attack Speed Modifier", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Skill", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Overcast", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Weapon Item Type", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Offhand Item Type", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Weapon Item ID", $hAgentLivingInfo)
    GUICtrlCreateTreeViewItem("Offhand Item ID", $hAgentLivingInfo)

    ; Agent item info items
    GUICtrlCreateTreeViewItem("Owner", $hAgentItemInfo)
    GUICtrlCreateTreeViewItem("Item ID", $hAgentItemInfo)
    GUICtrlCreateTreeViewItem("Extra Type", $hAgentItemInfo)

    ; Agent gadget info items
    GUICtrlCreateTreeViewItem("Gadget ID", $hAgentGadgetInfo)
    GUICtrlCreateTreeViewItem("Extra Type", $hAgentGadgetInfo)

    ; Visible effects info items
    GUICtrlCreateTreeViewItem("Count", $hVisibleEffectsInfo)
    GUICtrlCreateTreeViewItem("Effect ID", $hVisibleEffectsInfo)
    GUICtrlCreateTreeViewItem("Has Ended", $hVisibleEffectsInfo)

    ; Equipment info items
    GUICtrlCreateTreeViewItem("Weapon", $hEquipmentInfo)
    GUICtrlCreateTreeViewItem("Offhand", $hEquipmentInfo)
    GUICtrlCreateTreeViewItem("Chest", $hEquipmentInfo)
    GUICtrlCreateTreeViewItem("Legs", $hEquipmentInfo)
    GUICtrlCreateTreeViewItem("Head", $hEquipmentInfo)
    GUICtrlCreateTreeViewItem("Feet", $hEquipmentInfo)
    GUICtrlCreateTreeViewItem("Hands", $hEquipmentInfo)
    GUICtrlCreateTreeViewItem("Costume Body", $hEquipmentInfo)
    GUICtrlCreateTreeViewItem("Costume Head", $hEquipmentInfo)

    ; Tag info items
    GUICtrlCreateTreeViewItem("Guild ID", $hTagInfo)
    GUICtrlCreateTreeViewItem("Primary", $hTagInfo)
    GUICtrlCreateTreeViewItem("Secondary", $hTagInfo)
    GUICtrlCreateTreeViewItem("Level", $hTagInfo)

    ; Agent arrays items
    GUICtrlCreateTreeViewItem("Living Agents Count", $hArrayInfo)
    GUICtrlCreateTreeViewItem("Living Agents IDs", $hArrayInfo)
    GUICtrlCreateTreeViewItem("Living Agents All Info", $hArrayInfo)
    GUICtrlCreateTreeViewItem("Item Agents Count", $hArrayInfo)
    GUICtrlCreateTreeViewItem("Item Agents IDs", $hArrayInfo)
    GUICtrlCreateTreeViewItem("Item Agents All Info", $hArrayInfo)
    GUICtrlCreateTreeViewItem("Gadget Agents Count", $hArrayInfo)
    GUICtrlCreateTreeViewItem("Gadget Agents IDs", $hArrayInfo)
    GUICtrlCreateTreeViewItem("Gadget Agents All Info", $hArrayInfo)

    ; Expand all categories by default
    GUICtrlSetState($hBasicAgentInfo, $GUI_EXPAND)
    GUICtrlSetState($hAgentLivingInfo, $GUI_EXPAND)
    GUICtrlSetState($hAgentItemInfo, $GUI_EXPAND)
    GUICtrlSetState($hAgentGadgetInfo, $GUI_EXPAND)
    GUICtrlSetState($hVisibleEffectsInfo, $GUI_EXPAND)
    GUICtrlSetState($hEquipmentInfo, $GUI_EXPAND)
    GUICtrlSetState($hTagInfo, $GUI_EXPAND)
    GUICtrlSetState($hArrayInfo, $GUI_EXPAND)
EndFunc

; Add text to the log
Func LogWrite($text)
    GUICtrlSetData($g_idLog, GUICtrlRead($g_idLog) & $text & @CRLF)
EndFunc

; Clear the log
Func ClearLog()
    GUICtrlSetData($g_idLog, "")
EndFunc

; Connection function
Func ConnectToGwNexus()
    Local $charName = GUICtrlRead($g_idCharInput)

    If $charName = "" Then
        LogWrite("Error: Please enter a character name for connection.")
        Return False
    EndIf

    LogWrite("Attempting to connect with character: " & $charName)

    ; Initialize connection with the DLL
    Local $result = GwNexus_Initialize($charName)

    If @error Then
        LogWrite("Error: Unable to connect to GwNexus.")
        Return False
    Else
        LogWrite("Connection to GwNexus established successfully.")
        $g_bConnected = True

        ; Enable agent info controls
        GUICtrlSetState($g_idInfoTree, $GUI_ENABLE)
        GUICtrlSetState($g_idAgentIDInput, $GUI_ENABLE)
        GUICtrlSetState($g_idEffectIndexInput, $GUI_ENABLE)
        GUICtrlSetState($g_idGetInfoBtn, $GUI_ENABLE)
        GUICtrlSetState($g_idGetAllAgentsBtn, $GUI_ENABLE)
        GUICtrlSetState($g_idGetLivingArrayBtn, $GUI_ENABLE)
        GUICtrlSetState($g_idGetItemArrayBtn, $GUI_ENABLE)
        GUICtrlSetState($g_idGetGadgetArrayBtn, $GUI_ENABLE)

        ; Disable the connect button
        GUICtrlSetState($g_idConnectBtn, $GUI_DISABLE)
        ; Disable the input field
        GUICtrlSetState($g_idCharInput, $GUI_DISABLE)

        Return True
    EndIf
EndFunc

; Get agent information based on the selected item in the tree
Func GetSelectedAgentInfo()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $agentID = Number(GUICtrlRead($g_idAgentIDInput))
    If $agentID <= 0 Then
        LogWrite("Error: Please enter a valid agent ID.")
        Return
    EndIf

    Local $effectIndex = Number(GUICtrlRead($g_idEffectIndexInput))

    Local $selectedItem = GUICtrlRead($g_idInfoTree)
    If $selectedItem = 0 Then
        LogWrite("Error: Please select an information type from the tree.")
        Return
    EndIf

    Local $itemText = _GUICtrlTreeView_GetText($g_idInfoTree, $selectedItem)
    Local $parentHandle = _GUICtrlTreeView_GetParentHandle($g_idInfoTree, $selectedItem)
    Local $parentText = ""

    If $parentHandle Then
        $parentText = _GUICtrlTreeView_GetText($g_idInfoTree, $parentHandle)
    EndIf

    LogWrite("Retrieving agent information: " & $parentText & " > " & $itemText & " for Agent ID: " & $agentID)

    ; Process based on parent and selected item
    Switch $parentText
        Case "Basic Agent Information"
            GetBasicAgentInfo($agentID, $itemText)

        Case "Agent Living Information"
            GetAgentLivingInfo($agentID, $itemText)

        Case "Agent Item Information"
            GetAgentItemInfo($agentID, $itemText)

        Case "Agent Gadget Information"
            GetAgentGadgetInfo($agentID, $itemText)

        Case "Visible Effects Information"
            GetVisibleEffectsInfo($agentID, $effectIndex, $itemText)

        Case "Equipment Information"
            GetEquipmentInfo($agentID, $itemText)

        Case "Tag Information"
            GetTagInfo($agentID, $itemText)

        Case "Agent Arrays"
            GetAgentArrayInfo($itemText)

        Case Else
            LogWrite("Error: Unknown information category.")
    EndSwitch
EndFunc

; Functions to retrieve specific agent information
Func GetBasicAgentInfo($agentID, $itemText)
    Switch $itemText
        Case "Agent ID"
            Local $result = _Agent_AgentID($agentID)
            If @error Then
                LogWrite("Error retrieving agent ID.")
            Else
                LogWrite("Agent ID: " & $result)
            EndIf

        Case "Type"
            Local $result = _Agent_Type($agentID)
            If @error Then
                LogWrite("Error retrieving agent type.")
            Else
                LogWrite("Agent Type: " & $result)
            EndIf

        Case "Coordinates"
            Local $result = _Agent_Coords($agentID)
            If @error Then
                LogWrite("Error retrieving agent coordinates.")
            Else
                LogWrite("Agent Coordinates: X=" & $result[0] & ", Y=" & $result[1] & ", Z=" & $result[2])
            EndIf

        Case "Rotation"
            Local $result = _Agent_Rotation($agentID)
            If @error Then
                LogWrite("Error retrieving agent rotation.")
            Else
                LogWrite("Agent Rotation: Angle=" & $result[0] & ", Cos=" & $result[1] & ", Sin=" & $result[2])
            EndIf

        Case "Rotation2"
            Local $result = _Agent_Rotation2($agentID)
            If @error Then
                LogWrite("Error retrieving agent rotation2.")
            Else
                LogWrite("Agent Rotation2: Cos=" & $result[0] & ", Sin=" & $result[1])
            EndIf

        Case "Visual Effects"
            Local $result = _Agent_VisualEffects($agentID)
            If @error Then
                LogWrite("Error retrieving agent visual effects.")
            Else
                LogWrite("Agent Visual Effects: " & $result)
            EndIf

        Case "Name Properties"
            Local $result = _Agent_NameProperties($agentID)
            If @error Then
                LogWrite("Error retrieving agent name properties.")
            Else
                LogWrite("Agent Name Properties: " & $result)
            EndIf

        Case "Ground"
            Local $result = _Agent_Ground($agentID)
            If @error Then
                LogWrite("Error retrieving agent ground.")
            Else
                LogWrite("Agent Ground: " & $result)
            EndIf

        Case "Plane"
            Local $result = _Agent_Plane($agentID)
            If @error Then
                LogWrite("Error retrieving agent plane.")
            Else
                LogWrite("Agent Plane: " & $result)
            EndIf

        Case "Name Tag Coordinates"
            Local $result = _Agent_NameTagCoords($agentID)
            If @error Then
                LogWrite("Error retrieving agent name tag coordinates.")
            Else
                LogWrite("Agent Name Tag Coordinates: X=" & $result[0] & ", Y=" & $result[1] & ", Z=" & $result[2])
            EndIf

        Case "Movement Velocity"
            Local $result = _Agent_MoveVelocity($agentID)
            If @error Then
                LogWrite("Error retrieving agent movement velocity.")
            Else
                LogWrite("Agent Movement Velocity: X=" & $result[0] & ", Y=" & $result[1])
            EndIf

        Case "Size1"
            Local $result = _Agent_Size1($agentID)
            If @error Then
                LogWrite("Error retrieving agent size1.")
            Else
                LogWrite("Agent Size1: Width=" & $result[0] & ", Height=" & $result[1])
            EndIf

        Case "Size2"
            Local $result = _Agent_Size2($agentID)
            If @error Then
                LogWrite("Error retrieving agent size2.")
            Else
                LogWrite("Agent Size2: Width=" & $result[0] & ", Height=" & $result[1])
            EndIf

        Case "Size3"
            Local $result = _Agent_Size3($agentID)
            If @error Then
                LogWrite("Error retrieving agent size3.")
            Else
                LogWrite("Agent Size3: Width=" & $result[0] & ", Height=" & $result[1])
            EndIf

        Case "Terrain Normal Coords"
            Local $result = _Agent_TerrainNormalCoords($agentID)
            If @error Then
                LogWrite("Error retrieving agent terrain normal coordinates.")
            Else
                LogWrite("Agent Terrain Normal Coords: X=" & $result[0] & ", Y=" & $result[1] & ", Z=" & $result[2])
            EndIf

        Case "Timers"
            Local $result = _Agent_Timers($agentID)
            If @error Then
                LogWrite("Error retrieving agent timers.")
            Else
                LogWrite("Agent Timers: Timer1=" & $result[0] & ", Timer2=" & $result[1])
            EndIf
    EndSwitch
EndFunc

Func GetAgentLivingInfo($agentID, $itemText)
    Switch $itemText
        Case "Owner"
            Local $result = _AgentLiving_Owner($agentID)
            If @error Then
                LogWrite("Error retrieving agent owner.")
            Else
                LogWrite("Agent Owner: " & $result)
            EndIf

        Case "Primary Profession"
            Local $result = _AgentLiving_PrimaryProfession($agentID)
            If @error Then
                LogWrite("Error retrieving agent primary profession.")
            Else
                LogWrite("Agent Primary Profession: " & $result)
            EndIf

        Case "Secondary Profession"
            Local $result = _AgentLiving_SecondaryProfession($agentID)
            If @error Then
                LogWrite("Error retrieving agent secondary profession.")
            Else
                LogWrite("Agent Secondary Profession: " & $result)
            EndIf

        Case "Level"
            Local $result = _AgentLiving_Level($agentID)
            If @error Then
                LogWrite("Error retrieving agent level.")
            Else
                LogWrite("Agent Level: " & $result)
            EndIf

        Case "Team ID"
            Local $result = _AgentLiving_TeamID($agentID)
            If @error Then
                LogWrite("Error retrieving agent team ID.")
            Else
                LogWrite("Agent Team ID: " & $result)
            EndIf

        Case "Energy"
            Local $result = _AgentLiving_Energy($agentID)
            If @error Then
                LogWrite("Error retrieving agent energy.")
            Else
                LogWrite("Agent Energy: " & $result)
            EndIf

        Case "Energy Regen"
            Local $result = _AgentLiving_EnergyRegen($agentID)
            If @error Then
                LogWrite("Error retrieving agent energy regeneration.")
            Else
                LogWrite("Agent Energy Regeneration: " & $result)
            EndIf

        Case "Max Energy"
            Local $result = _AgentLiving_MaxEnergy($agentID)
            If @error Then
                LogWrite("Error retrieving agent max energy.")
            Else
                LogWrite("Agent Max Energy: " & $result)
            EndIf

        Case "HP"
            Local $result = _AgentLiving_HP($agentID)
            If @error Then
                LogWrite("Error retrieving agent HP.")
            Else
                LogWrite("Agent HP: " & $result)
            EndIf

        Case "HP Pips"
            Local $result = _AgentLiving_HPPips($agentID)
            If @error Then
                LogWrite("Error retrieving agent HP pips.")
            Else
                LogWrite("Agent HP Pips: " & $result)
            EndIf

        Case "Max HP"
            Local $result = _AgentLiving_MaxHP($agentID)
            If @error Then
                LogWrite("Error retrieving agent max HP.")
            Else
                LogWrite("Agent Max HP: " & $result)
            EndIf

        Case "Model State"
            Local $result = _AgentLiving_ModelState($agentID)
            If @error Then
                LogWrite("Error retrieving agent model state.")
            Else
                LogWrite("Agent Model State: " & $result)
            EndIf

        Case "Effects"
            Local $result = _AgentLiving_Effects($agentID)
            If @error Then
                LogWrite("Error retrieving agent effects.")
            Else
                LogWrite("Agent Effects: " & $result)
            EndIf

        Case "Hex"
            Local $result = _AgentLiving_Hex($agentID)
            If @error Then
                LogWrite("Error retrieving agent hex.")
            Else
                LogWrite("Agent Hex: " & $result)
            EndIf

        Case "Allegiance"
            Local $result = _AgentLiving_Allegiance($agentID)
            If @error Then
                LogWrite("Error retrieving agent allegiance.")
            Else
                LogWrite("Agent Allegiance: " & $result)
            EndIf

        Case "Model Type"
            Local $result = _AgentLiving_ModelType($agentID)
            If @error Then
                LogWrite("Error retrieving agent model type.")
            Else
                LogWrite("Agent Model Type: " & $result)
            EndIf

        Case "Transmog NPC ID"
            Local $result = _AgentLiving_TransmogNPCID($agentID)
            If @error Then
                LogWrite("Error retrieving agent transmog NPC ID.")
            Else
                LogWrite("Agent Transmog NPC ID: " & $result)
            EndIf

        Case "Type Map"
            Local $result = _AgentLiving_TypeMap($agentID)
            If @error Then
                LogWrite("Error retrieving agent type map.")
            Else
                LogWrite("Agent Type Map: " & $result)
            EndIf

        Case "In Spirit Range"
            Local $result = _AgentLiving_InSpiritRange($agentID)
            If @error Then
                LogWrite("Error retrieving agent in spirit range.")
            Else
                LogWrite("Agent In Spirit Range: " & $result)
            EndIf

        Case "Login Number"
            Local $result = _AgentLiving_LoginNumber($agentID)
            If @error Then
                LogWrite("Error retrieving agent login number.")
            Else
                LogWrite("Agent Login Number: " & $result)
            EndIf

        Case "Animation Speed"
            Local $result = _AgentLiving_AnimationSpeed($agentID)
            If @error Then
                LogWrite("Error retrieving agent animation speed.")
            Else
                LogWrite("Agent Animation Speed: " & $result)
            EndIf

        Case "Animation Type"
            Local $result = _AgentLiving_AnimationType($agentID)
            If @error Then
                LogWrite("Error retrieving agent animation type.")
            Else
                LogWrite("Agent Animation Type: " & $result)
            EndIf

        Case "Animation Code"
            Local $result = _AgentLiving_AnimationCode($agentID)
            If @error Then
                LogWrite("Error retrieving agent animation code.")
            Else
                LogWrite("Agent Animation Code: " & $result)
            EndIf

        Case "Animation ID"
            Local $result = _AgentLiving_AnimationID($agentID)
            If @error Then
                LogWrite("Error retrieving agent animation ID.")
            Else
                LogWrite("Agent Animation ID: " & $result)
            EndIf

        Case "Dagger Status"
            Local $result = _AgentLiving_DaggerStatus($agentID)
            If @error Then
                LogWrite("Error retrieving agent dagger status.")
            Else
                LogWrite("Agent Dagger Status: " & $result)
            EndIf

        Case "Weapon Type"
            Local $result = _AgentLiving_WeaponType($agentID)
            If @error Then
                LogWrite("Error retrieving agent weapon type.")
            Else
                LogWrite("Agent Weapon Type: " & $result)
            EndIf

        Case "Weapon Attack Speed"
            Local $result = _AgentLiving_WeaponAttackSpeed($agentID)
            If @error Then
                LogWrite("Error retrieving agent weapon attack speed.")
            Else
                LogWrite("Agent Weapon Attack Speed: " & $result)
            EndIf

        Case "Attack Speed Modifier"
            Local $result = _AgentLiving_AttackSpeedModifier($agentID)
            If @error Then
                LogWrite("Error retrieving agent attack speed modifier.")
            Else
                LogWrite("Agent Attack Speed Modifier: " & $result)
            EndIf

        Case "Skill"
            Local $result = _AgentLiving_Skill($agentID)
            If @error Then
                LogWrite("Error retrieving agent skill.")
            Else
                LogWrite("Agent Skill: " & $result)
            EndIf

		Case "Overcast"
            Local $result = _AgentLiving_Overcast($agentID)
            If @error Then
                LogWrite("Error retrieving agent overcast.")
            Else
                LogWrite("Agent Overcast: " & $result)
            EndIf

        Case "Weapon Item Type"
            Local $result = _AgentLiving_WeaponItemType($agentID)
            If @error Then
                LogWrite("Error retrieving agent weapon item type.")
            Else
                LogWrite("Agent Weapon Item Type: " & $result)
            EndIf

        Case "Offhand Item Type"
            Local $result = _AgentLiving_OffhandItemType($agentID)
            If @error Then
                LogWrite("Error retrieving agent offhand item type.")
            Else
                LogWrite("Agent Offhand Item Type: " & $result)
            EndIf

        Case "Weapon Item ID"
            Local $result = _AgentLiving_WeaponItemID($agentID)
            If @error Then
                LogWrite("Error retrieving agent weapon item ID.")
            Else
                LogWrite("Agent Weapon Item ID: " & $result)
            EndIf

        Case "Offhand Item ID"
            Local $result = _AgentLiving_OffhandItemID($agentID)
            If @error Then
                LogWrite("Error retrieving agent offhand item ID.")
            Else
                LogWrite("Agent Offhand Item ID: " & $result)
            EndIf
    EndSwitch
EndFunc

Func GetAgentItemInfo($agentID, $itemText)
    Switch $itemText
        Case "Owner"
            Local $result = _AgentItem_Owner($agentID)
            If @error Then
                LogWrite("Error retrieving item agent owner.")
            Else
                LogWrite("Item Agent Owner: " & $result)
            EndIf

        Case "Item ID"
            Local $result = _AgentItem_ItemID($agentID)
            If @error Then
                LogWrite("Error retrieving item agent item ID.")
            Else
                LogWrite("Item Agent Item ID: " & $result)
            EndIf

        Case "Extra Type"
            Local $result = _AgentItem_ExtraType($agentID)
            If @error Then
                LogWrite("Error retrieving item agent extra type.")
            Else
                LogWrite("Item Agent Extra Type: " & $result)
            EndIf
    EndSwitch
EndFunc

Func GetAgentGadgetInfo($agentID, $itemText)
    Switch $itemText
        Case "Gadget ID"
            Local $result = _AgentGadget_GadgetID($agentID)
            If @error Then
                LogWrite("Error retrieving gadget agent gadget ID.")
            Else
                LogWrite("Gadget Agent Gadget ID: " & $result)
            EndIf

        Case "Extra Type"
            Local $result = _AgentGadget_ExtraType($agentID)
            If @error Then
                LogWrite("Error retrieving gadget agent extra type.")
            Else
                LogWrite("Gadget Agent Extra Type: " & $result)
            EndIf
    EndSwitch
EndFunc

Func GetVisibleEffectsInfo($agentID, $effectIndex, $itemText)
    Switch $itemText
        Case "Count"
            Local $result = _AgentVisibleEffect_Count($agentID)
            If @error Then
                LogWrite("Error retrieving agent visible effects count.")
            Else
                LogWrite("Agent Visible Effects Count: " & $result)
            EndIf

        Case "Effect ID"
            Local $result = _AgentVisibleEffect_ID($agentID, $effectIndex)
            If @error Then
                LogWrite("Error retrieving agent visible effect ID at index " & $effectIndex & ".")
            Else
                LogWrite("Agent Visible Effect ID at index " & $effectIndex & ": " & $result)
            EndIf

        Case "Has Ended"
            Local $result = _AgentVisibleEffect_HasEnded($agentID, $effectIndex)
            If @error Then
                LogWrite("Error retrieving agent visible effect has ended status at index " & $effectIndex & ".")
            Else
                LogWrite("Agent Visible Effect at index " & $effectIndex & " Has Ended: " & $result)
            EndIf
    EndSwitch
EndFunc

Func GetEquipmentInfo($agentID, $itemText)
    Switch $itemText
        Case "Weapon"
            Local $result = _AgentEquipment_Weapon($agentID)
            If @error Then
                LogWrite("Error retrieving agent weapon equipment.")
            Else
                LogWrite("Agent Weapon Equipment: " & $result)
            EndIf

        Case "Offhand"
            Local $result = _AgentEquipment_Offhand($agentID)
            If @error Then
                LogWrite("Error retrieving agent offhand equipment.")
            Else
                LogWrite("Agent Offhand Equipment: " & $result)
            EndIf

        Case "Chest"
            Local $result = _AgentEquipment_Chest($agentID)
            If @error Then
                LogWrite("Error retrieving agent chest equipment.")
            Else
                LogWrite("Agent Chest Equipment: " & $result)
            EndIf

        Case "Legs"
            Local $result = _AgentEquipment_Legs($agentID)
            If @error Then
                LogWrite("Error retrieving agent legs equipment.")
            Else
                LogWrite("Agent Legs Equipment: " & $result)
            EndIf

        Case "Head"
            Local $result = _AgentEquipment_Head($agentID)
            If @error Then
                LogWrite("Error retrieving agent head equipment.")
            Else
                LogWrite("Agent Head Equipment: " & $result)
            EndIf

        Case "Feet"
            Local $result = _AgentEquipment_Feet($agentID)
            If @error Then
                LogWrite("Error retrieving agent feet equipment.")
            Else
                LogWrite("Agent Feet Equipment: " & $result)
            EndIf

        Case "Hands"
            Local $result = _AgentEquipment_Hands($agentID)
            If @error Then
                LogWrite("Error retrieving agent hands equipment.")
            Else
                LogWrite("Agent Hands Equipment: " & $result)
            EndIf

        Case "Costume Body"
            Local $result = _AgentEquipment_CostumeBody($agentID)
            If @error Then
                LogWrite("Error retrieving agent costume body equipment.")
            Else
                LogWrite("Agent Costume Body Equipment: " & $result)
            EndIf

        Case "Costume Head"
            Local $result = _AgentEquipment_CostumeHead($agentID)
            If @error Then
                LogWrite("Error retrieving agent costume head equipment.")
            Else
                LogWrite("Agent Costume Head Equipment: " & $result)
            EndIf
    EndSwitch
EndFunc

Func GetTagInfo($agentID, $itemText)
    Switch $itemText
        Case "Guild ID"
            Local $result = _AgentTag_GuildID($agentID)
            If @error Then
                LogWrite("Error retrieving agent guild ID.")
            Else
                LogWrite("Agent Guild ID: " & $result)
            EndIf

        Case "Primary"
            Local $result = _AgentTag_Primary($agentID)
            If @error Then
                LogWrite("Error retrieving agent primary tag.")
            Else
                LogWrite("Agent Primary Tag: " & $result)
            EndIf

        Case "Secondary"
            Local $result = _AgentTag_Secondary($agentID)
            If @error Then
                LogWrite("Error retrieving agent secondary tag.")
            Else
                LogWrite("Agent Secondary Tag: " & $result)
            EndIf

        Case "Level"
            Local $result = _AgentTag_Level($agentID)
            If @error Then
                LogWrite("Error retrieving agent tag level.")
            Else
                LogWrite("Agent Tag Level: " & $result)
            EndIf
    EndSwitch
EndFunc

Func GetAgentArrayInfo($itemText)
    Switch $itemText
        Case "Living Agents Count"
            Local $result = _AgentLivingArray_Count()
            If @error Then
                LogWrite("Error retrieving living agents count.")
            Else
                LogWrite("Living Agents Count: " & $result)
            EndIf

        Case "Living Agents IDs"
            Local $result = _AgentLivingArray_AllIDs()
            If @error Then
                LogWrite("Error retrieving living agents IDs.")
            Else
                LogWrite("Living Agents IDs (total: " & UBound($result) & "):")
                Local $maxDisplay = _Min(UBound($result), 10)
                For $i = 0 To $maxDisplay - 1
                    LogWrite("  Agent " & $i & ": ID=" & $result[$i])
                Next
                If UBound($result) > 10 Then
                    LogWrite("  ... and " & (UBound($result) - 10) & " more")
                EndIf
            EndIf

		Case "Living Agents All Info"
			LogWrite("Retrieving all living agents info (this may take some time)...")
			Local $result = _AgentLivingArray_AllInfo()
			If @error Then
				LogWrite("Error retrieving living agents all info.")
			Else
				LogWrite("Living Agents All Info retrieved successfully.")
				LogWrite("Total Living Agents: " & $result[0][0])

				Local $displayCount = _Min($result[0][0], 3)

				LogWrite("Displaying details for " & $displayCount & " agents:")
				For $i = 1 To $displayCount
					LogWrite("--- Agent " & $i & " ---")
					LogWrite("  ID: " & $result[$i][0])
					LogWrite("  Position: X=" & $result[$i][3] & ", Y=" & $result[$i][4] & ", Z=" & $result[$i][5])
					LogWrite("  Type: " & $result[$i][18])

					If $result[$i][32] > 0 Then
						LogWrite("  Level: " & $result[$i][32])
						LogWrite("  Profession: Primary=" & $result[$i][30] & ", Secondary=" & $result[$i][31])
						LogWrite("  HP: " & Round($result[$i][39], 1) & "/" & $result[$i][40])
						LogWrite("  Energy: " & Round($result[$i][36], 1) & "/" & $result[$i][37])

						Local $effectCount = $result[$i][68]
						If $effectCount > 0 Then
							Local $maxEffects = _Min($effectCount, 3)
							LogWrite("  Visible Effects (" & $effectCount & " total, showing first " & $maxEffects & "):")
							For $j = 0 To $maxEffects - 1
								LogWrite("    Effect " & $j & ": ID=" & $result[$i][71 + ($j * 3)] & ", Has Ended=" & $result[$i][72 + ($j * 3)])
							Next
						Else
							LogWrite("  No visible effects")
						EndIf
					Else
						LogWrite("  Basic entity without level")
					EndIf

					LogWrite("")
				Next
			EndIf

        Case "Item Agents Count"
            Local $result = _AgentItemArray_Count()
            If @error Then
                LogWrite("Error retrieving item agents count.")
            Else
                LogWrite("Item Agents Count: " & $result)
            EndIf

        Case "Item Agents IDs"
            Local $result = _AgentItemArray_AllIDs()
            If @error Then
                LogWrite("Error retrieving item agents IDs.")
            Else
                LogWrite("Item Agents IDs (total: " & UBound($result) & "):")
                Local $maxDisplay = _Min(UBound($result), 10)
                For $i = 0 To $maxDisplay - 1
                    LogWrite("  Agent " & $i & ": ID=" & $result[$i])
                Next
                If UBound($result) > 10 Then
                    LogWrite("  ... and " & (UBound($result) - 10) & " more")
                EndIf
            EndIf

        Case "Item Agents All Info"
			LogWrite("Retrieving all item agents info...")
			Local $result = _AgentItemArray_AllInfo()
			If @error Then
				LogWrite("Error retrieving item agents all info.")
			Else
				LogWrite("Item Agents All Info retrieved successfully.")
				LogWrite("Total Item Agents: " & $result[0][0])
				LogWrite("First item details:")
				If $result[0][0] > 0 Then
					LogWrite("  ID: " & $result[1][0])
					LogWrite("  Position: X=" & $result[1][3] & ", Y=" & $result[1][4] & ", Z=" & $result[1][5])
					LogWrite("  Item ID: " & $result[1][14])
					LogWrite("  Owner: " & $result[1][13])
					LogWrite("  Extra Type: " & $result[1][15])
				EndIf
			EndIf

        Case "Gadget Agents Count"
            Local $result = _AgentGadgetArray_Count()
            If @error Then
                LogWrite("Error retrieving gadget agents count.")
            Else
                LogWrite("Gadget Agents Count: " & $result)
            EndIf

        Case "Gadget Agents IDs"
            Local $result = _AgentGadgetArray_AllIDs()
            If @error Then
                LogWrite("Error retrieving gadget agents IDs.")
            Else
                LogWrite("Gadget Agents IDs (total: " & UBound($result) & "):")
                Local $maxDisplay = _Min(UBound($result), 10)
                For $i = 0 To $maxDisplay - 1
                    LogWrite("  Agent " & $i & ": ID=" & $result[$i])
                Next
                If UBound($result) > 10 Then
                    LogWrite("  ... and " & (UBound($result) - 10) & " more")
                EndIf
            EndIf

		Case "Gadget Agents All Info"
			LogWrite("Retrieving all gadget agents info...")
			Local $result = _AgentGadgetArray_AllInfo()
			If @error Then
				LogWrite("Error retrieving gadget agents all info.")
			Else
				LogWrite("Gadget Agents All Info retrieved successfully.")
				LogWrite("Total Gadget Agents: " & $result[0][0])
				LogWrite("First gadget details:")
				If $result[0][0] > 0 Then
					LogWrite("  ID: " & $result[1][0])
					LogWrite("  Position: X=" & $result[1][1] & ", Y=" & $result[1][2] & ", Z=" & $result[1][3])
					LogWrite("  Gadget ID: " & $result[1][12])
					LogWrite("  Extra Type: " & $result[1][11])
					LogWrite("  Type: " & $result[1][10])
				EndIf
			EndIf
    EndSwitch
EndFunc

; Function to get all living agents
Func GetAllLivingAgentsInfo()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    LogWrite("Retrieving all living agents...")
    Local $startTime = TimerInit()

    Local $agentCount = _AgentLivingArray_Count()
    If @error Then
        LogWrite("Error retrieving living agents count.")
        Return
    EndIf

    LogWrite("Found " & $agentCount & " living agents.")

    Local $agents = _AgentLivingArray_AllInfo()
    If @error Then
        LogWrite("Error retrieving living agents information.")
        Return
    EndIf

    LogWrite("Agent information retrieved. Displaying first 15 agents with details:")

    Local $displayCount = _Min(15, $agents[0][0])
    For $i = 1 To $displayCount
        Local $id = $agents[$i][0]  ; agent_id
        Local $type = $agents[$i][18]  ; type

        ; Get position
        Local $posStr = "X=" & Round($agents[$i][3], 1) & ", Y=" & Round($agents[$i][4], 1) & ", Z=" & Round($agents[$i][5], 1)

        ; Get basic info based on agent type
        Local $infoStr = ""
        If $agents[$i][32] > 0 Then  ; level
            Local $level = $agents[$i][32]  ; level
            Local $hp = $agents[$i][39]  ; hp
            Local $maxHp = $agents[$i][40]  ; max_hp
            Local $prof = $agents[$i][30]  ; primary

            $infoStr = "Level=" & $level & ", Prof=" & $prof & ", HP=" & Round($hp, 1) & "/" & $maxHp
        ElseIf $type == 1 Then  ; If it's a player or NPC
            $infoStr = "Type=Character"
        EndIf

        LogWrite("Agent " & $i & ": ID=" & $id & ", " & $posStr & ", " & $infoStr)
    Next

    Local $elapsedTime = TimerDiff($startTime)
    LogWrite("Retrieved in " & Round($elapsedTime / 1000, 2) & " seconds.")
EndFunc

; Function to get all item agents
Func GetAllItemAgentsInfo()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    LogWrite("Retrieving all item agents...")
    Local $startTime = TimerInit()

    Local $agentCount = _AgentItemArray_Count()
    If @error Then
        LogWrite("Error retrieving item agents count.")
        Return
    EndIf

    LogWrite("Found " & $agentCount & " item agents.")

    Local $agents = _AgentItemArray_AllInfo()
    If @error Then
        LogWrite("Error retrieving item agents information.")
        Return
    EndIf

    LogWrite("Agent information retrieved. Displaying first 15 items with details:")

    Local $displayCount = _Min(15, $agents[0][0])
    For $i = 1 To $displayCount
        Local $id = $agents[$i][0]  ; agent_id

        ; Get position
        Local $posStr = "X=" & Round($agents[$i][3], 1) & ", Y=" & Round($agents[$i][4], 1) & ", Z=" & Round($agents[$i][5], 1)

        ; Get item-specific info
        Local $itemId = $agents[$i][14]  ; item_id
        Local $owner = $agents[$i][13]  ; owner
        Local $extraType = $agents[$i][15]  ; extra_type

        LogWrite("Item " & $i & ": ID=" & $id & ", ItemID=" & $itemId & ", Owner=" & $owner & ", ExtraType=" & $extraType & ", " & $posStr)
    Next

    Local $elapsedTime = TimerDiff($startTime)
    LogWrite("Retrieved in " & Round($elapsedTime / 1000, 2) & " seconds.")
EndFunc

; Function to get all gadget agents
Func GetAllGadgetAgentsInfo()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    LogWrite("Retrieving all gadget agents...")
    Local $startTime = TimerInit()

    Local $agentCount = _AgentGadgetArray_Count()
    If @error Then
        LogWrite("Error retrieving gadget agents count.")
        Return
    EndIf

    LogWrite("Found " & $agentCount & " gadget agents.")

    Local $agents = _AgentGadgetArray_AllInfo()
    If @error Then
        LogWrite("Error retrieving gadget agents information.")
        Return
    EndIf

    LogWrite("Agent information retrieved. Displaying first 15 gadgets with details:")

    Local $displayCount = _Min(15, $agents[0][0])
    For $i = 1 To $displayCount
        Local $id = $agents[$i][0]  ; agent_id

        ; Get position
        Local $posStr = "X=" & Round($agents[$i][1], 1) & ", Y=" & Round($agents[$i][2], 1) & ", Z=" & Round($agents[$i][3], 1)

        ; Get gadget-specific info
        Local $gadgetId = $agents[$i][12]  ; gadget_id
        Local $extraType = $agents[$i][11]  ; extra_type
        Local $type = $agents[$i][10]  ; type

        LogWrite("Gadget " & $i & ": ID=" & $id & ", GadgetID=" & $gadgetId & ", ExtraType=" & $extraType & ", Type=" & $type & ", " & $posStr)
    Next

    Local $elapsedTime = TimerDiff($startTime)
    LogWrite("Retrieved in " & Round($elapsedTime / 1000, 2) & " seconds.")
EndFunc

; Function to get agent information summary
Func GetAgentSummary()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    ; Get player agent ID first
    Local $playerID = _GetPlayerAgentID()
    If @error Or $playerID = 0 Then
        LogWrite("Error retrieving player agent ID.")
        Return
    EndIf

    LogWrite("================= AGENT INFORMATION SUMMARY =================")

    ; Player info
    LogWrite("PLAYER INFO (ID: " & $playerID & "):")

    Local $coords = _Agent_Coords($playerID)
    If Not @error Then
        LogWrite("  Coordinates: X=" & Round($coords[0], 1) & ", Y=" & Round($coords[1], 1) & ", Z=" & Round($coords[2], 1))
    EndIf

    Local $level = _AgentLiving_Level($playerID)
    Local $primaryProf = _AgentLiving_PrimaryProfession($playerID)
    Local $secondaryProf = _AgentLiving_SecondaryProfession($playerID)
    If Not @error Then
        LogWrite("  Level: " & $level & ", Professions: " & $primaryProf & "/" & $secondaryProf)
    EndIf

    Local $hp = _AgentLiving_HP($playerID)
    Local $maxHp = _AgentLiving_MaxHP($playerID)
    Local $energy = _AgentLiving_Energy($playerID)
    Local $maxEnergy = _AgentLiving_MaxEnergy($playerID)
    If Not @error Then
        LogWrite("  HP: " & Round($hp, 1) & "/" & $maxHp & ", Energy: " & Round($energy, 1) & "/" & $maxEnergy)
    EndIf

    ; Agent counts
    Local $livingCount = _AgentLivingArray_Count()
    Local $itemCount = _AgentItemArray_Count()
    Local $gadgetCount = _AgentGadgetArray_Count()

    LogWrite("")
    LogWrite("AGENT COUNTS:")
    LogWrite("  Living Agents: " & $livingCount)
    LogWrite("  Item Agents: " & $itemCount)
    LogWrite("  Gadget Agents: " & $gadgetCount)

    ; Get visible effects on player
    Local $effectCount = _AgentVisibleEffect_Count($playerID)
    If Not @error And $effectCount > 0 Then
        LogWrite("")
        LogWrite("PLAYER VISIBLE EFFECTS:")

        Local $limit = _Min(10, $effectCount)
        For $i = 0 To $limit - 1
            Local $effectID = _AgentVisibleEffect_ID($playerID, $i)
            Local $hasEnded = _AgentVisibleEffect_HasEnded($playerID, $i)

            If Not @error Then
                LogWrite("  Effect " & $i & ": ID=" & $effectID & ", Has Ended=" & $hasEnded)
            EndIf
        Next
    EndIf

    ; Equipment info
    LogWrite("")
    LogWrite("PLAYER EQUIPMENT:")
    LogWrite("  Weapon: " & _AgentEquipment_Weapon($playerID))
    LogWrite("  Offhand: " & _AgentEquipment_Offhand($playerID))
    LogWrite("  Chest: " & _AgentEquipment_Chest($playerID))
    LogWrite("  Legs: " & _AgentEquipment_Legs($playerID))
    LogWrite("  Head: " & _AgentEquipment_Head($playerID))
    LogWrite("  Feet: " & _AgentEquipment_Feet($playerID))
    LogWrite("  Hands: " & _AgentEquipment_Hands($playerID))

    LogWrite("================ END OF AGENT INFORMATION ================")
EndFunc

; Helper function to get the player agent ID
Func _GetPlayerAgentID()
    Local $result = _Character_PlayerAgentID()
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Main function
Func Main()
    ; Create the interface
    CreateInterface()

    LogWrite("Welcome to the Agent Info Explorer!")
    LogWrite("Please enter the character name and click 'Connect'.")

    ; Event handling loop
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $g_idExit
                ExitLoop

            Case $g_idConnectBtn
                ConnectToGwNexus()

            Case $g_idGetInfoBtn
                GetSelectedAgentInfo()

            Case $g_idGetAllAgentsBtn
                GetAgentSummary()

            Case $g_idGetLivingArrayBtn
                GetAllLivingAgentsInfo()

            Case $g_idGetItemArrayBtn
                GetAllItemAgentsInfo()

            Case $g_idGetGadgetArrayBtn
                GetAllGadgetAgentsInfo()

            Case $g_idClear
                ClearLog()
        EndSwitch
    WEnd

    ; Clean up shared memory before terminating
    If $g_bConnected Then
        GwNexus_Cleanup()
    EndIf

    ; Close the interface
    GUIDelete($g_hGUI)
EndFunc

; Launch the application
Main()