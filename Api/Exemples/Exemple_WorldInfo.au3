#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <TreeViewConstants.au3>
#include <GuiTreeView.au3>
#include <TabConstants.au3>
#include <MsgBoxConstants.au3>
#include <GuiListView.au3>
#include "../Base.au3"
#include "../Queries/WorldInfo.au3"

; Global variables
Global $g_hGUI, $g_idCharInput, $g_idConnectBtn, $g_idMainTab
Global $g_idBasicInfoBtn, $g_idQuestsTab, $g_idNPCsTab, $g_idPlayersTab, $g_idTitlesTab, $g_idStatusBar
Global $g_idLog, $g_idClear, $g_idExit
Global $g_idQuestTree, $g_idQuestsList, $g_idGetQuestBtn, $g_idQuestRefreshBtn
Global $g_idNPCTree, $g_idNPCsList, $g_idGetNPCBtn, $g_idNPCRefreshBtn
Global $g_idPlayerTree, $g_idPlayersList, $g_idGetPlayerBtn, $g_idPlayerRefreshBtn
Global $g_idTitleTree, $g_idTitlesList, $g_idGetTitleBtn, $g_idTitleRefreshBtn
Global $g_bConnected = False

; Create user interface
Func CreateInterface()
    $g_hGUI = GUICreate("GwNexus - World Context Info Explorer", 1000, 700)

    ; Connection section
    GUICtrlCreateGroup("Connection", 10, 10, 980, 60)
    GUICtrlCreateLabel("Character name for GwNexus_Initialize:", 20, 30, 250, 20)
    $g_idCharInput = GUICtrlCreateInput("", 270, 30, 600, 20)
    $g_idConnectBtn = GUICtrlCreateButton("Connect", 880, 30, 100, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Main tab control
    $g_idMainTab = GUICtrlCreateTab(10, 80, 980, 570)

    ; Basic Info Tab
    GUICtrlCreateTabItem("Basic Info")
    $g_idBasicInfoBtn = GUICtrlCreateButton("Get Basic Information", 20, 110, 180, 30)

    ; Quests Tab
    GUICtrlCreateTabItem("Quests")
    $g_idQuestTree = GUICtrlCreateTreeView(20, 110, 250, 520, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_SHOWSELALWAYS))
    $g_idQuestsList = GUICtrlCreateListView("ID|Name|Status|From|To", 280, 110, 700, 480, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS))
    $g_idGetQuestBtn = GUICtrlCreateButton("Get Selected Quest", 280, 600, 150, 30)
    $g_idQuestRefreshBtn = GUICtrlCreateButton("Refresh Quests", 440, 600, 150, 30)

    ; NPCs Tab
    GUICtrlCreateTabItem("NPCs")
    $g_idNPCTree = GUICtrlCreateTreeView(20, 110, 250, 520, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_SHOWSELALWAYS))
    $g_idNPCsList = GUICtrlCreateListView("Model ID|Name|Prof|Level|Type", 280, 110, 700, 480, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS))
    $g_idGetNPCBtn = GUICtrlCreateButton("Get Selected NPC", 280, 600, 150, 30)
    $g_idNPCRefreshBtn = GUICtrlCreateButton("Refresh NPCs", 440, 600, 150, 30)

    ; Players Tab
    GUICtrlCreateTabItem("Players")
    $g_idPlayerTree = GUICtrlCreateTreeView(20, 110, 250, 520, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_SHOWSELALWAYS))
    $g_idPlayersList = GUICtrlCreateListView("Agent ID|Name|Primary|Secondary|Level", 280, 110, 700, 480, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS))
    $g_idGetPlayerBtn = GUICtrlCreateButton("Get Selected Player", 280, 600, 150, 30)
    $g_idPlayerRefreshBtn = GUICtrlCreateButton("Refresh Players", 440, 600, 150, 30)

    ; Titles Tab
    GUICtrlCreateTabItem("Titles")
    $g_idTitleTree = GUICtrlCreateTreeView(20, 110, 250, 520, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_SHOWSELALWAYS))
    $g_idTitlesList = GUICtrlCreateListView("ID|Title|Points|Current|Max", 280, 110, 700, 480, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS))
    $g_idGetTitleBtn = GUICtrlCreateButton("Get Selected Title", 280, 600, 150, 30)
    $g_idTitleRefreshBtn = GUICtrlCreateButton("Refresh Titles", 440, 600, 150, 30)

    GUICtrlCreateTabItem("") ; End of tabs

    ; Results log section
    $g_idStatusBar = GUICtrlCreateLabel("Status: Not connected", 10, 660, 700, 20)

    ; Bottom buttons
    $g_idClear = GUICtrlCreateButton("Clear Logs", 720, 660, 120, 30)
    $g_idExit = GUICtrlCreateButton("Exit", 850, 660, 120, 30)

    ; Populate the trees
    PopulateQuestTree()
    PopulateNPCTree()
    PopulatePlayerTree()
    PopulateTitleTree()

    ; Disable controls until connected
    DisableControls()

    ; Display the interface
    GUISetState(@SW_SHOW, $g_hGUI)
