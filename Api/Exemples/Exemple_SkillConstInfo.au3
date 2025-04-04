#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include "../Base.au3"
#include "../Queries/SkillConstInfo.au3"

; Global variables
Global $g_hGUI, $g_idCharInput, $g_idConnectBtn, $g_idSkillIDInput, $g_idInfoTypeCombo
Global $g_idGetInfoBtn, $g_idLog, $g_idRefresh, $g_idClear, $g_idExit
Global $g_bConnected = False

; Create user interface
Func CreateInterface()
    $g_hGUI = GUICreate("GwNexus - Skill Info Explorer", 700, 600)

    ; Connection section
    GUICtrlCreateGroup("Connection", 10, 10, 680, 60)
    GUICtrlCreateLabel("Character name for GwNexus_Initialize:", 20, 30, 250, 20)
    $g_idCharInput = GUICtrlCreateInput("", 270, 30, 300, 20)
    $g_idConnectBtn = GUICtrlCreateButton("Connect", 580, 30, 100, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Skill info query section
    GUICtrlCreateGroup("Skill Information", 10, 80, 680, 90)
    GUICtrlCreateLabel("Skill ID:", 20, 100, 80, 20)
    $g_idSkillIDInput = GUICtrlCreateInput("1", 100, 100, 80, 20)

    GUICtrlCreateLabel("Information Type:", 200, 100, 100, 20)
    $g_idInfoTypeCombo = GUICtrlCreateCombo("", 300, 100, 250, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))

    $g_idGetInfoBtn = GUICtrlCreateButton("Get Info", 560, 100, 120, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Results section
    GUICtrlCreateLabel("Results:", 10, 180, 100, 20)
    $g_idLog = GUICtrlCreateEdit("", 10, 200, 680, 350, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL))
    GUICtrlSetFont($g_idLog, 9, 400, 0, "Consolas") ; Fixed-width font for the log

    ; Bottom buttons
    $g_idClear = GUICtrlCreateButton("Clear Log", 490, 560, 100, 30)
    $g_idExit = GUICtrlCreateButton("Exit", 600, 560, 90, 30)

    ; Populate the combo box with info types
    PopulateInfoTypeCombo()

    ; Disable skill info controls until connected
    GUICtrlSetState($g_idSkillIDInput, $GUI_DISABLE)
    GUICtrlSetState($g_idInfoTypeCombo, $GUI_DISABLE)
    GUICtrlSetState($g_idGetInfoBtn, $GUI_DISABLE)

    ; Display the interface
    GUISetState(@SW_SHOW, $g_hGUI)
EndFunc

; Populate the combo box with skill info types
Func PopulateInfoTypeCombo()
    Local $aInfoTypes[43][2] = [ _
        [0, "Skill ID"], _
        [1, "Unknown0004"], _
        [2, "Campaign"], _
        [3, "Skill Type"], _
        [4, "Special"], _
        [5, "Combo Requirement"], _
        [6, "Effect 1"], _
        [7, "Condition"], _
        [8, "Effect 2"], _
        [9, "Weapon Requirement"], _
        [10, "Profession"], _
        [11, "Attribute"], _
        [12, "Title"], _
        [13, "Combo"], _
        [14, "Target"], _
        [15, "Unknown0032"], _
        [16, "Skill Equip Type"], _
        [17, "Overcast"], _
        [18, "Energy Cost"], _
        [19, "Health Cost"], _
        [20, "Unknown0037"], _
        [21, "Adrenaline"], _
        [22, "Activation"], _
        [23, "Aftercast"], _
        [24, "Duration"], _
        [25, "Recharge"], _
        [26, "Unknown0050"], _
        [27, "Skill Arguments"], _
        [28, "Scale"], _
        [29, "Bonus Scale"], _
        [30, "AoE Range"], _
        [31, "Const Effect"], _
        [32, "Caster Animation"], _
        [33, "Target Animation"], _
        [34, "Projectile Animation"], _
        [35, "Icon File ID"], _
        [36, "Name (ID)"], _
        [37, "Concise (ID)"], _
        [38, "Description (ID)"], _
        [39, "Name Text"], _
        [40, "Description Text"], _
        [41, "Concise Text"], _
        [42, "All Properties"]]

    For $i = 0 To UBound($aInfoTypes) - 1
        GUICtrlSetData($g_idInfoTypeCombo, $aInfoTypes[$i][1])
    Next

    ; Set default selection
    GUICtrlSetData($g_idInfoTypeCombo, "All Properties")
