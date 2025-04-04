#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include "../Base.au3"
#include "../Queries/MapConstInfo.au3"

; Global variables
Global $g_hGUI, $g_idCharInput, $g_idConnectBtn, $g_idMapIDInput, $g_idInfoTypeCombo
Global $g_idGetInfoBtn, $g_idLog, $g_idClear, $g_idExit
Global $g_bConnected = False

; Create user interface
Func CreateInterface()
    $g_hGUI = GUICreate("GwNexus - Map Info Explorer", 700, 550)

    ; Connection section
    GUICtrlCreateGroup("Connection", 10, 10, 680, 60)
    GUICtrlCreateLabel("Character name for GwNexus_Initialize:", 20, 30, 250, 20)
    $g_idCharInput = GUICtrlCreateInput("", 270, 30, 300, 20)
    $g_idConnectBtn = GUICtrlCreateButton("Connect", 580, 30, 100, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Map info query section
    GUICtrlCreateGroup("Map Information", 10, 80, 680, 90)
    GUICtrlCreateLabel("Map ID:", 20, 100, 80, 20)
    $g_idMapIDInput = GUICtrlCreateInput("1", 100, 100, 80, 20)

    GUICtrlCreateLabel("Information Type:", 200, 100, 100, 20)
    $g_idInfoTypeCombo = GUICtrlCreateCombo("", 300, 100, 250, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))

    $g_idGetInfoBtn = GUICtrlCreateButton("Get Info", 560, 100, 120, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Results section
    GUICtrlCreateLabel("Results:", 10, 180, 100, 20)
    $g_idLog = GUICtrlCreateEdit("", 10, 200, 680, 300, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL))
    GUICtrlSetFont($g_idLog, 9, 400, 0, "Consolas") ; Fixed-width font for the log

    ; Bottom buttons
    $g_idClear = GUICtrlCreateButton("Clear Log", 490, 510, 100, 30)
    $g_idExit = GUICtrlCreateButton("Exit", 600, 510, 90, 30)

    ; Populate the combo box with info types
    PopulateInfoTypeCombo()

    ; Disable map info controls until connected
    GUICtrlSetState($g_idMapIDInput, $GUI_DISABLE)
    GUICtrlSetState($g_idInfoTypeCombo, $GUI_DISABLE)
    GUICtrlSetState($g_idGetInfoBtn, $GUI_DISABLE)

    ; Display the interface
    GUISetState(@SW_SHOW, $g_hGUI)
EndFunc

; Populate the combo box with map info types
Func PopulateInfoTypeCombo()
    Local $aInfoTypes[26][2] = [ _
        [0, "Campaign"], _
        [1, "Continent"], _
        [2, "Region"], _
        [3, "Region Type"], _
        [4, "Flags"], _
        [5, "Thumbnail ID"], _
        [6, "Party Size"], _
        [7, "Player Size"], _
        [8, "Controlled Outpost ID"], _
        [9, "Fraction Mission"], _
        [10, "Level"], _
        [11, "Needed PQ"], _
        [12, "Mission Maps To"], _
        [13, "XY Coordinates"], _
        [14, "Icon Start XY"], _
        [15, "Icon End XY"], _
        [16, "Icon Start XY Dupe"], _
        [17, "Icon End XY Dupe"], _
        [18, "File ID"], _
        [19, "Mission Chronology"], _
        [20, "HA Map Chronology"], _
        [21, "Name ID"], _
        [22, "Description ID"], _
        [23, "Name"], _
        [24, "Description"], _
        [25, "All Properties"]]

    For $i = 0 To UBound($aInfoTypes) - 1
        GUICtrlSetData($g_idInfoTypeCombo, $aInfoTypes[$i][1])
    Next

    ; Set default selection
    GUICtrlSetData($g_idInfoTypeCombo, "All Properties")
EndFunc

; Get the info type value from the combo box text
Func GetInfoTypeFromCombo()
    Local $sComboText = GUICtrlRead($g_idInfoTypeCombo)

    Local $aInfoTypes[26][2] = [ _
        [0, "Campaign"], _
        [1, "Continent"], _
        [2, "Region"], _
        [3, "Region Type"], _
        [4, "Flags"], _
        [5, "Thumbnail ID"], _
        [6, "Party Size"], _
        [7, "Player Size"], _
        [8, "Controlled Outpost ID"], _
        [9, "Fraction Mission"], _
        [10, "Level"], _
        [11, "Needed PQ"], _
        [12, "Mission Maps To"], _
        [13, "XY Coordinates"], _
        [14, "Icon Start XY"], _
        [15, "Icon End XY"], _
        [16, "Icon Start XY Dupe"], _
        [17, "Icon End XY Dupe"], _
        [18, "File ID"], _
        [19, "Mission Chronology"], _
        [20, "HA Map Chronology"], _
        [21, "Name ID"], _
        [22, "Description ID"], _
        [23, "Name"], _
        [24, "Description"], _
        [25, "All Properties"]]

    For $i = 0 To UBound($aInfoTypes) - 1
        If $sComboText = $aInfoTypes[$i][1] Then
            Return $aInfoTypes[$i][0]
        EndIf
    Next

    Return 25 ; Default to All Properties
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

        ; Enable map info controls
        GUICtrlSetState($g_idMapIDInput, $GUI_ENABLE)
        GUICtrlSetState($g_idInfoTypeCombo, $GUI_ENABLE)
        GUICtrlSetState($g_idGetInfoBtn, $GUI_ENABLE)

        ; Disable the connect button
        GUICtrlSetState($g_idConnectBtn, $GUI_DISABLE)
        ; Disable the input field
        GUICtrlSetState($g_idCharInput, $GUI_DISABLE)

        Return True
    EndIf
