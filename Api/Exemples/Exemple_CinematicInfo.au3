#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include "../Base.au3"
#include "../Queries/CinematicInfo.au3"

; Global variables
Global $g_hGUI, $g_idCharInput, $g_idConnectBtn, $g_idInfoTypeCombo
Global $g_idGetInfoBtn, $g_idLog, $g_idClear, $g_idExit
Global $g_bConnected = False

; Create user interface
Func CreateInterface()
    $g_hGUI = GUICreate("GwNexus - Cinematic Info Explorer", 600, 450)

    ; Connection section
    GUICtrlCreateGroup("Connection", 10, 10, 580, 60)
    GUICtrlCreateLabel("Character name for GwNexus_Initialize:", 20, 30, 250, 20)
    $g_idCharInput = GUICtrlCreateInput("", 270, 30, 200, 20)
    $g_idConnectBtn = GUICtrlCreateButton("Connect", 480, 30, 100, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Cinematic info query section
    GUICtrlCreateGroup("Cinematic Information", 10, 80, 580, 70)
    GUICtrlCreateLabel("Information Type:", 20, 100, 100, 20)
    $g_idInfoTypeCombo = GUICtrlCreateCombo("", 130, 100, 320, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
    $g_idGetInfoBtn = GUICtrlCreateButton("Get Info", 460, 100, 120, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Results section
    GUICtrlCreateLabel("Results:", 10, 160, 100, 20)
    $g_idLog = GUICtrlCreateEdit("", 10, 180, 580, 220, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL))
    GUICtrlSetFont($g_idLog, 9, 400, 0, "Consolas") ; Fixed-width font for the log

    ; Bottom buttons
    $g_idClear = GUICtrlCreateButton("Clear Log", 390, 410, 100, 30)
    $g_idExit = GUICtrlCreateButton("Exit", 500, 410, 90, 30)

    ; Populate the combo box with info types
    PopulateInfoTypeCombo()

    ; Disable cinematic info controls until connected
    GUICtrlSetState($g_idInfoTypeCombo, $GUI_DISABLE)
    GUICtrlSetState($g_idGetInfoBtn, $GUI_DISABLE)

    ; Display the interface
    GUISetState(@SW_SHOW, $g_hGUI)
EndFunc

; Populate the combo box with cinematic info types
Func PopulateInfoTypeCombo()
    Local $aInfoTypes[3][2] = [ _
        [0, "h0000"], _
        [1, "h0004"], _
        [2, "All Properties"]]

    For $i = 0 To UBound($aInfoTypes) - 1
        GUICtrlSetData($g_idInfoTypeCombo, $aInfoTypes[$i][1])
    Next

    ; Set default selection
    GUICtrlSetData($g_idInfoTypeCombo, "All Properties")
EndFunc

; Get the info type value from the combo box text
Func GetInfoTypeFromCombo()
    Local $sComboText = GUICtrlRead($g_idInfoTypeCombo)

    Local $aInfoTypes[3][2] = [ _
        [0, "h0000"], _
        [1, "h0004"], _
        [2, "All Properties"]]

    For $i = 0 To UBound($aInfoTypes) - 1
        If $sComboText = $aInfoTypes[$i][1] Then
            Return $aInfoTypes[$i][0]
        EndIf
    Next

    Return 2 ; Default to All Properties
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

        ; Enable cinematic info controls
        GUICtrlSetState($g_idInfoTypeCombo, $GUI_ENABLE)
        GUICtrlSetState($g_idGetInfoBtn, $GUI_ENABLE)

        ; Disable the connect button
        GUICtrlSetState($g_idConnectBtn, $GUI_DISABLE)
        ; Disable the input field
        GUICtrlSetState($g_idCharInput, $GUI_DISABLE)

        Return True
    EndIf
EndFunc

; Get cinematic information
Func GetCinematicInfoAndDisplay()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $infoType = GetInfoTypeFromCombo()
    LogWrite("Retrieving cinematic information for type: " & GUICtrlRead($g_idInfoTypeCombo))

    Local $result = _Nexus_CinematicInfo($infoType)
    If @error Then
        LogWrite("Error: Failed to retrieve cinematic information.")
        Return
    EndIf

    ; Display the result based on the info type
    Switch $infoType
        Case $CINEMATIC_INFO_H0000, $CINEMATIC_INFO_H0004
            LogWrite("Result (int): " & $result)

        Case $CINEMATIC_INFO_ALL_PROPERTIES
            LogWrite("All Cinematic Properties:")
            For $i = 0 To UBound($result) - 1
                LogWrite("  " & $i & ": " & $result[$i])
            Next

        Case Else
            LogWrite("Unknown info type")
    EndSwitch
EndFunc

; Main function
Func Main()
    ; Create the interface
    CreateInterface()

    LogWrite("Welcome to the Cinematic Info Explorer!")
    LogWrite("Please enter the character name and click 'Connect'.")
    LogWrite("Note: Cinematic information is only available during in-game cinematics.")

    ; Event handling loop
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $g_idExit
                ExitLoop

            Case $g_idConnectBtn
                ConnectToGwNexus()

            Case $g_idGetInfoBtn
                GetCinematicInfoAndDisplay()

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