EndFunc

; Get the info type value from the combo box text
Func GetInfoTypeFromCombo()
    Local $sComboText = GUICtrlRead($g_idInfoTypeCombo)

    Local $aInfoTypes[43][2] = [ _
        [0, "Skill ID"], _
        [1, "Unknown0004"], _
        [2, "Campaign"], _
        [3, "Skill Type"], _
        [4, "Special"], _
        [5, "Combo Requirement"], _
        [6, "Effect 1"], _
        [7, "Condition"], _
        [8, "Effect 2"], _
        [9, "Weapon Requirement"], _
        [10, "Profession"], _
        [11, "Attribute"], _
        [12, "Title"], _
        [13, "Combo"], _
        [14, "Target"], _
        [15, "Unknown0032"], _
        [16, "Skill Equip Type"], _
        [17, "Overcast"], _
        [18, "Energy Cost"], _
        [19, "Health Cost"], _
        [20, "Unknown0037"], _
        [21, "Adrenaline"], _
        [22, "Activation"], _
        [23, "Aftercast"], _
        [24, "Duration"], _
        [25, "Recharge"], _
        [26, "Unknown0050"], _
        [27, "Skill Arguments"], _
        [28, "Scale"], _
        [29, "Bonus Scale"], _
        [30, "AoE Range"], _
        [31, "Const Effect"], _
        [32, "Caster Animation"], _
        [33, "Target Animation"], _
        [34, "Projectile Animation"], _
        [35, "Icon File ID"], _
        [36, "Name (ID)"], _
        [37, "Concise (ID)"], _
        [38, "Description (ID)"], _
        [39, "Name Text"], _
        [40, "Description Text"], _
        [41, "Concise Text"], _
        [42, "All Properties"]]

    For $i = 0 To UBound($aInfoTypes) - 1
        If $sComboText = $aInfoTypes[$i][1] Then
            Return $aInfoTypes[$i][0]
        EndIf
    Next

    Return 42 ; Default to All Properties
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
    GwNexus_Initialize($charName)

    If @error Then
        LogWrite("Error: Unable to connect to GwNexus.")
        Return False
    Else
        LogWrite("Connection to GwNexus established successfully." & @CRLF)
        $g_bConnected = True

        ; Enable skill info controls
        GUICtrlSetState($g_idSkillIDInput, $GUI_ENABLE)
        GUICtrlSetState($g_idInfoTypeCombo, $GUI_ENABLE)
        GUICtrlSetState($g_idGetInfoBtn, $GUI_ENABLE)

        ; Disable the connect button
        GUICtrlSetState($g_idConnectBtn, $GUI_DISABLE)
        ; Disable the input field
        GUICtrlSetState($g_idCharInput, $GUI_DISABLE)

        Return True
    EndIf
EndFunc