EndFunc

; Populate the quest information tree
Func PopulateQuestTree()
    ; Add quest information options
    Local $hQuestInfo = GUICtrlCreateTreeViewItem("Quest Information", $g_idQuestTree)
    GUICtrlCreateTreeViewItem("Quest Count", $hQuestInfo)
    GUICtrlCreateTreeViewItem("Active Quest", $hQuestInfo)
    GUICtrlCreateTreeViewItem("All Quests", $hQuestInfo)
    GUICtrlCreateTreeViewItem("Primary Quests", $hQuestInfo)
    GUICtrlCreateTreeViewItem("Completed Quests", $hQuestInfo)

    ; Expand quest information by default
    GUICtrlSetState($hQuestInfo, $GUI_EXPAND)
EndFunc

; Populate the NPC information tree
Func PopulateNPCTree()
    ; Add NPC information options
    Local $hNPCInfo = GUICtrlCreateTreeViewItem("NPC Information", $g_idNPCTree)
    GUICtrlCreateTreeViewItem("NPC Count", $hNPCInfo)
    GUICtrlCreateTreeViewItem("All NPCs", $hNPCInfo)
    GUICtrlCreateTreeViewItem("Henchmen", $hNPCInfo)
    GUICtrlCreateTreeViewItem("Heroes", $hNPCInfo)

    ; Expand NPC information by default
    GUICtrlSetState($hNPCInfo, $GUI_EXPAND)
EndFunc

; Populate the player information tree
Func PopulatePlayerTree()
    ; Add player information options
    Local $hPlayerInfo = GUICtrlCreateTreeViewItem("Player Information", $g_idPlayerTree)
    GUICtrlCreateTreeViewItem("Player Count", $hPlayerInfo)
    GUICtrlCreateTreeViewItem("Party Leader", $hPlayerInfo)
    GUICtrlCreateTreeViewItem("All Players", $hPlayerInfo)

    ; Expand player information by default
    GUICtrlSetState($hPlayerInfo, $GUI_EXPAND)
EndFunc

; Populate the title information tree
Func PopulateTitleTree()
    ; Add title information options
    Local $hTitleInfo = GUICtrlCreateTreeViewItem("Title Information", $g_idTitleTree)
    GUICtrlCreateTreeViewItem("Title Count", $hTitleInfo)
    GUICtrlCreateTreeViewItem("Active Title", $hTitleInfo)
    GUICtrlCreateTreeViewItem("Maxed Titles", $hTitleInfo)
    GUICtrlCreateTreeViewItem("All Titles", $hTitleInfo)

    ; Expand title information by default
    GUICtrlSetState($hTitleInfo, $GUI_EXPAND)
EndFunc

; Disable all controls until connected
Func DisableControls()
    GUICtrlSetState($g_idBasicInfoBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idQuestTree, $GUI_DISABLE)
    GUICtrlSetState($g_idQuestsList, $GUI_DISABLE)
    GUICtrlSetState($g_idGetQuestBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idQuestRefreshBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idNPCTree, $GUI_DISABLE)
    GUICtrlSetState($g_idNPCsList, $GUI_DISABLE)
    GUICtrlSetState($g_idGetNPCBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idNPCRefreshBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idPlayerTree, $GUI_DISABLE)
    GUICtrlSetState($g_idPlayersList, $GUI_DISABLE)
    GUICtrlSetState($g_idGetPlayerBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idPlayerRefreshBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idTitleTree, $GUI_DISABLE)
    GUICtrlSetState($g_idTitlesList, $GUI_DISABLE)
    GUICtrlSetState($g_idGetTitleBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idTitleRefreshBtn, $GUI_DISABLE)
EndFunc

