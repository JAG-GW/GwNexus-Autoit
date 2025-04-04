#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <TreeViewConstants.au3>
#include <GuiTreeView.au3>
#include "../Base.au3"
#include "../Queries/AgentCtxInfo.au3"
#include "../Queries/CharacterCtxInfo.au3"

; Global variables
Global $g_hGUI, $g_idCharInput, $g_idConnectBtn, $g_idInfoTree, $g_idAgentIDInput, $g_idIndexInput
Global $g_idGetInfoBtn, $g_idGetSummaryBtn, $g_idGetMovementBtn, $g_idLog, $g_idClear, $g_idExit
Global $g_bConnected = False

; Create user interface
Func CreateInterface()
    $g_hGUI = GUICreate("GwNexus - Agent Context Info Explorer", 950, 650)

    ; Connection section
    GUICtrlCreateGroup("Connection", 10, 10, 930, 60)
    GUICtrlCreateLabel("Character name for GwNexus_Initialize:", 20, 30, 250, 20)
    $g_idCharInput = GUICtrlCreateInput("", 270, 30, 550, 20)
    $g_idConnectBtn = GUICtrlCreateButton("Connect", 830, 30, 100, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Agent Context info navigation section
    GUICtrlCreateGroup("Agent Context Information", 10, 80, 300, 520)
    $g_idInfoTree = GUICtrlCreateTreeView(20, 100, 280, 450, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_SHOWSELALWAYS))

    ; Input fields for agent ID and index
    GUICtrlCreateLabel("Agent ID:", 20, 555, 80, 20)
    $g_idAgentIDInput = GUICtrlCreateInput("0", 100, 555, 80, 20)
    GUICtrlCreateLabel("Index:", 20, 580, 80, 20)
    $g_idIndexInput = GUICtrlCreateInput("0", 100, 580, 80, 20)

    ; Buttons for queries
    $g_idGetInfoBtn = GUICtrlCreateButton("Get Selected Info", 190, 555, 110, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Results section
    GUICtrlCreateLabel("Results:", 320, 80, 100, 20)
    $g_idLog = GUICtrlCreateEdit("", 320, 100, 620, 500, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL))
    GUICtrlSetFont($g_idLog, 9, 400, 0, "Consolas") ; Fixed-width font for the log

    ; Bottom buttons
    $g_idGetSummaryBtn = GUICtrlCreateButton("Get Agent Summary Info", 320, 610, 150, 30)
    $g_idGetMovementBtn = GUICtrlCreateButton("Get Agent Movement Info", 480, 610, 150, 30)
    $g_idClear = GUICtrlCreateButton("Clear Log", 640, 610, 150, 30)
    $g_idExit = GUICtrlCreateButton("Exit", 800, 610, 140, 30)

    ; Populate the tree view with agent context info options
    PopulateAgentCtxInfoTree()

    ; Disable agent context info controls until connected
    GUICtrlSetState($g_idInfoTree, $GUI_DISABLE)
    GUICtrlSetState($g_idAgentIDInput, $GUI_DISABLE)
    GUICtrlSetState($g_idIndexInput, $GUI_DISABLE)
    GUICtrlSetState($g_idGetInfoBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idGetSummaryBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idGetMovementBtn, $GUI_DISABLE)

    ; Display the interface
    GUISetState(@SW_SHOW, $g_hGUI)
EndFunc

