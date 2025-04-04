#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <TreeViewConstants.au3>
#include <GuiTreeView.au3>
#include "../Base.au3"
#include "../Queries/AccountInfo.au3"

; Global variables
Global $g_hGUI, $g_idCharInput, $g_idConnectBtn, $g_idInfoTree, $g_idGetInfoBtn, $g_idLog, $g_idClear, $g_idExit
Global $g_bConnected = False

; Create user interface
Func CreateInterface()
    $g_hGUI = GUICreate("GwNexus - Account Info Explorer", 800, 600)

    ; Connection section
    GUICtrlCreateGroup("Connection", 10, 10, 780, 60)
    GUICtrlCreateLabel("Character name for GwNexus_Initialize:", 20, 30, 250, 20)
    $g_idCharInput = GUICtrlCreateInput("", 270, 30, 400, 20)
    $g_idConnectBtn = GUICtrlCreateButton("Connect", 680, 30, 100, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Account info navigation section
    GUICtrlCreateGroup("Account Information", 10, 80, 250, 470)
    $g_idInfoTree = GUICtrlCreateTreeView(20, 100, 230, 410, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_SHOWSELALWAYS))
    $g_idGetInfoBtn = GUICtrlCreateButton("Get Selected Info", 20, 520, 230, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Results section
    GUICtrlCreateLabel("Results:", 270, 80, 100, 20)
    $g_idLog = GUICtrlCreateEdit("", 270, 100, 520, 440, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL))
    GUICtrlSetFont($g_idLog, 9, 400, 0, "Consolas") ; Fixed-width font for the log

    ; Bottom buttons
    $g_idClear = GUICtrlCreateButton("Clear Log", 600, 550, 100, 30)
    $g_idExit = GUICtrlCreateButton("Exit", 710, 550, 90, 30)

    ; Populate the tree view with account info options
    PopulateInfoTree()

    ; Disable account info controls until connected
    GUICtrlSetState($g_idInfoTree, $GUI_DISABLE)
    GUICtrlSetState($g_idGetInfoBtn, $GUI_DISABLE)

    ; Display the interface
    GUISetState(@SW_SHOW, $g_hGUI)
EndFunc

