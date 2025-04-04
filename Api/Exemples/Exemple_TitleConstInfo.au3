#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include "../Base.au3"
#include "../Queries/TitleConstInfo.au3"

; Global variables
Global $g_hGUI, $g_idCharInput, $g_idConnectBtn, $g_idTitleIDInput, $g_idInfoTypeCombo
Global $g_idGetInfoBtn, $g_idLog, $g_idClear, $g_idExit
Global $g_bConnected = False

; Create user interface
Func CreateInterface()
    $g_hGUI = GUICreate("GwNexus - Title Info Explorer", 600, 500)

    ; Connection section
    GUICtrlCreateGroup("Connection", 10, 10, 580, 60)
    GUICtrlCreateLabel("Character name for GwNexus_Initialize:", 20, 30, 250, 20)
    $g_idCharInput = GUICtrlCreateInput("", 270, 30, 200, 20)
    $g_idConnectBtn = GUICtrlCreateButton("Connect", 480, 30, 100, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Title info query section
    GUICtrlCreateGroup("Title Information", 10, 80, 580, 90)
    GUICtrlCreateLabel("Title ID:", 20, 100, 80, 20)
    $g_idTitleIDInput = GUICtrlCreateInput("1", 100, 100, 80, 20)

    GUICtrlCreateLabel("Information Type:", 200, 100, 100, 20)
    $g_idInfoTypeCombo = GUICtrlCreateCombo("", 300, 100, 150, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))

    $g_idGetInfoBtn = GUICtrlCreateButton("Get Info", 460, 100, 120, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Results section
    GUICtrlCreateLabel("Results:", 10, 180, 100, 20)
    $g_idLog = GUICtrlCreateEdit("", 10, 200, 580, 250, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL))
    GUICtrlSetFont($g_idLog, 9, 400, 0, "Consolas") ; Fixed-width font for the log

    ; Bottom buttons
    $g_idClear = GUICtrlCreateButton("Clear Log", 390, 460, 100, 30)
    $g_idExit = GUICtrlCreateButton("Exit", 500, 460, 90, 30)

    ; Populate the combo box with info types
    PopulateInfoTypeCombo()

    ; Disable title info controls until connected
    GUICtrlSetState($g_idTitleIDInput, $GUI_DISABLE)
    GUICtrlSetState($g_idInfoTypeCombo, $GUI_DISABLE)
    GUICtrlSetState($g_idGetInfoBtn, $GUI_DISABLE)

    ; Display the interface
    GUISetState(@SW_SHOW, $g_hGUI)
EndFunc

; Populate the combo box with title info types
Func PopulateInfoTypeCombo()
    Local $aInfoTypes[4][2] = [ _
        [0, "Title ID"], _
        [1, "Name ID"], _
        [2, "Name"], _
        [3, "All Properties"]]

    For $i = 0 To UBound($aInfoTypes) - 1
        GUICtrlSetData($g_idInfoTypeCombo, $aInfoTypes[$i][1])
    Next

    ; Set default selection
    GUICtrlSetData($g_idInfoTypeCombo, "All Properties")
EndFunc

; Get the info type value from the combo box text
Func GetInfoTypeFromCombo()
    Local $sComboText = GUICtrlRead($g_idInfoTypeCombo)

    Local $aInfoTypes[4][2] = [ _
        [0, "Title ID"], _
        [1, "Name ID"], _
        [2, "Name"], _
        [3, "All Properties"]]

    For $i = 0 To UBound($aInfoTypes) - 1
        If $sComboText = $aInfoTypes[$i][1] Then
            Return $aInfoTypes[$i][0]
        EndIf
    Next

    Return 3 ; Default to All Properties
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

        ; Enable title info controls
        GUICtrlSetState($g_idTitleIDInput, $GUI_ENABLE)
        GUICtrlSetState($g_idInfoTypeCombo, $GUI_ENABLE)
        GUICtrlSetState($g_idGetInfoBtn, $GUI_ENABLE)

        ; Disable the connect button
        GUICtrlSetState($g_idConnectBtn, $GUI_DISABLE)
        ; Disable the input field
        GUICtrlSetState($g_idCharInput, $GUI_DISABLE)

        Return True
    EndIf
EndFunc

; Get title information
Func GetTitleInfoAndDisplay()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $titleID = Number(GUICtrlRead($g_idTitleIDInput))
    If $titleID <= 0 Then
        LogWrite("Error: Please enter a valid title ID.")
        Return
    EndIf

    Local $infoType = GetInfoTypeFromCombo()
    LogWrite("Retrieving title information for Title ID: " & $titleID & ", Info Type: " & GUICtrlRead($g_idInfoTypeCombo))

    Local $result = _Nexus_TitleConstInfo($titleID, $infoType)
    If @error Then
        LogWrite("Error: Failed to retrieve title information.")
        Return
    EndIf

    ; Display the result based on the info type
    Switch $infoType
        Case $TITLE_INFO_NAME
            LogWrite("Result (string): " & $result)

        Case $TITLE_INFO_ALL_PROPERTIES
            LogWrite("All Title Properties:")
			LogWrite("  Title ID: " & $result[0])
			LogWrite("  Name ID: " & $result[1])
			LogWrite("  Name: " & $result[2])

        Case Else
            LogWrite("Result (int): " & $result)
    EndSwitch
EndFunc

; Main function
Func Main()
    ; Create the interface
    CreateInterface()

    LogWrite("Welcome to the Title Info Explorer!")
    LogWrite("Please enter the character name and click 'Connect'.")

    ; Event handling loop
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $g_idExit
                ExitLoop

            Case $g_idConnectBtn
                ConnectToGwNexus()

            Case $g_idGetInfoBtn
                GetTitleInfoAndDisplay()

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