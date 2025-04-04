#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include "../Base.au3"
#include "../Queries/PreGameInfo.au3"

; Global variables
Global $g_hGUI, $g_idCharInput, $g_idConnectBtn, $g_idLog, $g_idRefresh, $g_idClear, $g_idExit
Global $g_bConnected = False

; Create user interface
Func CreateInterface()
    $g_hGUI = GUICreate("GwNexus - PreGameInfo Explorer", 600, 500)

    ; Interface elements
    GUICtrlCreateLabel("Character name for GwNexus_Initialize:", 10, 10, 250, 20)
    $g_idCharInput = GUICtrlCreateInput("", 10, 30, 300, 25)

    $g_idConnectBtn = GUICtrlCreateButton("Connect", 320, 30, 100, 25)
    $g_idRefresh = GUICtrlCreateButton("Refresh", 430, 30, 70, 25)
    $g_idClear = GUICtrlCreateButton("Clear", 510, 30, 70, 25)

    GUICtrlCreateLabel("Results:", 10, 65, 100, 20)
    $g_idLog = GUICtrlCreateEdit("", 10, 85, 580, 365, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL))
    GUICtrlSetFont($g_idLog, 9, 400, 0, "Consolas") ; Fixed-width font for the log

    $g_idExit = GUICtrlCreateButton("Exit", 510, 460, 80, 30)

    ; Disable refresh button until connected
    GUICtrlSetState($g_idRefresh, $GUI_DISABLE)

    ; Display the interface
    GUISetState(@SW_SHOW, $g_hGUI)
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

        ; Enable the refresh button
        GUICtrlSetState($g_idRefresh, $GUI_ENABLE)
        ; Disable the connect button
        GUICtrlSetState($g_idConnectBtn, $GUI_DISABLE)
        ; Disable the input field
        GUICtrlSetState($g_idCharInput, $GUI_DISABLE)

        Return True
    EndIf
EndFunc

; Display all character selection screen information
Func RefreshInfo()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    LogWrite("Retrieving character selection screen information..." & @CRLF)

    ; Basic information
    Local $frameID = _PreGame_FrameID()
    If @error Then
        LogWrite("Error retrieving basic information.")
        Return
    EndIf

    Local $chosenIndex = _PreGame_ChosenCharacterIndex()
    Local $index1 = _PreGame_Index1()
    Local $index2 = _PreGame_Index2()
    Local $charCount = _PreGame_CharacterCount()
    Local $chosenName = _PreGame_CharacterName($chosenIndex)

    LogWrite("CHARACTER SELECTION SCREEN INFORMATION:")
    LogWrite("  Frame ID: " & $frameID)
    LogWrite("  Selected character index: " & $chosenIndex)
    LogWrite("  Selected character name: " & $chosenName)
    LogWrite("  Index1: " & $index1)
    LogWrite("  Index2: " & $index2)
    LogWrite("  Number of characters: " & $charCount)
    LogWrite("")

    ; Character list
    Local $allCharsInfo = _PreGame_AllCharacters()
    If IsArray($allCharsInfo) And UBound($allCharsInfo) > 0 Then
        LogWrite("CHARACTER LIST:")
        For $i = 0 To UBound($allCharsInfo) - 1
            LogWrite("  " & $i & ": " & $allCharsInfo[$i])
        Next
    Else
        LogWrite("No characters found or error retrieving the list.")
    EndIf
EndFunc

; Main function
Func Main()
    ; Create the interface
    CreateInterface()

    LogWrite("Welcome to the PreGameInfo Explorer!")
    LogWrite("Please enter the character name and click 'Connect'.")

    ; Event handling loop
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $g_idExit
                ExitLoop

            Case $g_idConnectBtn
                ConnectToGwNexus()
                If $g_bConnected Then
                    RefreshInfo()
                EndIf

            Case $g_idRefresh
                ClearLog()
                RefreshInfo()

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