; Populate the tree view with agent context info options
Func PopulateAgentCtxInfoTree()
    ; Main agent context info categories
    Local $hAgentCtxInfo = GUICtrlCreateTreeViewItem("Agent Context Info", $g_idInfoTree)
    Local $hAgentSummaryInfo = GUICtrlCreateTreeViewItem("Agent Summary Info", $g_idInfoTree)
    Local $hAgentMovementInfo = GUICtrlCreateTreeViewItem("Agent Movement Info", $g_idInfoTree)

    ; Agent context info items
    GUICtrlCreateTreeViewItem("Instance Timer", $hAgentCtxInfo)
    GUICtrlCreateTreeViewItem("Random Values", $hAgentCtxInfo)
    GUICtrlCreateTreeViewItem("Agent Summary Info Count", $hAgentCtxInfo)
    GUICtrlCreateTreeViewItem("Agent Movement Count", $hAgentCtxInfo)
    GUICtrlCreateTreeViewItem("Agent Array1 Count", $hAgentCtxInfo)
    GUICtrlCreateTreeViewItem("Agent Async Movement Count", $hAgentCtxInfo)
    GUICtrlCreateTreeViewItem("All Counts", $hAgentCtxInfo)
    GUICtrlCreateTreeViewItem("All Context Info", $hAgentCtxInfo)

    ; Agent summary info items
    GUICtrlCreateTreeViewItem("Count", $hAgentSummaryInfo)
    GUICtrlCreateTreeViewItem("By Index", $hAgentSummaryInfo)
    GUICtrlCreateTreeViewItem("By Composite ID", $hAgentSummaryInfo)
    GUICtrlCreateTreeViewItem("All Summary Info", $hAgentSummaryInfo)

    ; Agent movement info items
    GUICtrlCreateTreeViewItem("Count", $hAgentMovementInfo)
    GUICtrlCreateTreeViewItem("By Index", $hAgentMovementInfo)
    GUICtrlCreateTreeViewItem("By Agent ID", $hAgentMovementInfo)
    GUICtrlCreateTreeViewItem("All Movement Info", $hAgentMovementInfo)

    ; Expand all categories by default
    GUICtrlSetState($hAgentCtxInfo, $GUI_EXPAND)
    GUICtrlSetState($hAgentSummaryInfo, $GUI_EXPAND)
    GUICtrlSetState($hAgentMovementInfo, $GUI_EXPAND)
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
    Local $result = GwNexus_Initialize($charName)

    If @error Then
        LogWrite("Error: Unable to connect to GwNexus.")
        Return False
    Else
        LogWrite("Connection to GwNexus established successfully.")
        $g_bConnected = True

        ; Enable agent context info controls
        GUICtrlSetState($g_idInfoTree, $GUI_ENABLE)
        GUICtrlSetState($g_idAgentIDInput, $GUI_ENABLE)
        GUICtrlSetState($g_idIndexInput, $GUI_ENABLE)
        GUICtrlSetState($g_idGetInfoBtn, $GUI_ENABLE)
        GUICtrlSetState($g_idGetSummaryBtn, $GUI_ENABLE)
        GUICtrlSetState($g_idGetMovementBtn, $GUI_ENABLE)

        ; Disable the connect button
        GUICtrlSetState($g_idConnectBtn, $GUI_DISABLE)
        ; Disable the input field
        GUICtrlSetState($g_idCharInput, $GUI_DISABLE)

        Return True
    EndIf
EndFunc

; Get agent context information based on the selected item in the tree
Func GetSelectedAgentCtxInfo()
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

    LogWrite("Retrieving agent context information: " & $parentText & " > " & $itemText)

    ; Process based on parent category
    Switch $parentText
        Case "Agent Context Info"
            GetAgentCtxInfo($itemText)

        Case "Agent Summary Info"
            GetAgentSummaryInfo($itemText)

        Case "Agent Movement Info"
            GetAgentMovementInfo($itemText)

        Case Else
            LogWrite("Error: Unknown information category.")
    EndSwitch
EndFunc