EndFunc

; Get map information
Func GetMapInfoAndDisplay()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $mapID = Number(GUICtrlRead($g_idMapIDInput))
    If $mapID <= 0 Then
        LogWrite("Error: Please enter a valid map ID.")
        Return
    EndIf

    Local $infoType = GetInfoTypeFromCombo()
    LogWrite("Retrieving map information for Map ID: " & $mapID & ", Info Type: " & GUICtrlRead($g_idInfoTypeCombo))

    Local $result = _Nexus_MapConstInfo($mapID, $infoType)
    If @error Then
        LogWrite("Error: Failed to retrieve map information.")
        Return
    EndIf

    ; Display the result based on the info type
    Switch $infoType
        Case $MAP_INFO_NAME, $MAP_INFO_DESCRIPTION
            LogWrite("Result (string): " & $result)

        Case $MAP_INFO_PARTY_SIZE, $MAP_INFO_PLAYER_SIZE, $MAP_INFO_LEVEL, _
             $MAP_INFO_XY, $MAP_INFO_ICON_START_XY, $MAP_INFO_ICON_END_XY, _
             $MAP_INFO_ICON_START_XY_DUPE, $MAP_INFO_ICON_END_XY_DUPE
            LogWrite("Result (array): [" & $result[0] & ", " & $result[1] & "]")

        Case $MAP_INFO_ALL_PROPERTIES
            LogWrite("All Map Properties:")
            LogWrite("  Campaign: " & $result[0])
			LogWrite("  Continent: " & $result[1])
			LogWrite("  Region: " & $result[2])
			LogWrite("  RegionType: " & $result[3])
			LogWrite("  Flags: " & $result[4])
			LogWrite("  ThumbnailID: " & $result[5])
			LogWrite("  MinPartySize: " & $result[6])
			LogWrite("  MaxPartySize: " & $result[7])
			LogWrite("  MinPlayerSize: " & $result[8])
			LogWrite("  MaxPlayerSize: " & $result[9])
			LogWrite("  ControlledOutpostID: " & $result[10])
			LogWrite("  FractionMission: " & $result[11])
			LogWrite("  MinLevel: " & $result[12])
			LogWrite("  MaxLevel: " & $result[13])
			LogWrite("  NeededPQ: " & $result[14])
			LogWrite("  MissionMapsTo: " & $result[15])
			LogWrite("  X: " & $result[16])
			LogWrite("  Y: " & $result[17])
			LogWrite("  IconStartX: " & $result[18])
			LogWrite("  IconStartY: " & $result[19])
			LogWrite("  IconEndX: " & $result[20])
			LogWrite("  IconEndY: " & $result[21])
			LogWrite("  IconStartXDupe: " & $result[22])
			LogWrite("  IconStartYDupe: " & $result[23])
			LogWrite("  IconEndXDupe: " & $result[24])
			LogWrite("  IconEndYDupe: " & $result[25])
			LogWrite("  FileID: " & $result[26])
			LogWrite("  MissionChronology: " & $result[27])
			LogWrite("  HAMapChronology: " & $result[28])
			LogWrite("  NameID: " & $result[29])
			LogWrite("  DescriptionID: " & $result[30])
			LogWrite("  Name: " & $result[31])
			LogWrite("  Description: " & $result[32])

        Case Else
            LogWrite("Result (int): " & $result)
    EndSwitch
EndFunc

; Function to map campaign IDs to names (example)
Func GetCampaignName($campaignID)
    Local $campaigns = [ _
        [0, "Prophecies"], _
        [1, "Factions"], _
        [2, "Nightfall"], _
        [3, "Eye of the North"], _
        [4, "Beyond"]]

    For $i = 0 To UBound($campaigns) - 1
        If $campaigns[$i][0] = $campaignID Then
            Return $campaigns[$i][1]
        EndIf
    Next

    Return "Unknown Campaign"
EndFunc

; Main function
Func Main()
    ; Create the interface
    CreateInterface()

    LogWrite("Welcome to the Map Info Explorer!")
    LogWrite("Please enter the character name and click 'Connect'.")

    ; Event handling loop
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $g_idExit
                ExitLoop

            Case $g_idConnectBtn
                ConnectToGwNexus()

            Case $g_idGetInfoBtn
                GetMapInfoAndDisplay()

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