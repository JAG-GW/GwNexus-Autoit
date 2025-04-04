#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <TreeViewConstants.au3>
#include <GuiTreeView.au3>
#include "../Base.au3"
#include "../Queries/TradeInfo.au3"

; Global variables
Global $g_hGUI, $g_idCharInput, $g_idConnectBtn, $g_idInfoTree, $g_idGetInfoBtn, $g_idLog, $g_idClear, $g_idExit
Global $g_bConnected = False

; Create user interface
Func CreateInterface()
    $g_hGUI = GUICreate("GwNexus - Trade Info Explorer", 700, 600)

    ; Connection section
    GUICtrlCreateGroup("Connection", 10, 10, 680, 60)
    GUICtrlCreateLabel("Character name for GwNexus_Initialize:", 20, 30, 250, 20)
    $g_idCharInput = GUICtrlCreateInput("", 270, 30, 300, 20)
    $g_idConnectBtn = GUICtrlCreateButton("Connect", 580, 30, 100, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Trade info navigation section
    GUICtrlCreateGroup("Trade Information", 10, 80, 250, 470)
    $g_idInfoTree = GUICtrlCreateTreeView(20, 100, 230, 410, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_SHOWSELALWAYS))
    $g_idGetInfoBtn = GUICtrlCreateButton("Get Selected Info", 20, 520, 230, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Results section
    GUICtrlCreateLabel("Results:", 270, 80, 100, 20)
    $g_idLog = GUICtrlCreateEdit("", 270, 100, 420, 450, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL))
    GUICtrlSetFont($g_idLog, 9, 400, 0, "Consolas") ; Fixed-width font for the log

    ; Bottom buttons
    $g_idClear = GUICtrlCreateButton("Clear Log", 490, 560, 100, 30)
    $g_idExit = GUICtrlCreateButton("Exit", 600, 560, 90, 30)

    ; Populate the tree view with trade info options
    PopulateTradeInfoTree()

    ; Disable trade info controls until connected
    GUICtrlSetState($g_idInfoTree, $GUI_DISABLE)
    GUICtrlSetState($g_idGetInfoBtn, $GUI_DISABLE)

    ; Display the interface
    GUISetState(@SW_SHOW, $g_hGUI)
EndFunc

; Populate the tree view with trade info options
Func PopulateTradeInfoTree()
    ; Main trade info categories
    Local $hTradeInfo = GUICtrlCreateTreeViewItem("General Trade Information", $g_idInfoTree)
    Local $hPlayerItems = GUICtrlCreateTreeViewItem("Player's Items", $g_idInfoTree)
    Local $hPartnerItems = GUICtrlCreateTreeViewItem("Partner's Items", $g_idInfoTree)

    ; General trade info items
    GUICtrlCreateTreeViewItem("Trade Status", $hTradeInfo)
    GUICtrlCreateTreeViewItem("Player Gold", $hTradeInfo)
    GUICtrlCreateTreeViewItem("Player Items Count", $hTradeInfo)
    GUICtrlCreateTreeViewItem("Partner Gold", $hTradeInfo)
    GUICtrlCreateTreeViewItem("Partner Items Count", $hTradeInfo)
    GUICtrlCreateTreeViewItem("All Trade Information", $hTradeInfo)

    ; Player items
    GUICtrlCreateTreeViewItem("Count", $hPlayerItems)
    GUICtrlCreateTreeViewItem("Item by Index", $hPlayerItems)
    GUICtrlCreateTreeViewItem("All Items", $hPlayerItems)

    ; Partner items
    GUICtrlCreateTreeViewItem("Count", $hPartnerItems)
    GUICtrlCreateTreeViewItem("Item by Index", $hPartnerItems)
    GUICtrlCreateTreeViewItem("All Items", $hPartnerItems)

    ; Expand all categories by default
    GUICtrlSetState($hTradeInfo, $GUI_EXPAND)
    GUICtrlSetState($hPlayerItems, $GUI_EXPAND)
    GUICtrlSetState($hPartnerItems, $GUI_EXPAND)
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

        ; Enable trade info controls
        GUICtrlSetState($g_idInfoTree, $GUI_ENABLE)
        GUICtrlSetState($g_idGetInfoBtn, $GUI_ENABLE)

        ; Disable the connect button
        GUICtrlSetState($g_idConnectBtn, $GUI_DISABLE)
        ; Disable the input field
        GUICtrlSetState($g_idCharInput, $GUI_DISABLE)

        Return True
    EndIf
EndFunc