; Functions to retrieve specific agent context information
Func GetAgentCtxInfo($itemText)
    Switch $itemText
        Case "Instance Timer"
            Local $result = _AgentCtx_InstanceTimer()
            If @error Then
                LogWrite("Error retrieving instance timer.")
            Else
                LogWrite("Instance Timer: " & $result)
            EndIf

        Case "Random Values"
            Local $result = _AgentCtx_RandomValues()
            If @error Then
                LogWrite("Error retrieving random values.")
            Else
                LogWrite("Random Values: Rand1=" & $result[0] & ", Rand2=" & $result[1])
            EndIf

        Case "Agent Summary Info Count"
            Local $result = _AgentCtx_AgentSummaryInfoCount()
            If @error Then
                LogWrite("Error retrieving agent summary info count.")
            Else
                LogWrite("Agent Summary Info Count: " & $result)
            EndIf

        Case "Agent Movement Count"
            Local $result = _AgentCtx_AgentMovementCount()
            If @error Then
                LogWrite("Error retrieving agent movement count.")
            Else
                LogWrite("Agent Movement Count: " & $result)
            EndIf

        Case "Agent Array1 Count"
            Local $result = _AgentCtx_AgentArray1Count()
            If @error Then
                LogWrite("Error retrieving agent array1 count.")
            Else
                LogWrite("Agent Array1 Count: " & $result)
            EndIf

        Case "Agent Async Movement Count"
            Local $result = _AgentCtx_AgentAsyncMovementCount()
            If @error Then
                LogWrite("Error retrieving agent async movement count.")
            Else
                LogWrite("Agent Async Movement Count: " & $result)
            EndIf

        Case "All Counts"
            Local $result = _AgentCtx_AllCounts()
            If @error Then
                LogWrite("Error retrieving all agent counts.")
            Else
                LogWrite("All Agent Counts:")
                LogWrite("  Agent Summary Info Count: " & $result[0])
                LogWrite("  Agent Movement Count: " & $result[1])
                LogWrite("  Agent Array1 Count: " & $result[2])
                LogWrite("  Agent Async Movement Count: " & $result[3])
            EndIf

        Case "All Context Info"
            Local $result = _AgentCtx_All()
            If @error Then
                LogWrite("Error retrieving all agent context info.")
            Else
                LogWrite("All Agent Context Info:")
                LogWrite("  Instance Timer: " & $result[0])
                LogWrite("  Random Value 1: " & $result[1])
                LogWrite("  Random Value 2: " & $result[2])
                LogWrite("  Agent Summary Info Count: " & $result[3])
                LogWrite("  Agent Movement Count: " & $result[4])
                LogWrite("  Agent Array1 Count: " & $result[5])
                LogWrite("  Agent Async Movement Count: " & $result[6])
            EndIf
    EndSwitch
EndFunc

; Functions to retrieve agent summary information
Func GetAgentSummaryInfo($itemText)
    Local $index = Number(GUICtrlRead($g_idIndexInput))
    Local $compositeId = Number(GUICtrlRead($g_idAgentIDInput))

    Switch $itemText
        Case "Count"
            Local $result = _AgentSummary_Count()
            If @error Then
                LogWrite("Error retrieving agent summary count.")
            Else
                LogWrite("Agent Summary Count: " & $result)
            EndIf

        Case "By Index"
            Local $result = _AgentSummary_ByIndex($index)
            If @error Then
                LogWrite("Error retrieving agent summary at index " & $index & ".")
            Else
                LogWrite("Agent Summary at index " & $index & ":")
                LogWrite("  h0000: " & $result[0])
                LogWrite("  h0004: " & $result[1])
                LogWrite("  sub.h0000: " & $result[2])
                LogWrite("  sub.h0004: " & $result[3])
                LogWrite("  sub.gadget_id: " & $result[4])
                LogWrite("  sub.h000C: " & $result[5])
                LogWrite("  gadget_name: " & $result[6])
                LogWrite("  sub.h0014: " & $result[7])
                LogWrite("  sub.composite_agent_id: " & $result[8])
            EndIf

        Case "By Composite ID"
            Local $result = _AgentSummary_ByCompositeId($compositeId)
            If @error Then
                LogWrite("Error retrieving agent summary with composite ID " & $compositeId & ".")
            Else
                LogWrite("Agent Summary with composite ID " & $compositeId & ":")
                LogWrite("  h0000: " & $result[0])
                LogWrite("  h0004: " & $result[1])
                LogWrite("  sub.h0000: " & $result[2])
                LogWrite("  sub.h0004: " & $result[3])
                LogWrite("  sub.gadget_id: " & $result[4])
                LogWrite("  sub.h000C: " & $result[5])
                LogWrite("  gadget_name: " & $result[6])
                LogWrite("  sub.h0014: " & $result[7])
                LogWrite("  sub.composite_agent_id: " & $result[8])
            EndIf

        Case "All Summary Info"
            Local $result = _AgentSummary_All()
            If @error Then
                LogWrite("Error retrieving all agent summary info.")
            Else
                LogWrite("All Agent Summary Info (Total: " & $result[0] & "):")

                Local $displayCount = _Min($result[0], 5)
                LogWrite("Displaying first " & $displayCount & " entries:")

                For $i = 1 To $displayCount
                    Local $info = $result[$i]
                    LogWrite("  --- Agent Summary " & ($i-1) & " ---")
                    LogWrite("    h0000: " & $info[0])
                    LogWrite("    h0004: " & $info[1])
                    LogWrite("    sub.h0000: " & $info[2])
                    LogWrite("    sub.h0004: " & $info[3])
                    LogWrite("    sub.gadget_id: " & $info[4])
                    LogWrite("    sub.h000C: " & $info[5])
                    LogWrite("    gadget_name: " & $info[6])
                    LogWrite("    sub.h0014: " & $info[7])
                    LogWrite("    sub.composite_agent_id: " & $info[8])
                Next

                If $result[0] > $displayCount Then
                    LogWrite("  ... and " & ($result[0] - $displayCount) & " more entries.")
                EndIf
            EndIf
    EndSwitch