; Enable all controls after connection
Func EnableControls()
    GUICtrlSetState($g_idBasicInfoBtn, $GUI_ENABLE)
    GUICtrlSetState($g_idQuestTree, $GUI_ENABLE)
    GUICtrlSetState($g_idQuestsList, $GUI_ENABLE)
    GUICtrlSetState($g_idGetQuestBtn, $GUI_ENABLE)
    GUICtrlSetState($g_idQuestRefreshBtn, $GUI_ENABLE)
    GUICtrlSetState($g_idNPCTree, $GUI_ENABLE)
    GUICtrlSetState($g_idNPCsList, $GUI_ENABLE)
    GUICtrlSetState($g_idGetNPCBtn, $GUI_ENABLE)
    GUICtrlSetState($g_idNPCRefreshBtn, $GUI_ENABLE)
    GUICtrlSetState($g_idPlayerTree, $GUI_ENABLE)
    GUICtrlSetState($g_idPlayersList, $GUI_ENABLE)
    GUICtrlSetState($g_idGetPlayerBtn, $GUI_ENABLE)
    GUICtrlSetState($g_idPlayerRefreshBtn, $GUI_ENABLE)
    GUICtrlSetState($g_idTitleTree, $GUI_ENABLE)
    GUICtrlSetState($g_idTitlesList, $GUI_ENABLE)
    GUICtrlSetState($g_idGetTitleBtn, $GUI_ENABLE)
    GUICtrlSetState($g_idTitleRefreshBtn, $GUI_ENABLE)
EndFunc

; Update the status bar
Func UpdateStatus($text)
    GUICtrlSetData($g_idStatusBar, "Status: " & $text)
EndFunc

; Connection function
Func ConnectToGwNexus()
    Local $charName = GUICtrlRead($g_idCharInput)

    If $charName = "" Then
        UpdateStatus("Error: Please enter a character name for connection.")
        Return False
    EndIf

    UpdateStatus("Attempting to connect with character: " & $charName)

    ; Initialize connection with the DLL
    GwNexus_Initialize($charName)

    If @error Then
        UpdateStatus("Error: Unable to connect to GwNexus.")
        Return False
    Else
        UpdateStatus("Connection to GwNexus established successfully.")
        $g_bConnected = True

        ; Enable controls
        EnableControls()

        ; Disable the connect button
        GUICtrlSetState($g_idConnectBtn, $GUI_DISABLE)
        ; Disable the input field
        GUICtrlSetState($g_idCharInput, $GUI_DISABLE)

        Return True
    EndIf
EndFunc

; Get and display basic world information
Func GetBasicWorldInfo()
    If Not $g_bConnected Then
        UpdateStatus("Error: Please connect to GwNexus first.")
        Return
    EndIf

    UpdateStatus("Retrieving basic world information...")

    Local $basicInfo = _World_AllBasicInfo()
    If @error Then
        UpdateStatus("Error retrieving basic world information.")
        Return
    EndIf

    ; Create a basic info display message box
    Local $message = "Basic World Information:" & @CRLF & @CRLF
    $message &= "Active Quest ID: " & $basicInfo[0] & @CRLF
    $message &= "Experience: " & $basicInfo[1] & @CRLF
    $message &= "Level: " & $basicInfo[2] & @CRLF
    $message &= "Kurzick Faction: " & $basicInfo[3] & @CRLF
    $message &= "Luxon Faction: " & $basicInfo[4] & @CRLF
    $message &= "Imperial Faction: " & $basicInfo[5] & @CRLF
    $message &= "Balthazar Faction: " & $basicInfo[6] & @CRLF
    $message &= "Skill Points: " & $basicInfo[7] & @CRLF
    $message &= "Hard Mode Unlocked: " & ($basicInfo[8] ? "Yes" : "No") & @CRLF
    $message &= "Quests: " & $basicInfo[9] & @CRLF
    $message &= "NPCs: " & $basicInfo[10] & @CRLF
    $message &= "Players: " & $basicInfo[11] & @CRLF
    $message &= "Titles: " & $basicInfo[12] & @CRLF
    $message &= "Vanquish Progress: " & $basicInfo[13] & "/" & $basicInfo[14] & " foes"

    MsgBox(64, "World Information", $message)
    UpdateStatus("Retrieved basic world information.")
EndFunc