; Populate the tree view with account info options
Func PopulateInfoTree()
    ; Basic Account info
    Local $hBasicInfo = GUICtrlCreateTreeViewItem("Basic Account Information", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Account Name", $hBasicInfo)
    GUICtrlCreateTreeViewItem("Wins", $hBasicInfo)
    GUICtrlCreateTreeViewItem("Losses", $hBasicInfo)
    GUICtrlCreateTreeViewItem("Rating", $hBasicInfo)
    GUICtrlCreateTreeViewItem("Qualifier Points", $hBasicInfo)
    GUICtrlCreateTreeViewItem("Rank", $hBasicInfo)
    GUICtrlCreateTreeViewItem("Tournament Reward Points", $hBasicInfo)
    GUICtrlCreateTreeViewItem("Account Flags", $hBasicInfo)
    GUICtrlCreateTreeViewItem("All Basic Info", $hBasicInfo)

    ; Unlocked Skills
    Local $hSkills = GUICtrlCreateTreeViewItem("Unlocked Skills", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hSkills)
    GUICtrlCreateTreeViewItem("By Index", $hSkills)
    GUICtrlCreateTreeViewItem("All Skills", $hSkills)

    ; Unlocked PvP Items
    Local $hPvPItems = GUICtrlCreateTreeViewItem("Unlocked PvP Items", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hPvPItems)
    GUICtrlCreateTreeViewItem("By Index", $hPvPItems)
    GUICtrlCreateTreeViewItem("All Items", $hPvPItems)

    ; Unlocked PvP Item Info
    Local $hPvPItemInfo = GUICtrlCreateTreeViewItem("Unlocked PvP Item Info", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hPvPItemInfo)
    GUICtrlCreateTreeViewItem("By Index", $hPvPItemInfo)
    GUICtrlCreateTreeViewItem("All Item Info", $hPvPItemInfo)

    ; Unlocked Heroes
    Local $hHeroes = GUICtrlCreateTreeViewItem("Unlocked Heroes", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hHeroes)
    GUICtrlCreateTreeViewItem("By Index", $hHeroes)
    GUICtrlCreateTreeViewItem("All Heroes", $hHeroes)

    ; Unlocked Counts
    Local $hCounts = GUICtrlCreateTreeViewItem("Unlocked Counts", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Size", $hCounts)
    GUICtrlCreateTreeViewItem("By ID", $hCounts)
    GUICtrlCreateTreeViewItem("All Counts", $hCounts)

    GUICtrlSetState($hBasicInfo, $GUI_EXPAND)
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

        ; Enable account info controls
        GUICtrlSetState($g_idInfoTree, $GUI_ENABLE)
        GUICtrlSetState($g_idGetInfoBtn, $GUI_ENABLE)

        ; Disable the connect button
        GUICtrlSetState($g_idConnectBtn, $GUI_DISABLE)
        ; Disable the input field
        GUICtrlSetState($g_idCharInput, $GUI_DISABLE)

        Return True
    EndIf
EndFunc

; Get account information based on the selected item in the tree
Func GetSelectedAccountInfo()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $selectedItem = GUICtrlRead($g_idInfoTree)
    If $selectedItem = 0 Then
        LogWrite("Error: Please select an information type from the tree.")
        Return
    EndIf

    ; Utilisez _GUICtrlTreeView_GetText pour obtenir le texte réel
    Local $itemText = _GUICtrlTreeView_GetText($g_idInfoTree, $selectedItem)
    Local $parentHandle = _GUICtrlTreeView_GetParentHandle($g_idInfoTree, $selectedItem)
    Local $parentText = ""

    If $parentHandle Then
        $parentText = _GUICtrlTreeView_GetText($g_idInfoTree, $parentHandle)
    EndIf

    LogWrite("Retrieving account information: " & $parentText & " > " & $itemText)

    ; Basic Account Information
    If $parentText = "Basic Account Information" Then
        Switch $itemText
            Case "Account Name"
                Local $result = _AccountInfo_AccountName()
                If @error Then
                    LogWrite("Error retrieving account name.")
                Else
                    LogWrite("Account Name: " & $result)
                EndIf

            Case "Wins"
                Local $result = _AccountInfo_Wins()
                If @error Then
                    LogWrite("Error retrieving wins.")
                Else
                    LogWrite("Wins: " & $result)
                EndIf

            Case "Losses"
                Local $result = _AccountInfo_Losses()
                If @error Then
                    LogWrite("Error retrieving losses.")
                Else
                    LogWrite("Losses: " & $result)
                EndIf

            Case "Rating"
                Local $result = _AccountInfo_Rating()
                If @error Then
                    LogWrite("Error retrieving rating.")
                Else
                    LogWrite("Rating: " & $result)
                EndIf

            Case "Qualifier Points"
                Local $result = _AccountInfo_QualifierPoints()
                If @error Then
                    LogWrite("Error retrieving qualifier points.")
                Else
                    LogWrite("Qualifier Points: " & $result)
                EndIf

            Case "Rank"
                Local $result = _AccountInfo_Rank()
                If @error Then
                    LogWrite("Error retrieving rank.")
                Else
                    LogWrite("Rank: " & $result)
                EndIf

            Case "Tournament Reward Points"
                Local $result = _AccountInfo_TournamentRewardPoints()
                If @error Then
                    LogWrite("Error retrieving tournament reward points.")
                Else
                    LogWrite("Tournament Reward Points: " & $result)
                EndIf

            Case "Account Flags"
                Local $result = _AccountInfo_AccountFlags()
                If @error Then
                    LogWrite("Error retrieving account flags.")
                Else
                    LogWrite("Account Flags: " & $result)
                EndIf

            Case "All Basic Info"
                Local $result = _AccountInfo_All()
                If @error Then
                    LogWrite("Error retrieving all basic account info.")
                Else
                    LogWrite("All Basic Account Information:")
					LogWrite("  AccountName: " & $result[0])
					LogWrite("  Wins: " & $result[1])
					LogWrite("  Losses: " & $result[2])
					LogWrite("  Rating: " & $result[3])
					LogWrite("  QualifierPoints: " & $result[4])
					LogWrite("  Rank: " & $result[5])
					LogWrite("  TournamentRewardPoints: " & $result[6])
					LogWrite("  AccountFlags: " & $result[7])
                EndIf
        EndSwitch

    ; Unlocked Skills
    ElseIf $parentText = "Unlocked Skills" Then
        Switch $itemText
            Case "Count"
                Local $result = _AccountInfo_UnlockedSkillsCount()
                If @error Then
                    LogWrite("Error retrieving unlocked skills count.")
                Else
                    LogWrite("Unlocked Skills Count: " & $result)
                EndIf

            Case "By Index"
                Local $index = InputBox("Skill Index", "Enter the index of the skill to retrieve (0-based):", "0")
                If @error Then Return

                Local $result = _AccountInfo_UnlockedSkillByIndex(Number($index))
                If @error Then
                    LogWrite("Error retrieving unlocked skill at index " & $index & ".")
                Else
                    LogWrite("Unlocked Skill at index " & $index & ": " & $result)
                EndIf

            Case "All Skills"
                Local $result = _AccountInfo_AllUnlockedSkills()
                If @error Then
                    LogWrite("Error retrieving all unlocked skills.")
                Else
                    LogWrite("All Unlocked Skills:")
                    For $i = 0 To UBound($result) - 1
                        LogWrite("  Skill " & $i & ": " & $result[$i])
                    Next
                EndIf
        EndSwitch

; Unlocked PvP Items
    ElseIf $parentText = "Unlocked PvP Items" Then
        Switch $itemText
            Case "Count"
                Local $result = _AccountInfo_UnlockedPvPItemsCount()
                If @error Then
                    LogWrite("Error retrieving unlocked PvP items count.")
                Else
                    LogWrite("Unlocked PvP Items Count: " & $result)
                EndIf

            Case "By Index"
                Local $index = InputBox("PvP Item Index", "Enter the index of the PvP item to retrieve (0-based):", "0")
                If @error Then Return

                Local $result = _AccountInfo_UnlockedPvPItemByIndex(Number($index))
                If @error Then
                    LogWrite("Error retrieving unlocked PvP item at index " & $index & ".")
                Else
                    LogWrite("Unlocked PvP Item at index " & $index & ": " & $result)
                EndIf

            Case "All Items"
                Local $result = _AccountInfo_AllUnlockedPvPItems()
                If @error Then
                    LogWrite("Error retrieving all unlocked PvP items.")
                Else
                    LogWrite("All Unlocked PvP Items:")
                    For $i = 0 To UBound($result) - 1
                        LogWrite("  Item " & $i & ": " & $result[$i])
                    Next
                EndIf
        EndSwitch

    ; Unlocked PvP Item Info
    ElseIf $parentText = "Unlocked PvP Item Info" Then
        Switch $itemText
            Case "Count"
                Local $result = _AccountInfo_UnlockedPvPItemInfoCount()
                If @error Then
                    LogWrite("Error retrieving unlocked PvP item info count.")
                Else
                    LogWrite("Unlocked PvP Item Info Count: " & $result)
                EndIf

            Case "By Index"
                Local $index = InputBox("PvP Item Info Index", "Enter the index of the PvP item info to retrieve (0-based):", "0")
                If @error Then Return

                Local $result = _AccountInfo_UnlockedPvPItemInfoByIndex(Number($index))
                If @error Then
                    LogWrite("Error retrieving unlocked PvP item info at index " & $index & ".")
                Else
                    LogWrite("Unlocked PvP Item Info at index " & $index & ":")
                    LogWrite("  Name ID: " & $result[0])
                    LogWrite("  Mod Struct Index: " & $result[1])
                    LogWrite("  Mod Struct Size: " & $result[2])
                EndIf

            Case "All Item Info"
                Local $result = _AccountInfo_AllUnlockedPvPItemInfo()
                If @error Then
                    LogWrite("Error retrieving all unlocked PvP item info.")
                Else
                    LogWrite("All Unlocked PvP Item Info:")
                    For $i = 0 To UBound($result) - 1
                        LogWrite("  Item " & $i & ":")
                        LogWrite("    Name ID: " & $result[$i][0])
                        LogWrite("    Mod Struct Index: " & $result[$i][1])
                        LogWrite("    Mod Struct Size: " & $result[$i][2])
                    Next
                EndIf
        EndSwitch

    ; Unlocked Heroes
    ElseIf $parentText = "Unlocked Heroes" Then
        Switch $itemText
            Case "Count"
                Local $result = _AccountInfo_UnlockedHeroesCount()
                If @error Then
                    LogWrite("Error retrieving unlocked heroes count.")
                Else
                    LogWrite("Unlocked Heroes Count: " & $result)
                EndIf

            Case "By Index"
                Local $index = InputBox("Hero Index", "Enter the index of the hero to retrieve (0-based):", "0")
                If @error Then Return

                Local $result = _AccountInfo_UnlockedHeroByIndex(Number($index))
                If @error Then
                    LogWrite("Error retrieving unlocked hero at index " & $index & ".")
                Else
                    LogWrite("Unlocked Hero at index " & $index & ": " & $result)
                EndIf

            Case "All Heroes"
                Local $result = _AccountInfo_AllUnlockedHeroes()
                If @error Then
                    LogWrite("Error retrieving all unlocked heroes.")
                Else
                    LogWrite("All Unlocked Heroes:")
                    For $i = 0 To UBound($result) - 1
                        LogWrite("  Hero " & $i & ": " & $result[$i])
                    Next
                EndIf
        EndSwitch

    ; Unlocked Counts
    ElseIf $parentText = "Unlocked Counts" Then
        Switch $itemText
            Case "Size"
                Local $result = _AccountInfo_UnlockedCountsSize()
                If @error Then
                    LogWrite("Error retrieving unlocked counts size.")
                Else
                    LogWrite("Unlocked Counts Size: " & $result)
                EndIf

            Case "By ID"
                Local $id = InputBox("Count ID", "Enter the ID of the count to retrieve:", "0")
                If @error Then Return

                Local $result = _AccountInfo_UnlockedCountById(Number($id))
                If @error Then
                    LogWrite("Error retrieving unlocked count with ID " & $id & ".")
                Else
                    LogWrite("Unlocked Count with ID " & $id & ":")
                    LogWrite("  ID: " & $result[0])
                    LogWrite("  Unknown 1: " & $result[1])
                    LogWrite("  Unknown 2: " & $result[2])
                EndIf

            Case "All Counts"
                Local $result = _AccountInfo_AllUnlockedCounts()
                If @error Then
                    LogWrite("Error retrieving all unlocked counts.")
                Else
                    LogWrite("All Unlocked Counts:")
                    For $i = 0 To UBound($result) - 1
                        LogWrite("  Count " & $i & ":")
                        LogWrite("    ID: " & $result[$i][0])
                        LogWrite("    Unknown 1: " & $result[$i][1])
                        LogWrite("    Unknown 2: " & $result[$i][2])
                    Next
                EndIf
        EndSwitch
    EndIf
EndFunc

; Main function
Func Main()
    ; Create the interface
    CreateInterface()

    LogWrite("Welcome to the Account Info Explorer!")
    LogWrite("Please enter the character name and click 'Connect'.")

    ; Event handling loop
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $g_idExit
                ExitLoop

            Case $g_idConnectBtn
                ConnectToGwNexus()

            Case $g_idGetInfoBtn
                GetSelectedAccountInfo()

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