EndFunc

; Functions to retrieve agent movement information
Func GetAgentMovementInfo($itemText)
    Local $index = Number(GUICtrlRead($g_idIndexInput))
    Local $agentId = Number(GUICtrlRead($g_idAgentIDInput))

    Switch $itemText
        Case "Count"
            Local $result = _AgentMovement_Count()
            If @error Then
                LogWrite("Error retrieving agent movement count.")
            Else
                LogWrite("Agent Movement Count: " & $result)
            EndIf

        Case "By Index"
            Local $result = _AgentMovement_ByIndex($index)
            If @error Then
                LogWrite("Error retrieving agent movement at index " & $index & ".")
            Else
                LogWrite("Agent Movement at index " & $index & ":")
                DisplayMovementInfo($result)
            EndIf

        Case "By Agent ID"
            Local $result = _AgentMovement_ByAgentId($agentId)
            If @error Then
                LogWrite("Error retrieving agent movement with agent ID " & $agentId & ".")
            Else
                LogWrite("Agent Movement with agent ID " & $agentId & ":")
                DisplayMovementInfo($result)
            EndIf

        Case "All Movement Info"
            Local $result = _AgentMovement_All()
            If @error Then
                LogWrite("Error retrieving all agent movement info.")
            Else
                LogWrite("All Agent Movement Info (Total: " & $result[0] & "):")

                Local $displayCount = _Min($result[0], 2)
                LogWrite("Displaying first " & $displayCount & " entries:")

                For $i = 1 To $displayCount
                    Local $info = $result[$i]
                    LogWrite("  --- Agent Movement " & ($i-1) & " ---")
                    LogWrite("    Agent ID: " & $info[3])
                    LogWrite("    Position: X=" & $info[25] & ", Y=" & $info[26] & ", Z=" & $info[27])
                    LogWrite("    Moving1: " & $info[14] & ", Moving2: " & $info[17])
                    LogWrite("    Position2: X=" & $info[29] & ", Y=" & $info[30] & ", Z=" & $info[31])
                Next

                If $result[0] > $displayCount Then
                    LogWrite("  ... and " & ($result[0] - $displayCount) & " more entries.")
                EndIf
            EndIf
    EndSwitch
EndFunc