; Get and process quest information
Func GetQuestInfo()
    If Not $g_bConnected Then
        UpdateStatus("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $selectedItem = GUICtrlRead($g_idQuestTree)
    If $selectedItem = 0 Then
        UpdateStatus("Error: Please select a quest information type from the tree.")
        Return
    EndIf

    Local $itemText = _GUICtrlTreeView_GetText($g_idQuestTree, $selectedItem)
    Local $parentHandle = _GUICtrlTreeView_GetParentHandle($g_idQuestTree, $selectedItem)
    Local $parentText = ""

    If $parentHandle Then
        $parentText = _GUICtrlTreeView_GetText($g_idQuestTree, $parentHandle)
    EndIf

    UpdateStatus("Retrieving quest information: " & $itemText)

    ; Clear the quest list
    _GUICtrlListView_DeleteAllItems($g_idQuestsList)

    Switch $itemText
        Case "Quest Count"
            Local $count = _Quest_Count()
            If @error Then
                UpdateStatus("Error retrieving quest count.")
            Else
                MsgBox(64, "Quest Count", "Number of quests in log: " & $count)
                UpdateStatus("Quest count: " & $count)
            EndIf

        Case "Active Quest"
            Local $quest = _Quest_ActiveQuest()
            If @error Then
                UpdateStatus("Error retrieving active quest.")
            Else
                If IsArray($quest) Then
                    ; Add to list view
                    Local $index = _GUICtrlListView_AddItem($g_idQuestsList, $quest[0])
                    _GUICtrlListView_AddSubItem($g_idQuestsList, $index, $quest[8], 1)
                    _GUICtrlListView_AddSubItem($g_idQuestsList, $index, GetQuestStatusText($quest[1]), 2)
                    _GUICtrlListView_AddSubItem($g_idQuestsList, $index, $quest[2], 3)
                    _GUICtrlListView_AddSubItem($g_idQuestsList, $index, $quest[3], 4)
                    UpdateStatus("Retrieved active quest: " & $quest[8])
                Else
                    UpdateStatus("No active quest found.")
                EndIf
            EndIf

        Case "All Quests"
            Local $quests = _Quest_All()
            If @error Then
                UpdateStatus("Error retrieving all quests.")
            Else
                DisplayQuestsInList($quests)
                UpdateStatus("Retrieved " & $quests[0][0] & " quests.")
            EndIf

        Case "Primary Quests"
            Local $quests = _Quest_PrimaryQuests()
            If @error Then
                UpdateStatus("Error retrieving primary quests.")
            Else
                DisplayQuestsInList($quests)
                UpdateStatus("Retrieved " & $quests[0][0] & " primary quests.")
            EndIf

        Case "Completed Quests"
            Local $quests = _Quest_CompletedQuests()
            If @error Then
                UpdateStatus("Error retrieving completed quests.")
            Else
                DisplayQuestsInList($quests)
                UpdateStatus("Retrieved " & $quests[0][0] & " completed quests.")
            EndIf
    EndSwitch
EndFunc

; Display quests in the list view
Func DisplayQuestsInList($quests)
    If Not IsArray($quests) Or $quests[0][0] <= 0 Then
        UpdateStatus("No quests to display.")
        Return
    EndIf

    ; Add each quest to the list view
    For $i = 1 To $quests[0][0]
        Local $index = _GUICtrlListView_AddItem($g_idQuestsList, $quests[$i][0])  ; quest_id
        _GUICtrlListView_AddSubItem($g_idQuestsList, $index, $quests[$i][8], 1)   ; name
        _GUICtrlListView_AddSubItem($g_idQuestsList, $index, GetQuestStatusText($quests[$i][1]), 2)  ; status
        _GUICtrlListView_AddSubItem($g_idQuestsList, $index, $quests[$i][2], 3)   ; map_from
        _GUICtrlListView_AddSubItem($g_idQuestsList, $index, $quests[$i][3], 4)   ; map_to
    Next
EndFunc

; Get the text representation of a quest status
Func GetQuestStatusText($status)
    Switch $status
        Case 0
            Return "Unknown"
        Case 1
            Return "Inactive"
        Case 2
            Return "Active"
        Case 3
            Return "Completed"
        Case 4
            Return "Active/Completed"
        Case 5
            Return "Completed/Active"
        Case Else
            Return "Status: " & $status
    EndSwitch
EndFunc

; Get and process NPC information
Func GetNPCInfo()
    If Not $g_bConnected Then
        UpdateStatus("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $selectedItem = GUICtrlRead($g_idNPCTree)
    If $selectedItem = 0 Then
        UpdateStatus("Error: Please select an NPC information type from the tree.")
        Return
    EndIf

    Local $itemText = _GUICtrlTreeView_GetText($g_idNPCTree, $selectedItem)
    Local $parentHandle = _GUICtrlTreeView_GetParentHandle($g_idNPCTree, $selectedItem)
    Local $parentText = ""

    If $parentHandle Then
        $parentText = _GUICtrlTreeView_GetText($g_idNPCTree, $parentHandle)
    EndIf

    UpdateStatus("Retrieving NPC information: " & $itemText)

    ; Clear the NPC list
    _GUICtrlListView_DeleteAllItems($g_idNPCsList)

    Switch $itemText
        Case "NPC Count"
            Local $count = _NPC_Count()
            If @error Then
                UpdateStatus("Error retrieving NPC count.")
            Else
                MsgBox(64, "NPC Count", "Number of NPCs: " & $count)
                UpdateStatus("NPC count: " & $count)
            EndIf

        Case "All NPCs"
            Local $npcs = _NPC_All()
            If @error Then
                UpdateStatus("Error retrieving all NPCs.")
            Else
                DisplayNPCsInList($npcs)
                UpdateStatus("Retrieved " & $npcs[0][0] & " NPCs.")
            EndIf

        Case "Henchmen"
            Local $npcs = _NPC_Henchmen()
            If @error Then
                UpdateStatus("Error retrieving henchmen.")
            Else
                DisplayNPCsInList($npcs)
                UpdateStatus("Retrieved " & $npcs[0][0] & " henchmen.")
            EndIf

        Case "Heroes"
            Local $npcs = _NPC_Heroes()
            If @error Then
                UpdateStatus("Error retrieving heroes.")
            Else
                DisplayNPCsInList($npcs)
                UpdateStatus("Retrieved " & $npcs[0][0] & " heroes.")
            EndIf
    EndSwitch
EndFunc

; Display NPCs in the list view
Func DisplayNPCsInList($npcs)
    If Not IsArray($npcs) Or $npcs[0][0] <= 0 Then
        UpdateStatus("No NPCs to display.")
        Return
    EndIf

    ; Add each NPC to the list view
    For $i = 1 To $npcs[0][0]
        Local $index = _GUICtrlListView_AddItem($g_idNPCsList, $npcs[$i][0])  ; model_file_id
        _GUICtrlListView_AddSubItem($g_idNPCsList, $index, $npcs[$i][6], 1)   ; name
        _GUICtrlListView_AddSubItem($g_idNPCsList, $index, GetProfessionName($npcs[$i][4]), 2)  ; primary
        _GUICtrlListView_AddSubItem($g_idNPCsList, $index, $npcs[$i][5], 3)   ; level
        _GUICtrlListView_AddSubItem($g_idNPCsList, $index, GetNPCTypeText($npcs[$i][3]), 4)  ; type
    Next
EndFunc

; Get the text representation of an NPC type
Func GetNPCTypeText($flags)
    If BitAND($flags, 0x10) Then
        Return "Henchman"
    ElseIf BitAND($flags, 0x20) Then
        Return "Hero"
    ElseIf BitAND($flags, 0x8) Then
        Return "Quest NPC"
    Else
        Return "Regular NPC"
    EndIf
EndFunc

; Get the profession name from its ID
Func GetProfessionName($profession)
    Switch $profession
        Case 0
            Return "None"
        Case 1
            Return "Warrior"
        Case 2
            Return "Ranger"
        Case 3
            Return "Monk"
        Case 4
            Return "Necromancer"
        Case 5
            Return "Mesmer"
        Case 6
            Return "Elementalist"
        Case 7
            Return "Assassin"
        Case 8
            Return "Ritualist"
        Case 9
            Return "Paragon"
        Case 10
            Return "Dervish"
        Case Else
            Return "Unknown"
    EndSwitch
EndFunc

; Get and process player information
Func GetPlayerInfo()
    If Not $g_bConnected Then
        UpdateStatus("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $selectedItem = GUICtrlRead($g_idPlayerTree)
    If $selectedItem = 0 Then
        UpdateStatus("Error: Please select a player information type from the tree.")
        Return
    EndIf

    Local $itemText = _GUICtrlTreeView_GetText($g_idPlayerTree, $selectedItem)
    Local $parentHandle = _GUICtrlTreeView_GetParentHandle($g_idPlayerTree, $selectedItem)
    Local $parentText = ""

    If $parentHandle Then
        $parentText = _GUICtrlTreeView_GetText($g_idPlayerTree, $parentHandle)
    EndIf

    UpdateStatus("Retrieving player information: " & $itemText)

    ; Clear the player list
    _GUICtrlListView_DeleteAllItems($g_idPlayersList)

    Switch $itemText
        Case "Player Count"
            Local $count = _Player_Count()
            If @error Then
                UpdateStatus("Error retrieving player count.")
            Else
                MsgBox(64, "Player Count", "Number of players: " & $count)
                UpdateStatus("Player count: " & $count)
            EndIf

        Case "Party Leader"
            Local $player = _Player_Leader()
            If @error Then
                UpdateStatus("Error retrieving party leader.")
            Else
                If IsArray($player) Then
                    ; Add to list view
                    Local $index = _GUICtrlListView_AddItem($g_idPlayersList, $player[0])
                    _GUICtrlListView_AddSubItem($g_idPlayersList, $index, $player[9], 1)
                    _GUICtrlListView_AddSubItem($g_idPlayersList, $index, GetProfessionName($player[3]), 2)
                    _GUICtrlListView_AddSubItem($g_idPlayersList, $index, GetProfessionName($player[4]), 3)
                    _GUICtrlListView_AddSubItem($g_idPlayersList, $index, "?", 4)
                    UpdateStatus("Retrieved party leader: " & $player[9])
                Else
                    UpdateStatus("No party leader found.")
                EndIf
            EndIf

        Case "All Players"
            Local $players = _Player_All()
            If @error Then
                UpdateStatus("Error retrieving all players.")
            Else
                DisplayPlayersInList($players)
                UpdateStatus("Retrieved " & $players[0][0] & " players.")
            EndIf
    EndSwitch
EndFunc

; Display players in the list view
Func DisplayPlayersInList($players)
    If Not IsArray($players) Or $players[0][0] <= 0 Then
        UpdateStatus("No players to display.")
        Return
    EndIf

    ; Add each player to the list view
    For $i = 1 To $players[0][0]
        Local $index = _GUICtrlListView_AddItem($g_idPlayersList, $players[$i][0])  ; agent_id
        _GUICtrlListView_AddSubItem($g_idPlayersList, $index, $players[$i][9], 1)   ; name
        _GUICtrlListView_AddSubItem($g_idPlayersList, $index, GetProfessionName($players[$i][3]), 2)  ; primary
        _GUICtrlListView_AddSubItem($g_idPlayersList, $index, GetProfessionName($players[$i][4]), 3)  ; secondary
        _GUICtrlListView_AddSubItem($g_idPlayersList, $index, "?", 4)  ; level
    Next
EndFunc

; Get and process title information
Func GetTitleInfo()
    If Not $g_bConnected Then
        UpdateStatus("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $selectedItem = GUICtrlRead($g_idTitleTree)
    If $selectedItem = 0 Then
        UpdateStatus("Error: Please select a title information type from the tree.")
        Return
    EndIf

    Local $itemText = _GUICtrlTreeView_GetText($g_idTitleTree, $selectedItem)
    Local $parentHandle = _GUICtrlTreeView_GetParentHandle($g_idTitleTree, $selectedItem)
    Local $parentText = ""

    If $parentHandle Then
        $parentText = _GUICtrlTreeView_GetText($g_idTitleTree, $parentHandle)
    EndIf

    UpdateStatus("Retrieving title information: " & $itemText)

    ; Clear the title list
    _GUICtrlListView_DeleteAllItems($g_idTitlesList)

    Switch $itemText
        Case "Title Count"
            Local $count = _Title_Count()
            If @error Then
                UpdateStatus("Error retrieving title count.")
            Else
                MsgBox(64, "Title Count", "Number of titles: " & $count)
                UpdateStatus("Title count: " & $count)
            EndIf

        Case "Active Title"
            Local $title = _Title_ActiveTitle()
            If @error Then
                UpdateStatus("Error retrieving active title.")
            Else
                If IsArray($title) Then
                    ; Add to list view
                    Local $index = _GUICtrlListView_AddItem($g_idTitlesList, $title[0])
                    _GUICtrlListView_AddSubItem($g_idTitlesList, $index, $title[8], 1)
                    _GUICtrlListView_AddSubItem($g_idTitlesList, $index, $title[1], 2)
                    _GUICtrlListView_AddSubItem($g_idTitlesList, $index, $title[2], 3)
                    _GUICtrlListView_AddSubItem($g_idTitlesList, $index, $title[7], 4)
                    UpdateStatus("Retrieved active title: " & $title[8])
                Else
                    UpdateStatus("No active title found.")
                EndIf
            EndIf

        Case "Maxed Titles"
            Local $titles = _Title_MaxedTitles()
            If @error Then
                UpdateStatus("Error retrieving maxed titles.")
            Else
                DisplayTitlesInList($titles)
                UpdateStatus("Retrieved " & $titles[0][0] & " maxed titles.")
            EndIf

        Case "All Titles"
            Local $titles = _Title_All()
            If @error Then
                UpdateStatus("Error retrieving all titles.")
            Else
                DisplayTitlesInList($titles)
                UpdateStatus("Retrieved " & $titles[0][0] & " titles.")
            EndIf
    EndSwitch
EndFunc

; Display titles in the list view
Func DisplayTitlesInList($titles)
    If Not IsArray($titles) Or $titles[0][0] <= 0 Then
        UpdateStatus("No titles to display.")
        Return
    EndIf

    ; Add each title to the list view
    For $i = 1 To $titles[0][0]
        Local $index = _GUICtrlListView_AddItem($g_idTitlesList, $titles[$i][0])  ; props
        _GUICtrlListView_AddSubItem($g_idTitlesList, $index, $titles[$i][8], 1)   ; name
        _GUICtrlListView_AddSubItem($g_idTitlesList, $index, $titles[$i][1], 2)   ; current_points
        _GUICtrlListView_AddSubItem($g_idTitlesList, $index, $titles[$i][2], 3)   ; current_title_tier_index
        _GUICtrlListView_AddSubItem($g_idTitlesList, $index, $titles[$i][7], 4)   ; max_title_tier_index
    Next
EndFunc

; Show details for a selected quest
Func ShowQuestDetails()
    Local $selectedIndex = _GUICtrlListView_GetSelectedIndices($g_idQuestsList)
    If $selectedIndex = "" Then
        UpdateStatus("Please select a quest from the list.")
        Return
    EndIf

    ; Get the quest ID from the first column
    Local $questId = _GUICtrlListView_GetItemText($g_idQuestsList, Number($selectedIndex))
    Local $quest = _Quest_ById(Number($questId))

    If @error Or Not IsArray($quest) Then
        UpdateStatus("Error retrieving quest details.")
        Return
    EndIf

    ; Create a details message box
    Local $message = "Quest Details:" & @CRLF & @CRLF
    $message &= "ID: " & $quest[0] & @CRLF
    $message &= "Name: " & $quest[8] & @CRLF
    $message &= "Status: " & GetQuestStatusText($quest[1]) & @CRLF
    $message &= "From Map: " & $quest[2] & @CRLF
    $message &= "To Map: " & $quest[3] & @CRLF
    $message &= "Location: " & $quest[7] & @CRLF
    $message &= "NPC: " & $quest[9] & @CRLF
    $message &= @CRLF & "Description:" & @CRLF & $quest[10] & @CRLF
    $message &= @CRLF & "Objectives:" & @CRLF & $quest[11]

    MsgBox(64, "Quest Details: " & $quest[8], $message)
    UpdateStatus("Showed details for quest: " & $quest[8])
EndFunc

; Show details for a selected NPC
Func ShowNPCDetails()
    Local $selectedIndex = _GUICtrlListView_GetSelectedIndices($g_idNPCsList)
    If $selectedIndex = "" Then
        UpdateStatus("Please select an NPC from the list.")
        Return
    EndIf

    ; Get the model ID from the first column
    Local $modelId = _GUICtrlListView_GetItemText($g_idNPCsList, Number($selectedIndex))

    ; Find the NPC in the list with this model ID
    Local $npcs = _NPC_ByModelId(Number($modelId))

    If @error Or Not IsArray($npcs) Or $npcs[0] <= 0 Then
        UpdateStatus("Error retrieving NPC details.")
        Return
    EndIf

    Local $npc = $npcs[1]

    ; Create a details message box
    Local $message = "NPC Details:" & @CRLF & @CRLF
    $message &= "Model ID: " & $npc[0] & @CRLF
    $message &= "Name: " & $npc[6] & @CRLF
    $message &= "Profession: " & GetProfessionName($npc[4]) & @CRLF
    $message &= "Level: " & $npc[5] & @CRLF
    $message &= "Type: " & GetNPCTypeText($npc[3]) & @CRLF
    $message &= "Scale: " & $npc[1] & @CRLF
    $message &= "Sex: " & ($npc[2] == 0 ? "Male" : "Female") & @CRLF
    $message &= "Flags: 0x" & Hex($npc[3], 8) & @CRLF
    $message &= "Files Count: " & $npc[7]

    MsgBox(64, "NPC Details: " & $npc[6], $message)
    UpdateStatus("Showed details for NPC: " & $npc[6])
EndFunc

; Show details for a selected player
Func ShowPlayerDetails()
    Local $selectedIndex = _GUICtrlListView_GetSelectedIndices($g_idPlayersList)
    If $selectedIndex = "" Then
        UpdateStatus("Please select a player from the list.")
        Return
    EndIf

    ; Get the agent ID from the first column
    Local $agentId = _GUICtrlListView_GetItemText($g_idPlayersList, Number($selectedIndex))
    Local $player = _Player_ByAgentId(Number($agentId))

    If @error Or Not IsArray($player) Then
        UpdateStatus("Error retrieving player details.")
        Return
    EndIf

    ; Create a details message box
    Local $message = "Player Details:" & @CRLF & @CRLF
    $message &= "Agent ID: " & $player[0] & @CRLF
    $message &= "Name: " & $player[9] & @CRLF
    $message &= "Primary: " & GetProfessionName($player[3]) & @CRLF
    $message &= "Secondary: " & GetProfessionName($player[4]) & @CRLF
    $message &= "Player Number: " & $player[6] & @CRLF
    $message &= "Party Leader Number: " & $player[5] & @CRLF
    $message &= "Party Size: " & $player[7] & @CRLF
    $message &= "Active Title Tier: " & $player[8] & @CRLF
    $message &= "Appearance: 0x" & Hex($player[1], 8) & @CRLF
    $message &= "Flags: 0x" & Hex($player[2], 8)

    MsgBox(64, "Player Details: " & $player[9], $message)
    UpdateStatus("Showed details for player: " & $player[9])
EndFunc

; Show details for a selected title
Func ShowTitleDetails()
    Local $selectedIndex = _GUICtrlListView_GetSelectedIndices($g_idTitlesList)
    If $selectedIndex = "" Then
        UpdateStatus("Please select a title from the list.")
        Return
    EndIf

    ; Get the ID from the first column
    Local $titleId = _GUICtrlListView_GetItemText($g_idTitlesList, Number($selectedIndex))
    Local $title = _Title_ById(Number($titleId))

    If @error Or Not IsArray($title) Then
        UpdateStatus("Error retrieving title details.")
        Return
    EndIf

    ; Create a details message box
    Local $message = "Title Details:" & @CRLF & @CRLF
    $message &= "ID: " & $title[0] & @CRLF
    $message &= "Name: " & $title[8] & @CRLF
    $message &= "Current Points: " & $title[1] & @CRLF
    $message &= "Current Tier: " & $title[2] & @CRLF
    $message &= "Points Needed (Current): " & $title[3] & @CRLF
    $message &= "Next Tier: " & $title[4] & @CRLF
    $message &= "Points Needed (Next): " & $title[5] & @CRLF
    $message &= "Max Rank: " & $title[6] & @CRLF
    $message &= "Max Tier: " & $title[7] & @CRLF
    $message &= "Description: " & $title[9]

    MsgBox(64, "Title Details: " & $title[8], $message)
    UpdateStatus("Showed details for title: " & $title[8])
EndFunc

; Main function
Func Main()
    ; Create the interface
    CreateInterface()

    UpdateStatus("Welcome to the World Context Info Explorer!")
    UpdateStatus("Please enter the character name and click 'Connect'.")

    ; Event handling loop
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $g_idExit
                ExitLoop

            Case $g_idConnectBtn
                ConnectToGwNexus()

            Case $g_idBasicInfoBtn
                GetBasicWorldInfo()

            Case $g_idGetQuestBtn
                ShowQuestDetails()

            Case $g_idQuestRefreshBtn
                GetQuestInfo()

            Case $g_idGetNPCBtn
                ShowNPCDetails()

            Case $g_idNPCRefreshBtn
                GetNPCInfo()

            Case $g_idGetPlayerBtn
                ShowPlayerDetails()

            Case $g_idPlayerRefreshBtn
                GetPlayerInfo()

            Case $g_idGetTitleBtn
                ShowTitleDetails()

            Case $g_idTitleRefreshBtn
                GetTitleInfo()

            Case $g_idClear
                UpdateStatus("Log cleared.")
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