; Get trade information based on the selected item in the tree
Func GetSelectedTradeInfo()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

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

    LogWrite("Retrieving trade information: " & $parentText & " > " & $itemText)

    ; Process based on parent and selected item
    If $parentText = "General Trade Information" Then
        Switch $itemText
            Case "Trade Status"
                Local $result = _Trade_Status()
                If @error Then
                    LogWrite("Error retrieving trade status.")
                Else
                    LogWrite("Trade Status: " & $result)
                EndIf

            Case "Player Gold"
                Local $result = _Trade_PlayerGold()
                If @error Then
                    LogWrite("Error retrieving player gold.")
                Else
                    LogWrite("Player Gold: " & $result)
                EndIf

            Case "Player Items Count"
                Local $result = _Trade_PlayerItemsCount()
                If @error Then
                    LogWrite("Error retrieving player items count.")
                Else
                    LogWrite("Player Items Count: " & $result)
                EndIf

            Case "Partner Gold"
                Local $result = _Trade_PartnerGold()
                If @error Then
                    LogWrite("Error retrieving partner gold.")
                Else
                    LogWrite("Partner Gold: " & $result)
                EndIf

            Case "Partner Items Count"
                Local $result = _Trade_PartnerItemsCount()
                If @error Then
                    LogWrite("Error retrieving partner items count.")
                Else
                    LogWrite("Partner Items Count: " & $result)
                EndIf

			Case "All Trade Information"
				Local $result = _Trade_All()
				If @error Then
					LogWrite("Error retrieving all trade information.")
				Else
					LogWrite("All Trade Information:")
					LogWrite("  Trade Status: " & $result[0])
					LogWrite("  Player Gold: " & $result[1])

					LogWrite("  Player Items:")
					Local $playerItems = $result[2]
					For $i = 0 To UBound($playerItems) - 1
						LogWrite("    Item " & $i & ": ID=" & $playerItems[$i][0] & ", Quantity=" & $playerItems[$i][1])
					Next

					LogWrite("  Partner Gold: " & $result[3])

					LogWrite("  Partner Items:")
					Local $partnerItems = $result[4]
					For $i = 0 To UBound($partnerItems) - 1
						LogWrite("    Item " & $i & ": ID=" & $partnerItems[$i][0] & ", Quantity=" & $partnerItems[$i][1])
					Next
				EndIf
        EndSwitch

    ElseIf $parentText = "Player's Items" Then
        Switch $itemText
            Case "Count"
                Local $result = _Trade_PlayerItems_Count()
                If @error Then
                    LogWrite("Error retrieving player items count.")
                Else
                    LogWrite("Player Items Count: " & $result)
                EndIf

            Case "Item by Index"
                Local $index = InputBox("Item Index", "Enter the index of the item to retrieve (0-based):", "0")
                If @error Then Return

                Local $result = _Trade_PlayerItems_ByIndex(Number($index))
                If @error Then
                    LogWrite("Error retrieving player item at index " & $index & ".")
                Else
                    LogWrite("Player Item at index " & $index & ":")
                    LogWrite("  Item ID: " & $result[0])
                    LogWrite("  Quantity: " & $result[1])
                EndIf

            Case "All Items"
                Local $result = _Trade_PlayerItems_All()
                If @error Then
                    LogWrite("Error retrieving all player items.")
                Else
                    LogWrite("All Player Items:")
                    For $i = 0 To UBound($result) - 1
                        LogWrite("  Item " & $i & ": ID=" & $result[$i][0] & ", Quantity=" & $result[$i][1])
                    Next
                EndIf
        EndSwitch

    ElseIf $parentText = "Partner's Items" Then
        Switch $itemText
            Case "Count"
                Local $result = _Trade_PartnerItems_Count()
                If @error Then
                    LogWrite("Error retrieving partner items count.")
                Else
                    LogWrite("Partner Items Count: " & $result)
                EndIf

            Case "Item by Index"
                Local $index = InputBox("Item Index", "Enter the index of the item to retrieve (0-based):", "0")
                If @error Then Return

                Local $result = _Trade_PartnerItems_ByIndex(Number($index))
                If @error Then
                    LogWrite("Error retrieving partner item at index " & $index & ".")
                Else
                    LogWrite("Partner Item at index " & $index & ":")
                    LogWrite("  Item ID: " & $result[0])
                    LogWrite("  Quantity: " & $result[1])
                EndIf

            Case "All Items"
                Local $result = _Trade_PartnerItems_All()
                If @error Then
                    LogWrite("Error retrieving all partner items.")
                Else
                    LogWrite("All Partner Items:")
                    For $i = 0 To UBound($result) - 1
                        LogWrite("  Item " & $i & ": ID=" & $result[$i][0] & ", Quantity=" & $result[$i][1])
                    Next
                EndIf
        EndSwitch
    EndIf
EndFunc

; Main function
Func Main()
    ; Create the interface
    CreateInterface()

    LogWrite("Welcome to the Trade Info Explorer!")
    LogWrite("Please enter the character name and click 'Connect'.")
    LogWrite("Note: Trade information is only available during active trades.")

    ; Event handling loop
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $g_idExit
                ExitLoop

            Case $g_idConnectBtn
                ConnectToGwNexus()

            Case $g_idGetInfoBtn
                GetSelectedTradeInfo()

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