; Helper function to display movement info details
Func DisplayMovementInfo($info)
    LogWrite("  h0000: [" & $info[0] & ", " & $info[1] & ", " & $info[2] & "]")
    LogWrite("  agent_id: " & $info[3])
    LogWrite("  h0010: [" & $info[4] & ", " & $info[5] & ", " & $info[6] & "]")
    LogWrite("  agentDef: " & $info[7])
    LogWrite("  h0020: [" & $info[8] & ", " & $info[9] & ", " & $info[10] & ", " & $info[11] & ", " & $info[12] & ", " & $info[13] & "]")
    LogWrite("  moving1: " & $info[14])
    LogWrite("  h003C: [" & $info[15] & ", " & $info[16] & "]")
    LogWrite("  moving2: " & $info[17])
    LogWrite("  h0048: [" & $info[18] & ", " & $info[19] & ", " & $info[20] & ", " & $info[21] & ", " & $info[22] & ", " & $info[23] & ", " & $info[24] & "]")
    LogWrite("  h0064 (Position): X=" & $info[25] & ", Y=" & $info[26] & ", Z=" & $info[27])
    LogWrite("  h0070: " & $info[28])
    LogWrite("  h0074 (Position2): X=" & $info[29] & ", Y=" & $info[30] & ", Z=" & $info[31])
EndFunc

; Function to get all agent summary information at once
Func GetAllAgentSummaryInfo()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    LogWrite("Retrieving all agent summary information...")
    Local $startTime = TimerInit()

    Local $result = _AgentSummary_All()
    If @error Then
        LogWrite("Error retrieving agent summary information.")
        Return
    EndIf

    Local $count = $result[0]
    LogWrite("Found " & $count & " agent summary entries.")

    If $count > 0 Then
        LogWrite("Displaying details for first 10 entries (or less if fewer exist):")
        Local $displayCount = _Min($count, 10)

        For $i = 1 To $displayCount
            Local $info = $result[$i]

            LogWrite("--- Agent Summary " & ($i-1) & " ---")
            LogWrite("  Gadget ID: " & $info[4])

            If $info[6] <> "" Then
                LogWrite("  Gadget Name: " & $info[6])
            EndIf

            LogWrite("  Composite Agent ID: " & $info[8])
        Next
    EndIf

    Local $elapsedTime = TimerDiff($startTime)
    LogWrite("Retrieved in " & Round($elapsedTime / 1000, 2) & " seconds.")
EndFunc

; Function to get all agent movement information at once
Func GetAllAgentMovementInfo()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    LogWrite("Retrieving all agent movement information...")
    Local $startTime = TimerInit()

    Local $result = _AgentMovement_All()
    If @error Then
        LogWrite("Error retrieving agent movement information.")
        Return
    EndIf

    Local $count = $result[0]
    LogWrite("Found " & $count & " agent movement entries.")

    If $count > 0 Then
        LogWrite("Displaying details for first 10 entries (or less if fewer exist):")
        Local $displayCount = _Min($count, 10)

        For $i = 1 To $displayCount
            Local $info = $result[$i]

            LogWrite("--- Agent Movement " & ($i-1) & " ---")
            LogWrite("  Agent ID: " & $info[3])
            LogWrite("  Position: X=" & Round($info[25], 1) & ", Y=" & Round($info[26], 1) & ", Z=" & Round($info[27], 1))
            LogWrite("  Moving: " & $info[14] & ", " & $info[17])
        Next
    EndIf

    Local $elapsedTime = TimerDiff($startTime)
    LogWrite("Retrieved in " & Round($elapsedTime / 1000, 2) & " seconds.")
EndFunc

; Main function
Func Main()
    ; Create the interface
    CreateInterface()

    LogWrite("Welcome to the Agent Context Info Explorer!")
    LogWrite("Please enter the character name and click 'Connect'.")

    ; Event handling loop
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $g_idExit
                ExitLoop

            Case $g_idConnectBtn
                ConnectToGwNexus()

            Case $g_idGetInfoBtn
                GetSelectedAgentCtxInfo()

            Case $g_idGetSummaryBtn
                GetAllAgentSummaryInfo()

            Case $g_idGetMovementBtn
                GetAllAgentMovementInfo()

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