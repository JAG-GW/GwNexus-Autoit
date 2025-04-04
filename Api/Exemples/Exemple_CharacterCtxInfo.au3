#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GuiTreeView.au3>
#include "../Base.au3"
#include "../Queries/CharacterCtxInfo.au3"

; Global variables
Global $g_hGUI, $g_idCharInput, $g_idConnectBtn, $g_idCategoryCombo
Global $g_idCharInfoCombo, $g_idMatchInfoCombo, $g_idGetInfoBtn, $g_idLog, $g_idClear, $g_idExit
Global $g_bConnected = False

; Create user interface
Func CreateInterface()
    $g_hGUI = GUICreate("GwNexus - Character Info Explorer", 700, 550)

    ; Connection section
    GUICtrlCreateGroup("Connection", 10, 10, 680, 60)
    GUICtrlCreateLabel("Character name for GwNexus_Initialize:", 20, 30, 250, 20)
    $g_idCharInput = GUICtrlCreateInput("", 270, 30, 300, 20)
    $g_idConnectBtn = GUICtrlCreateButton("Connect", 580, 30, 100, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Category selection
    GUICtrlCreateGroup("Information Category", 10, 80, 680, 60)
    GUICtrlCreateLabel("Select Category:", 20, 100, 100, 20)
    $g_idCategoryCombo = GUICtrlCreateCombo("", 130, 100, 200, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
    GUICtrlSetData($g_idCategoryCombo, "Character Information|Observer Match Information")
    GUICtrlSetData($g_idCategoryCombo, "Character Information") ; Default selection
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Character info query section
    GUICtrlCreateGroup("Character Information", 10, 150, 680, 60)
    GUICtrlCreateLabel("Information Type:", 20, 170, 100, 20)
    $g_idCharInfoCombo = GUICtrlCreateCombo("", 130, 170, 430, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Match info query section
    GUICtrlCreateGroup("Observer Match Information", 10, 220, 680, 60)
    GUICtrlCreateLabel("Information Type:", 20, 240, 100, 20)
    $g_idMatchInfoCombo = GUICtrlCreateCombo("", 130, 240, 430, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Action button
    $g_idGetInfoBtn = GUICtrlCreateButton("Get Information", 580, 240, 100, 30)

    ; Results section
    GUICtrlCreateLabel("Results:", 10, 290, 100, 20)
    $g_idLog = GUICtrlCreateEdit("", 10, 310, 680, 190, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL))
    GUICtrlSetFont($g_idLog, 9, 400, 0, "Consolas") ; Fixed-width font for the log

    ; Bottom buttons
    $g_idClear = GUICtrlCreateButton("Clear Log", 490, 510, 100, 30)
    $g_idExit = GUICtrlCreateButton("Exit", 600, 510, 90, 30)

    ; Populate the combo boxes with info types
    PopulateCharInfoCombo()
    PopulateMatchInfoCombo()

    ; Disable info controls until connected
    GUICtrlSetState($g_idCategoryCombo, $GUI_DISABLE)
    GUICtrlSetState($g_idCharInfoCombo, $GUI_DISABLE)
    GUICtrlSetState($g_idMatchInfoCombo, $GUI_DISABLE)
    GUICtrlSetState($g_idGetInfoBtn, $GUI_DISABLE)

    ; Initially hide match info section
    GUICtrlSetState($g_idMatchInfoCombo, $GUI_HIDE)

    ; Display the interface
    GUISetState(@SW_SHOW, $g_hGUI)
EndFunc

; Populate the character info combo box
Func PopulateCharInfoCombo()
    Local $aCharInfoTypes[18] = [ _
        "Player Agent ID", _
        "Player Name", _
        "Player UUID", _
        "World Flags", _
        "Token 1", _
        "Map ID", _
        "Is Explorable", _
        "Token 2", _
        "District Number", _
        "Language", _
        "Observe Map ID", _
        "Current Map ID", _
        "Observe Map Type", _
        "Current Map Type", _
        "Player Flags", _
        "Player Number", _
        "Player Email", _
        "All Information"]

    For $i = 0 To UBound($aCharInfoTypes) - 1
        GUICtrlSetData($g_idCharInfoCombo, $aCharInfoTypes[$i])
    Next

    GUICtrlSetData($g_idCharInfoCombo, "All Information") ; Default selection
EndFunc

; Populate the match info combo box
Func PopulateMatchInfoCombo()
    Local $aMatchInfoTypes[3] = [ _
        "Match Count", _
        "Match By Index", _
        "All Matches"]

    For $i = 0 To UBound($aMatchInfoTypes) - 1
        GUICtrlSetData($g_idMatchInfoCombo, $aMatchInfoTypes[$i])
    Next

    GUICtrlSetData($g_idMatchInfoCombo, "Match Count") ; Default selection
EndFunc

; Handle category selection change
Func OnCategoryChange()
    Local $selectedCategory = GUICtrlRead($g_idCategoryCombo)

    If $selectedCategory = "Character Information" Then
        GUICtrlSetState($g_idCharInfoCombo, $GUI_SHOW)
        GUICtrlSetState($g_idMatchInfoCombo, $GUI_HIDE)
    ElseIf $selectedCategory = "Observer Match Information" Then
        GUICtrlSetState($g_idCharInfoCombo, $GUI_HIDE)
        GUICtrlSetState($g_idMatchInfoCombo, $GUI_SHOW)
    EndIf
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
        LogWrite("Connection to GwNexus established successfully.")
        $g_bConnected = True

        ; Enable info controls
        GUICtrlSetState($g_idCategoryCombo, $GUI_ENABLE)
        GUICtrlSetState($g_idCharInfoCombo, $GUI_ENABLE)
        GUICtrlSetState($g_idMatchInfoCombo, $GUI_ENABLE)
        GUICtrlSetState($g_idGetInfoBtn, $GUI_ENABLE)

        ; Update category visibility
        OnCategoryChange()

        ; Disable the connect button
        GUICtrlSetState($g_idConnectBtn, $GUI_DISABLE)
        ; Disable the input field
        GUICtrlSetState($g_idCharInput, $GUI_DISABLE)

        Return True
    EndIf
EndFunc

; Get character information
Func GetCharacterInfo()
    Local $infoType = GUICtrlRead($g_idCharInfoCombo)
    LogWrite("Retrieving character information: " & $infoType)

    Switch $infoType
        Case "Player Agent ID"
            Local $result = _Character_PlayerAgentID()
            If @error Then
                LogWrite("Error: Failed to retrieve player agent ID.")
            Else
                LogWrite("Player Agent ID: " & $result)
            EndIf

        Case "Player Name"
            Local $result = _Character_PlayerName()
            If @error Then
                LogWrite("Error: Failed to retrieve player name.")
            Else
                LogWrite("Player Name: " & $result)
            EndIf

        Case "Player UUID"
            Local $result = _Character_PlayerUUID()
            If @error Then
                LogWrite("Error: Failed to retrieve player UUID.")
            Else
                LogWrite("Player UUID: [" & $result[0] & ", " & $result[1] & ", " & $result[2] & ", " & $result[3] & "]")
            EndIf

        Case "World Flags"
            Local $result = _Character_WorldFlags()
            If @error Then
                LogWrite("Error: Failed to retrieve world flags.")
            Else
                LogWrite("World Flags: " & $result)
            EndIf

        Case "Token 1"
            Local $result = _Character_Token1()
            If @error Then
                LogWrite("Error: Failed to retrieve token 1.")
            Else
                LogWrite("Token 1: " & $result)
            EndIf

        Case "Map ID"
            Local $result = _Character_MapID()
            If @error Then
                LogWrite("Error: Failed to retrieve map ID.")
            Else
                LogWrite("Map ID: " & $result)
            EndIf

        Case "Is Explorable"
            Local $result = _Character_IsExplorable()
            If @error Then
                LogWrite("Error: Failed to retrieve explorable status.")
            Else
                LogWrite("Is Explorable: " & ($result ? "Yes" : "No"))
            EndIf

        Case "Token 2"
            Local $result = _Character_Token2()
            If @error Then
                LogWrite("Error: Failed to retrieve token 2.")
            Else
                LogWrite("Token 2: " & $result)
            EndIf

        Case "District Number"
            Local $result = _Character_DistrictNumber()
            If @error Then
                LogWrite("Error: Failed to retrieve district number.")
            Else
                LogWrite("District Number: " & $result)
            EndIf

        Case "Language"
            Local $result = _Character_Language()
            If @error Then
                LogWrite("Error: Failed to retrieve language.")
            Else
                LogWrite("Language: " & $result)
            EndIf

        Case "Observe Map ID"
            Local $result = _Character_ObserveMapID()
            If @error Then
                LogWrite("Error: Failed to retrieve observe map ID.")
            Else
                LogWrite("Observe Map ID: " & $result)
            EndIf

        Case "Current Map ID"
            Local $result = _Character_CurrentMapID()
            If @error Then
                LogWrite("Error: Failed to retrieve current map ID.")
            Else
                LogWrite("Current Map ID: " & $result)
            EndIf

        Case "Observe Map Type"
            Local $result = _Character_ObserveMapType()
            If @error Then
                LogWrite("Error: Failed to retrieve observe map type.")
            Else
                LogWrite("Observe Map Type: " & $result)
            EndIf

        Case "Current Map Type"
            Local $result = _Character_CurrentMapType()
            If @error Then
                LogWrite("Error: Failed to retrieve current map type.")
            Else
                LogWrite("Current Map Type: " & $result)
            EndIf

        Case "Player Flags"
            Local $result = _Character_PlayerFlags()
            If @error Then
                LogWrite("Error: Failed to retrieve player flags.")
            Else
                LogWrite("Player Flags: " & $result)
            EndIf

        Case "Player Number"
            Local $result = _Character_PlayerNumber()
            If @error Then
                LogWrite("Error: Failed to retrieve player number.")
            Else
                LogWrite("Player Number: " & $result)
            EndIf

        Case "Player Email"
            Local $result = _Character_PlayerEmail()
            If @error Then
                LogWrite("Error: Failed to retrieve player email.")
            Else
                LogWrite("Player Email: " & $result)
            EndIf

        Case "All Information"
            Local $result = _Character_All()
            If @error Then
                LogWrite("Error: Failed to retrieve all character information.")
            Else
                LogWrite("All Character Information:")
				LogWrite("  PlayerAgentID: " & $result[0])
				LogWrite("  PlayerName: " & $result[1])
				LogWrite("  PlayerUUID1: " & $result[2])
				LogWrite("  PlayerUUID2: " & $result[3])
				LogWrite("  PlayerUUID3: " & $result[4])
				LogWrite("  PlayerUUID4: " & $result[5])
				LogWrite("  WorldFlags: " & $result[6])
				LogWrite("  Token1: " & $result[7])
				LogWrite("  MapID: " & $result[8])
				LogWrite("  IsExplorable: " & $result[9])
				LogWrite("  Token2: " & $result[10])
				LogWrite("  DistrictNumber: " & $result[11])
				LogWrite("  Language: " & $result[12])
				LogWrite("  ObserveMapID: " & $result[13])
				LogWrite("  CurrentMapID: " & $result[14])
				LogWrite("  ObserveMapType: " & $result[15])
				LogWrite("  CurrentMapType: " & $result[16])
				LogWrite("  PlayerFlags: " & $result[17])
				LogWrite("  PlayerNumber: " & $result[18])
				LogWrite("  PlayerRmail: " & $result[19])
            EndIf

        Case Else
            LogWrite("Error: Unknown character information type.")
    EndSwitch
EndFunc

; Get observer match information
; Get observer match information
Func GetMatchInfo()
    Local $infoType = GUICtrlRead($g_idMatchInfoCombo)
    LogWrite("Retrieving observer match information: " & $infoType)

    Switch $infoType
        Case "Match Count"
            Local $result = _ObserverMatch_Count()
            If @error Then
                LogWrite("Error: Failed to retrieve match count.")
            Else
                LogWrite("Observer Match Count: " & $result)
            EndIf

        Case "Match By Index"
            Local $index = InputBox("Match Index", "Enter the index of the match to retrieve (0-based):", "0")
            If @error Then Return

            Local $result = _ObserverMatch_ByIndex(Number($index))
            If @error Then
                LogWrite("Error: Failed to retrieve match at index " & $index & ".")
            Else
                LogWrite("Observer Match at index " & $index & ":")
                LogWrite("  MatchID: " & $result[0])
                LogWrite("  MatchIDDup: " & $result[1])
                LogWrite("  MapID: " & $result[2])
                LogWrite("  Age: " & $result[3])
                LogWrite("  FlagsType: " & $result[4])
                LogWrite("  FlagsReserved: " & $result[5])
                LogWrite("  FlagsVersion: " & $result[6])
                LogWrite("  FlagsState: " & $result[7])
                LogWrite("  FlagsLevel: " & $result[8])
                LogWrite("  FlagsConfig1: " & $result[9])
                LogWrite("  FlagsConfig2: " & $result[10])
                LogWrite("  FlagsScore1: " & $result[11])
                LogWrite("  FlagsScore2: " & $result[12])
                LogWrite("  FlagsScore3: " & $result[13])
                LogWrite("  FlagsStat1: " & $result[14])
                LogWrite("  FlagsStat2: " & $result[15])
                LogWrite("  Team1Name: " & $result[16])
                LogWrite("  Team2Name: " & $result[17])
            EndIf

        Case "All Matches"
            Local $result = _ObserverMatch_All()
            If @error Then
                LogWrite("Error: Failed to retrieve all matches. Error code: " & @error)
            Else
                Local $matchCount = $result[0][0]
                LogWrite("All Observer Matches (" & $matchCount & " matches):")

                ; If we have matches, display them
                If $matchCount > 0 Then
                    For $i = 1 To $matchCount
                        LogWrite("Match " & ($i-1) & ":")
                        LogWrite("  MatchID: " & $result[$i][0])
                        LogWrite("  MatchIDDup: " & $result[$i][1])
                        LogWrite("  MapID: " & $result[$i][2])
                        LogWrite("  Age: " & $result[$i][3])
                        LogWrite("  FlagsType: " & $result[$i][4])
                        LogWrite("  FlagsReserved: " & $result[$i][5])
                        LogWrite("  FlagsVersion: " & $result[$i][6])
                        LogWrite("  FlagsState: " & $result[$i][7])
                        LogWrite("  FlagsLevel: " & $result[$i][8])
                        LogWrite("  FlagsConfig1: " & $result[$i][9])
                        LogWrite("  FlagsConfig2: " & $result[$i][10])
                        LogWrite("  FlagsScore1: " & $result[$i][11])
                        LogWrite("  FlagsScore2: " & $result[$i][12])
                        LogWrite("  FlagsScore3: " & $result[$i][13])
                        LogWrite("  FlagsStat1: " & $result[$i][14])
                        LogWrite("  FlagsStat2: " & $result[$i][15])
                        LogWrite("  FlagsData1: " & $result[$i][16])
                        LogWrite("  FlagsData2: " & $result[$i][17])
                        LogWrite("  Team1Name: " & $result[$i][18])
                        LogWrite("  Team2Name: " & $result[$i][19])
                        LogWrite("")
                    Next
                EndIf
            EndIf

        Case Else
            LogWrite("Error: Unknown match information type.")
    EndSwitch
EndFunc

; Get information based on the selected category and type
Func GetSelectedInfo()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $selectedCategory = GUICtrlRead($g_idCategoryCombo)

    Switch $selectedCategory
        Case "Character Information"
            GetCharacterInfo()

        Case "Observer Match Information"
            GetMatchInfo()

        Case Else
            LogWrite("Error: Unknown category.")
    EndSwitch
EndFunc

; Main function
Func Main()
    ; Create the interface
    CreateInterface()

    LogWrite("Welcome to the Character Info Explorer!")
    LogWrite("Please enter the character name and click 'Connect'.")

    ; Event handling loop
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $g_idExit
                ExitLoop

            Case $g_idConnectBtn
                ConnectToGwNexus()

            Case $g_idCategoryCombo
                OnCategoryChange()

            Case $g_idGetInfoBtn
                GetSelectedInfo()

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