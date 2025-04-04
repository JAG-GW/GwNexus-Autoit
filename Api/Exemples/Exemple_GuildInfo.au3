#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <TreeViewConstants.au3>
#include <GuiTreeView.au3>
#include "../Base.au3"
#include "../Queries/GuildInfo.au3"

; Global variables
Global $g_hGUI, $g_idCharInput, $g_idConnectBtn, $g_idInfoTree, $g_idGetInfoBtn, $g_idLog, $g_idClear, $g_idExit
Global $g_bConnected = False

; Create user interface
Func CreateInterface()
    $g_hGUI = GUICreate("GwNexus - Guild Info Explorer", 800, 600)

    ; Connection section
    GUICtrlCreateGroup("Connection", 10, 10, 780, 60)
    GUICtrlCreateLabel("Character name for GwNexus_Initialize:", 20, 30, 250, 20)
    $g_idCharInput = GUICtrlCreateInput("", 270, 30, 400, 20)
    $g_idConnectBtn = GUICtrlCreateButton("Connect", 680, 30, 100, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Guild info navigation section
    GUICtrlCreateGroup("Guild Information", 10, 80, 250, 470)
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

    ; Populate the tree view with guild info options
    PopulateInfoTree()

    ; Disable guild info controls until connected
    GUICtrlSetState($g_idInfoTree, $GUI_DISABLE)
    GUICtrlSetState($g_idGetInfoBtn, $GUI_DISABLE)

    ; Display the interface
    GUISetState(@SW_SHOW, $g_hGUI)
EndFunc

; Populate the tree view with guild info options
Func PopulateInfoTree()
    ; Player Guild Info
    Local $hPlayerGuild = GUICtrlCreateTreeViewItem("Player Guild Information", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Player Name", $hPlayerGuild)
    GUICtrlCreateTreeViewItem("Player Guild Index", $hPlayerGuild)
    GUICtrlCreateTreeViewItem("Player Guild Key", $hPlayerGuild)
    GUICtrlCreateTreeViewItem("Announcement", $hPlayerGuild)
    GUICtrlCreateTreeViewItem("Announcement Author", $hPlayerGuild)
    GUICtrlCreateTreeViewItem("Player Guild Rank", $hPlayerGuild)
    GUICtrlCreateTreeViewItem("Kurzick Town Count", $hPlayerGuild)
    GUICtrlCreateTreeViewItem("Luxon Town Count", $hPlayerGuild)
    GUICtrlCreateTreeViewItem("All Guild Info", $hPlayerGuild)

    ; Guilds Info
    Local $hGuilds = GUICtrlCreateTreeViewItem("Guilds Information", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hGuilds)
    GUICtrlCreateTreeViewItem("By Index", $hGuilds)
    GUICtrlCreateTreeViewItem("By Key", $hGuilds)
    GUICtrlCreateTreeViewItem("All Guilds", $hGuilds)

    ; Guild History
    Local $hHistory = GUICtrlCreateTreeViewItem("Guild History", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hHistory)
    GUICtrlCreateTreeViewItem("By Index", $hHistory)
    GUICtrlCreateTreeViewItem("All History", $hHistory)

    ; Guild Roster
    Local $hRoster = GUICtrlCreateTreeViewItem("Guild Roster", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hRoster)
    GUICtrlCreateTreeViewItem("By Index", $hRoster)
    GUICtrlCreateTreeViewItem("By Name", $hRoster)
    GUICtrlCreateTreeViewItem("All Roster", $hRoster)

    ; Town Alliance
    Local $hTownAlliance = GUICtrlCreateTreeViewItem("Town Alliance", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hTownAlliance)
    GUICtrlCreateTreeViewItem("By Index", $hTownAlliance)
    GUICtrlCreateTreeViewItem("All Town Alliances", $hTownAlliance)

    ; Expand player guild info by default
    GUICtrlSetState($hPlayerGuild, $GUI_EXPAND)
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

        ; Enable guild info controls
        GUICtrlSetState($g_idInfoTree, $GUI_ENABLE)
        GUICtrlSetState($g_idGetInfoBtn, $GUI_ENABLE)

        ; Disable the connect button
        GUICtrlSetState($g_idConnectBtn, $GUI_DISABLE)
        ; Disable the input field
        GUICtrlSetState($g_idCharInput, $GUI_DISABLE)

        Return True
    EndIf
EndFunc

; Get guild information based on the selected item in the tree
Func GetSelectedGuildInfo()
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

    LogWrite("Retrieving guild information: " & $parentText & " > " & $itemText)

    ; Player Guild Information
    If $parentText = "Player Guild Information" Then
        Switch $itemText
            Case "Player Name"
                Local $result = _GuildInfo_PlayerName()
                If @error Then
                    LogWrite("Error retrieving player name.")
                Else
                    LogWrite("Player Name: " & $result)
                EndIf

            Case "Player Guild Index"
                Local $result = _GuildInfo_PlayerGuildIndex()
                If @error Then
                    LogWrite("Error retrieving player guild index.")
                Else
                    LogWrite("Player Guild Index: " & $result)
                EndIf

            Case "Player Guild Key"
                Local $result = _GuildInfo_PlayerGuildKey()
                If @error Then
                    LogWrite("Error retrieving player guild key.")
                Else
                    LogWrite("Player Guild Key: [" & $result[0] & ", " & $result[1] & ", " & $result[2] & ", " & $result[3] & "]")
                EndIf

            Case "Announcement"
                Local $result = _GuildInfo_Announcement()
                If @error Then
                    LogWrite("Error retrieving guild announcement.")
                Else
                    LogWrite("Guild Announcement: " & $result)
                EndIf

            Case "Announcement Author"
                Local $result = _GuildInfo_AnnouncementAuthor()
                If @error Then
                    LogWrite("Error retrieving announcement author.")
                Else
                    LogWrite("Announcement Author: " & $result)
                EndIf

            Case "Player Guild Rank"
                Local $result = _GuildInfo_PlayerGuildRank()
                If @error Then
                    LogWrite("Error retrieving player guild rank.")
                Else
                    LogWrite("Player Guild Rank: " & $result)
                EndIf

            Case "Kurzick Town Count"
                Local $result = _GuildInfo_KurzickTownCount()
                If @error Then
                    LogWrite("Error retrieving Kurzick town count.")
                Else
                    LogWrite("Kurzick Town Count: " & $result)
                EndIf

            Case "Luxon Town Count"
                Local $result = _GuildInfo_LuxonTownCount()
                If @error Then
                    LogWrite("Error retrieving Luxon town count.")
                Else
                    LogWrite("Luxon Town Count: " & $result)
                EndIf

			Case "All Guild Info"
				Local $result = _GuildInfo_All()
				If @error Then
					LogWrite("Error retrieving all guild information.")
				Else
					LogWrite("All Guild Information:")
					LogWrite("  Player Name: " & $result[0])
					LogWrite("  Player Guild Index: " & $result[1])
					Local $guildKey = $result[2]
					LogWrite("  Player Guild Key: [" & $guildKey[0] & ", " & $guildKey[1] & ", " & $guildKey[2] & ", " & $guildKey[3] & "]")
					LogWrite("  Guild Announcement: " & $result[3])
					LogWrite("  Announcement Author: " & $result[4])
					LogWrite("  Player Guild Rank: " & $result[5])
					LogWrite("  Kurzick Town Count: " & $result[6])
					LogWrite("  Luxon Town Count: " & $result[7])
				EndIf
        EndSwitch

    ; Guilds Information
    ElseIf $parentText = "Guilds Information" Then
        Switch $itemText
            Case "Count"
                Local $result = _GuildsInfo_Count()
                If @error Then
                    LogWrite("Error retrieving guilds count.")
                Else
                    LogWrite("Guilds Count: " & $result)
                EndIf

            Case "By Index"
                Local $index = InputBox("Guild Index", "Enter the index of the guild to retrieve (0-based):", "0")
                If @error Then Return

                Local $result = _GuildsInfo_ByIndex(Number($index))
                If @error Then
                    LogWrite("Error retrieving guild at index " & $index & ".")
                Else
                    DisplayGuildDetails($result)
                EndIf

            Case "By Key"
                Local $key1 = InputBox("Guild Key", "Enter the first component of the guild key:", "0")
                If @error Then Return
                Local $key2 = InputBox("Guild Key", "Enter the second component of the guild key:", "0")
                If @error Then Return
                Local $key3 = InputBox("Guild Key", "Enter the third component of the guild key:", "0")
                If @error Then Return
                Local $key4 = InputBox("Guild Key", "Enter the fourth component of the guild key:", "0")
                If @error Then Return

                Local $result = _GuildsInfo_ByKey(Number($key1), Number($key2), Number($key3), Number($key4))
                If @error Then
                    LogWrite("Error retrieving guild with specified key.")
                Else
                    DisplayGuildDetails($result)
                EndIf

            Case "All Guilds"
				Local $result = _GuildsInfo_All()
				If @error Then
					LogWrite("Error retrieving all guilds.")
				Else
					LogWrite("All Guilds:")
					Local $guildCount = $result[0][0]
					LogWrite("  Total Count: " & $guildCount)

					For $i = 1 To $guildCount
						LogWrite("  Guild " & ($i-1) & ":")
						DisplayGuildDetails($result[$i], "    ")
					Next
				EndIf
        EndSwitch

    ; Guild History
    ElseIf $parentText = "Guild History" Then
        Switch $itemText
            Case "Count"
                Local $result = _GuildHistory_Count()
                If @error Then
                    LogWrite("Error retrieving guild history count.")
                Else
                    LogWrite("Guild History Events Count: " & $result)
                EndIf

            Case "By Index"
                Local $index = InputBox("History Event Index", "Enter the index of the history event to retrieve (0-based):", "0")
                If @error Then Return

                Local $result = _GuildHistory_ByIndex(Number($index))
                If @error Then
                    LogWrite("Error retrieving history event at index " & $index & ".")
                Else
                    LogWrite("Guild History Event at index " & $index & ":")
                    LogWrite("  Time1: " & $result[0])
                    LogWrite("  Time2: " & $result[1])
                    LogWrite("  Name: " & $result[2])
                EndIf

            Case "All History"
				Local $result = _GuildHistory_All()
				If @error Then
					LogWrite("Error retrieving all guild history.")
				Else
					LogWrite("All Guild History:")
					Local $eventCount = $result[0][0]
					LogWrite("  Total Events: " & $eventCount)

					For $i = 1 To $eventCount
						LogWrite("  Event " & ($i-1) & ":")
						LogWrite("    Time1: " & $result[$i][0])
						LogWrite("    Time2: " & $result[$i][1])
						LogWrite("    Name: " & $result[$i][2])
					Next
				EndIf
        EndSwitch

    ; Guild Roster
    ElseIf $parentText = "Guild Roster" Then
        Switch $itemText
            Case "Count"
                Local $result = _GuildRoster_Count()
                If @error Then
                    LogWrite("Error retrieving guild roster count.")
                Else
                    LogWrite("Guild Roster Members Count: " & $result)
                EndIf

            Case "By Index"
                Local $index = InputBox("Roster Member Index", "Enter the index of the roster member to retrieve (0-based):", "0")
                If @error Then Return

                Local $result = _GuildRoster_ByIndex(Number($index))
                If @error Then
                    LogWrite("Error retrieving roster member at index " & $index & ".")
                Else
                    DisplayRosterMemberDetails($result)
                EndIf

            Case "By Name"
                Local $name = InputBox("Member Name", "Enter the name of the guild member:", "")
                If @error Then Return

                Local $result = _GuildRoster_ByName($name)
                If @error Then
                    LogWrite("Error retrieving roster member with name " & $name & ".")
                Else
                    DisplayRosterMemberDetails($result)
                EndIf

			Case "All Roster"
				Local $result = _GuildRoster_All()
				If @error Then
					LogWrite("Error retrieving all guild roster.")
				Else
					LogWrite("All Guild Roster:")
					Local $memberCount = $result[0][0]
					LogWrite("  Total Members: " & $memberCount)

					For $i = 1 To $memberCount
						LogWrite("  Member " & ($i-1) & ":")
						DisplayRosterMemberDetails($result[$i], "    ")
					Next
				EndIf
        EndSwitch

    ; Town Alliance
    ElseIf $parentText = "Town Alliance" Then
        Switch $itemText
            Case "Count"
                Local $result = _TownAlliance_Count()
                If @error Then
                    LogWrite("Error retrieving town alliance count.")
                Else
                    LogWrite("Town Alliance Count: " & $result)
                EndIf

            Case "By Index"
                Local $index = InputBox("Town Alliance Index", "Enter the index of the town alliance to retrieve (0-based):", "0")
                If @error Then Return

                Local $result = _TownAlliance_ByIndex(Number($index))
                If @error Then
                    LogWrite("Error retrieving town alliance at index " & $index & ".")
                Else
                    DisplayTownAllianceDetails($result)
                EndIf

            Case "All Town Alliances"
                Local $result = _TownAlliance_All()
                If @error Then
                    LogWrite("Error retrieving all town alliances.")
                Else
                    LogWrite("All Town Alliances:")
                    Local $allianceCount = $result[0]
                    LogWrite("  Total Alliances: " & $allianceCount)

                    For $i = 0 To $allianceCount - 1
                        LogWrite("  Alliance " & $i & ":")
                        DisplayTownAllianceDetails($result[$i+1], "    ")
                    Next
                EndIf
        EndSwitch
    EndIf
EndFunc

; Helper function to display guild details
Func DisplayGuildDetails($guild, $indent = "  ")
    LogWrite($indent & "Guild Key: [" & $guild[0][0] & ", " & $guild[0][1] & ", " & $guild[0][2] & ", " & $guild[0][3] & "]")
    LogWrite($indent & "Index: " & $guild[1])
    LogWrite($indent & "Rank: " & $guild[2])
    LogWrite($indent & "Features: " & $guild[3])
    LogWrite($indent & "Name: " & $guild[4])
    LogWrite($indent & "Rating: " & $guild[5])
    LogWrite($indent & "Faction: " & $guild[6])
    LogWrite($indent & "Faction Points: " & $guild[7])
    LogWrite($indent & "Qualifier Points: " & $guild[8])
    LogWrite($indent & "Tag: " & $guild[9])
    LogWrite($indent & "Cape BG Color: " & $guild[10])
    LogWrite($indent & "Cape Detail Color: " & $guild[11])
    LogWrite($indent & "Cape Emblem Color: " & $guild[12])
    LogWrite($indent & "Cape Shape: " & $guild[13])
    LogWrite($indent & "Cape Detail: " & $guild[14])
    LogWrite($indent & "Cape Emblem: " & $guild[15])
    LogWrite($indent & "Cape Trim: " & $guild[16])
EndFunc

; Helper function to display roster member details
Func DisplayRosterMemberDetails($member, $indent = "  ")
    LogWrite($indent & "Invited Name: " & $member[0])
    LogWrite($indent & "Current Name: " & $member[1])
    LogWrite($indent & "Inviter Name: " & $member[2])
    LogWrite($indent & "Invite Time: " & $member[3])
    LogWrite($indent & "Promoter Name: " & $member[4])
    LogWrite($indent & "Offline: " & $member[5])
    LogWrite($indent & "Member Type: " & $member[6])
    LogWrite($indent & "Status: " & $member[7])
EndFunc

; Helper function to display town alliance details
Func DisplayTownAllianceDetails($alliance, $indent = "  ")
    LogWrite($indent & "Rank: " & $alliance[0])
    LogWrite($indent & "Allegiance: " & $alliance[1])
    LogWrite($indent & "Faction: " & $alliance[2])
    LogWrite($indent & "Name: " & $alliance[3])
    LogWrite($indent & "Tag: " & $alliance[4])
    LogWrite($indent & "Cape BG Color: " & $alliance[5])
    LogWrite($indent & "Cape Detail Color: " & $alliance[6])
    LogWrite($indent & "Cape Emblem Color: " & $alliance[7])
    LogWrite($indent & "Cape Shape: " & $alliance[8])
    LogWrite($indent & "Cape Detail: " & $alliance[9])
    LogWrite($indent & "Cape Emblem: " & $alliance[10])
    LogWrite($indent & "Cape Trim: " & $alliance[11])
    LogWrite($indent & "Map ID: " & $alliance[12])
EndFunc

; Main function
Func Main()
    ; Create the interface
    CreateInterface()

    LogWrite("Welcome to the Guild Info Explorer!")
    LogWrite("Please enter the character name and click 'Connect'.")

    ; Event handling loop
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $g_idExit
                ExitLoop

            Case $g_idConnectBtn
                ConnectToGwNexus()

            Case $g_idGetInfoBtn
                GetSelectedGuildInfo()

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