; Get skill information
Func GetSkillConstInfoAndDisplay()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $skillID = Number(GUICtrlRead($g_idSkillIDInput))
    If $skillID <= 0 Then
        LogWrite("Error: Please enter a valid skill ID.")
        Return
    EndIf

    Local $infoType = GetInfoTypeFromCombo()
    LogWrite("Retrieving skill information for Skill ID: " & $skillID & ", Info Type: " & GUICtrlRead($g_idInfoTypeCombo))

    Local $result = _Nexus_SkillConstInfo($skillID, $infoType)
    If @error Then
        LogWrite("Error: Failed to retrieve skill information.")
        Return
    EndIf

    ; Display the result based on the info type
    Switch $infoType
        Case $SKILL_INFO_ACTIVATION, $SKILL_INFO_AFTERCAST, $SKILL_INFO_AOE_RANGE, $SKILL_INFO_CONST_EFFECT
            LogWrite("Result (float): " & $result)

        Case $SKILL_INFO_NAME_TEXT, $SKILL_INFO_DESCRIPTION_TEXT, $SKILL_INFO_CONCISE_TEXT
            LogWrite("Result (string): " & $result)

        Case $SKILL_INFO_SKILLID, $SKILL_INFO_DURATION, $SKILL_INFO_SCALE, _
             $SKILL_INFO_BONUS_SCALE, $SKILL_INFO_CASTER_ANIMATION, _
             $SKILL_INFO_TARGET_ANIMATION, $SKILL_INFO_PROJECTILE_ANIMATION, _
             $SKILL_INFO_ICON_FILE_ID
            LogWrite("Result (array): [" & $result[0] & ", " & $result[1] & "]")

        Case $SKILL_INFO_UNKNOWN0050
            LogWrite("Result (array): [" & $result[0] & ", " & $result[1] & ", " & $result[2] & ", " & $result[3] & "]")

        Case $SKILL_INFO_ALL_PROPERTIES
            LogWrite("All Skill Properties:")
			LogWrite("  " & "skill_id: " & $result[0])
			LogWrite("  " & "campaign: " & $result[1])
			LogWrite("  " & "type: " & $result[2])
			LogWrite("  " & "special: " & $result[3])
			LogWrite("  " & "combo_req: " & $result[4])
			LogWrite("  " & "effect1: " & $result[5])
			LogWrite("  " & "condition: " & $result[6])
			LogWrite("  " & "effect2: " & $result[7])
			LogWrite("  " & "weapon_req: " & $result[8])
			LogWrite("  " & "profession: " & $result[9])
			LogWrite("  " & "attribute: " & $result[10])
			LogWrite("  " & "title: " & $result[11])
			LogWrite("  " & "combo: " & $result[12])
			LogWrite("  " & "target: " & $result[13])
			LogWrite("  " & "skill_equip_type: " & $result[14])
			LogWrite("  " & "overcast: " & $result[15])
			LogWrite("  " & "GetEnergyCost(: " & $result[16])
			LogWrite("  " & "health_cost: " & $result[17])
			LogWrite("  " & "adrenaline: " & $result[18])
			LogWrite("  " & "activation: " & $result[19])
			LogWrite("  " & "aftercast: " & $result[20])
			LogWrite("  " & "duration0: " & $result[21])
			LogWrite("  " & "duration15: " & $result[22])
			LogWrite("  " & "recharge: " & $result[23])
			LogWrite("  " & "skill_arguments: " & $result[24])
			LogWrite("  " & "scale0: " & $result[25])
			LogWrite("  " & "scale15: " & $result[26])
			LogWrite("  " & "bonusScale0: " & $result[27])
			LogWrite("  " & "bonusScale15: " & $result[28])
			LogWrite("  " & "aoe_range: " & $result[29])
			LogWrite("  " & "const_effect: " & $result[30])
			LogWrite("  " & "Skill Name: " & $result[31])
			LogWrite("  " & "Skill concise description: " & $result[32])
			LogWrite("  " & "Skill description: " & $result[33])

        Case Else
            LogWrite("Result (int): " & $result)
    EndSwitch
EndFunc

; Main function
Func Main()
    ; Create the interface
    CreateInterface()

    LogWrite("Welcome to the Skill Info Explorer!")
    LogWrite("Please enter the character name and click 'Connect'.")

    ; Event handling loop
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $g_idExit
                ExitLoop

            Case $g_idConnectBtn
                ConnectToGwNexus()

            Case $g_idGetInfoBtn
                GetSkillConstInfoAndDisplay()

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