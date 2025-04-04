#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <TreeViewConstants.au3>
#include <GuiTreeView.au3>
#include "../Base.au3"
#include "../Queries/PartyInfo.au3"
#include "../Queries/CharacterCtxInfo.au3"

; Global variables
Global $g_hGUI, $g_idCharInput, $g_idConnectBtn, $g_idInfoTree, $g_idAgentIDInput, $g_idIndexInput
Global $g_idGetInfoBtn, $g_idGetPartyOverviewBtn, $g_idGetMembersBtn, $g_idGetHeroesBtn, $g_idGetSkillbarsBtn, $g_idLog, $g_idClear, $g_idExit
Global $g_bConnected = False

; Create user interface
Func CreateInterface()
    $g_hGUI = GUICreate("GwNexus - Party Info Explorer", 950, 650)

    ; Connection section
    GUICtrlCreateGroup("Connection", 10, 10, 930, 60)
    GUICtrlCreateLabel("Character name for GwNexus_Initialize:", 20, 30, 250, 20)
    $g_idCharInput = GUICtrlCreateInput("", 270, 30, 550, 20)
    $g_idConnectBtn = GUICtrlCreateButton("Connect", 830, 30, 100, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Party info navigation section
    GUICtrlCreateGroup("Party Information", 10, 80, 320, 520)
    $g_idInfoTree = GUICtrlCreateTreeView(20, 100, 300, 450, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_SHOWSELALWAYS))

    ; Input fields for agent ID and index
    GUICtrlCreateLabel("Agent ID / Index:", 20, 555, 100, 20)
    $g_idAgentIDInput = GUICtrlCreateInput("", 120, 555, 80, 20)
    GUICtrlCreateLabel("Secondary Index:", 20, 580, 100, 20)
    $g_idIndexInput = GUICtrlCreateInput("0", 120, 580, 80, 20)

    ; Buttons for queries
    $g_idGetInfoBtn = GUICtrlCreateButton("Get Selected Info", 210, 555, 110, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Results section
    GUICtrlCreateLabel("Results:", 340, 80, 100, 20)
    $g_idLog = GUICtrlCreateEdit("", 340, 100, 600, 500, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL))
    GUICtrlSetFont($g_idLog, 9, 400, 0, "Consolas") ; Fixed-width font for the log

    ; Bottom buttons
    $g_idGetPartyOverviewBtn = GUICtrlCreateButton("Party Overview", 340, 610, 120, 30)
    $g_idGetMembersBtn = GUICtrlCreateButton("Party Members", 470, 610, 120, 30)
    $g_idGetHeroesBtn = GUICtrlCreateButton("Heroes & Flags", 600, 610, 120, 30)
    $g_idGetSkillbarsBtn = GUICtrlCreateButton("Skillbars", 730, 610, 120, 30)
    $g_idClear = GUICtrlCreateButton("Clear Log", 10, 610, 100, 30)
    $g_idExit = GUICtrlCreateButton("Exit", 120, 610, 90, 30)

    ; Populate the tree view with party info options
    PopulatePartyInfoTree()

    ; Disable party info controls until connected
    GUICtrlSetState($g_idInfoTree, $GUI_DISABLE)
    GUICtrlSetState($g_idAgentIDInput, $GUI_DISABLE)
    GUICtrlSetState($g_idIndexInput, $GUI_DISABLE)
    GUICtrlSetState($g_idGetInfoBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idGetPartyOverviewBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idGetMembersBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idGetHeroesBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idGetSkillbarsBtn, $GUI_DISABLE)

    ; Display the interface
    GUISetState(@SW_SHOW, $g_hGUI)
EndFunc

; Populate the tree view with party info options
Func PopulatePartyInfoTree()
    ; Basic Party Info
    Local $hBasicInfo = GUICtrlCreateTreeViewItem("Basic Party Information", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Flag", $hBasicInfo)
    GUICtrlCreateTreeViewItem("Requests Count", $hBasicInfo)
    GUICtrlCreateTreeViewItem("Sending Count", $hBasicInfo)
    GUICtrlCreateTreeViewItem("Parties Count", $hBasicInfo)
    GUICtrlCreateTreeViewItem("Player Party", $hBasicInfo)
    GUICtrlCreateTreeViewItem("Party Search Count", $hBasicInfo)
    GUICtrlCreateTreeViewItem("Party Size", $hBasicInfo)
    GUICtrlCreateTreeViewItem("Party Overview", $hBasicInfo)

    ; Party Members Info
    Local $hMembersInfo = GUICtrlCreateTreeViewItem("Party Members Information", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hMembersInfo)
    GUICtrlCreateTreeViewItem("By Index", $hMembersInfo)
    GUICtrlCreateTreeViewItem("All Members", $hMembersInfo)

    ; Party Henchmen Info
    Local $hHenchmenInfo = GUICtrlCreateTreeViewItem("Party Henchmen Information", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hHenchmenInfo)
    GUICtrlCreateTreeViewItem("By Index", $hHenchmenInfo)
    GUICtrlCreateTreeViewItem("All Henchmen", $hHenchmenInfo)

    ; Party Heroes Info
    Local $hHeroesInfo = GUICtrlCreateTreeViewItem("Party Heroes Information", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hHeroesInfo)
    GUICtrlCreateTreeViewItem("By Index", $hHeroesInfo)
    GUICtrlCreateTreeViewItem("All Heroes", $hHeroesInfo)

    ; Heroes and Flags Info
    Local $hHeroFlagsInfo = GUICtrlCreateTreeViewItem("Hero Flags Information", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hHeroFlagsInfo)
    GUICtrlCreateTreeViewItem("By Index", $hHeroFlagsInfo)
    GUICtrlCreateTreeViewItem("All Hero Flags", $hHeroFlagsInfo)

    ; Hero Info
    Local $hHeroDetailInfo = GUICtrlCreateTreeViewItem("Hero Details Information", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hHeroDetailInfo)
    GUICtrlCreateTreeViewItem("By Index", $hHeroDetailInfo)
    GUICtrlCreateTreeViewItem("All Hero Details", $hHeroDetailInfo)

    ; Party Allies Info
    Local $hAlliesInfo = GUICtrlCreateTreeViewItem("Party Allies Information", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hAlliesInfo)
    GUICtrlCreateTreeViewItem("By Index", $hAlliesInfo)
    GUICtrlCreateTreeViewItem("All Allies", $hAlliesInfo)

    ; Controlled Minions Info
    Local $hMinionsInfo = GUICtrlCreateTreeViewItem("Controlled Minions Information", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hMinionsInfo)
    GUICtrlCreateTreeViewItem("By Index", $hMinionsInfo)
    GUICtrlCreateTreeViewItem("All Minions", $hMinionsInfo)

    ; Pets Info
    Local $hPetsInfo = GUICtrlCreateTreeViewItem("Pets Information", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hPetsInfo)
    GUICtrlCreateTreeViewItem("By Index", $hPetsInfo)
    GUICtrlCreateTreeViewItem("All Pets", $hPetsInfo)

    ; Party Search Info
    Local $hSearchInfo = GUICtrlCreateTreeViewItem("Party Search Information", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hSearchInfo)
    GUICtrlCreateTreeViewItem("By Index", $hSearchInfo)
    GUICtrlCreateTreeViewItem("All Search Data", $hSearchInfo)

    ; Skillbars Info
    Local $hSkillbarsInfo = GUICtrlCreateTreeViewItem("Skillbars Information", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hSkillbarsInfo)
    GUICtrlCreateTreeViewItem("By Index", $hSkillbarsInfo)
    GUICtrlCreateTreeViewItem("By Agent ID", $hSkillbarsInfo)
    GUICtrlCreateTreeViewItem("All Skillbars", $hSkillbarsInfo)

    ; Agent Effects Info
    Local $hEffectsInfo = GUICtrlCreateTreeViewItem("Agent Effects Information", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hEffectsInfo)
    GUICtrlCreateTreeViewItem("By Index", $hEffectsInfo)
    GUICtrlCreateTreeViewItem("By Agent ID", $hEffectsInfo)
    GUICtrlCreateTreeViewItem("All Effects", $hEffectsInfo)

    ; Party Attributes Info
    Local $hAttributesInfo = GUICtrlCreateTreeViewItem("Party Attributes Information", $g_idInfoTree)
    GUICtrlCreateTreeViewItem("Count", $hAttributesInfo)
    GUICtrlCreateTreeViewItem("By Index", $hAttributesInfo)
    GUICtrlCreateTreeViewItem("By Agent ID", $hAttributesInfo)
    GUICtrlCreateTreeViewItem("All Attributes", $hAttributesInfo)

    ; Expand basic info by default
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
    Local $result = GwNexus_Initialize($charName)

    If @error Then
        LogWrite("Error: Unable to connect to GwNexus.")
        Return False
    Else
        LogWrite("Connection to GwNexus established successfully.")
        $g_bConnected = True

        ; Enable party info controls
        GUICtrlSetState($g_idInfoTree, $GUI_ENABLE)
        GUICtrlSetState($g_idAgentIDInput, $GUI_ENABLE)
        GUICtrlSetState($g_idIndexInput, $GUI_ENABLE)
        GUICtrlSetState($g_idGetInfoBtn, $GUI_ENABLE)
        GUICtrlSetState($g_idGetPartyOverviewBtn, $GUI_ENABLE)
        GUICtrlSetState($g_idGetMembersBtn, $GUI_ENABLE)
        GUICtrlSetState($g_idGetHeroesBtn, $GUI_ENABLE)
        GUICtrlSetState($g_idGetSkillbarsBtn, $GUI_ENABLE)

        ; Disable the connect button
        GUICtrlSetState($g_idConnectBtn, $GUI_DISABLE)
        ; Disable the input field
        GUICtrlSetState($g_idCharInput, $GUI_DISABLE)

        Return True
    EndIf
EndFunc

; Get party information based on the selected item in the tree
Func GetSelectedPartyInfo()
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

    LogWrite("Retrieving party information: " & $parentText & " > " & $itemText)

    ; Get agent ID or index from input field
    Local $agentID = Number(GUICtrlRead($g_idAgentIDInput))
    Local $index = Number(GUICtrlRead($g_idIndexInput))

    ; Process based on parent and selected item
    Switch $parentText
        Case "Basic Party Information"
            GetBasicPartyInfo($itemText)

        Case "Party Members Information"
            GetPartyMembersInfo($itemText, $index)

        Case "Party Henchmen Information"
            GetPartyHenchmenInfo($itemText, $index)

        Case "Party Heroes Information"
            GetPartyHeroesInfo($itemText, $index)

        Case "Hero Flags Information"
            GetHeroFlagsInfo($itemText, $index)

        Case "Hero Details Information"
            GetHeroDetailsInfo($itemText, $index)

        Case "Party Allies Information"
            GetPartyAlliesInfo($itemText, $index)

        Case "Controlled Minions Information"
            GetControlledMinionsInfo($itemText, $index)

        Case "Pets Information"
            GetPetsInfo($itemText, $index)

        Case "Party Search Information"
            GetPartySearchInfo($itemText, $index)

        Case "Skillbars Information"
            GetSkillbarsInfo($itemText, $agentID, $index)

        Case "Agent Effects Information"
            GetAgentEffectsInfo($itemText, $agentID, $index)

        Case "Party Attributes Information"
            GetPartyAttributesInfo($itemText, $agentID, $index)

        Case Else
            LogWrite("Error: Unknown information category.")
    EndSwitch
EndFunc

; Functions to retrieve specific party information
Func GetBasicPartyInfo($itemText)
    Switch $itemText
        Case "Flag"
            Local $result = _Party_Flag()
            If @error Then
                LogWrite("Error retrieving party flag.")
            Else
                LogWrite("Party Flag: " & $result)
            EndIf

        Case "Requests Count"
            Local $result = _Party_RequestsCount()
            If @error Then
                LogWrite("Error retrieving party requests count.")
            Else
                LogWrite("Party Requests Count: " & $result)
            EndIf

        Case "Sending Count"
            Local $result = _Party_SendingCount()
            If @error Then
                LogWrite("Error retrieving party sending count.")
            Else
                LogWrite("Party Sending Count: " & $result)
            EndIf

        Case "Parties Count"
            Local $result = _Party_PartiesCount()
            If @error Then
                LogWrite("Error retrieving parties count.")
            Else
                LogWrite("Parties Count: " & $result)
            EndIf

        Case "Player Party"
            Local $result = _Party_PlayerParty()
            If @error Then
                LogWrite("Error retrieving player party.")
            Else
                LogWrite("Player Party ID: " & $result)
            EndIf

        Case "Party Search Count"
            Local $result = _Party_PartySearchCount()
            If @error Then
                LogWrite("Error retrieving party search count.")
            Else
                LogWrite("Party Search Count: " & $result)
            EndIf

        Case "Party Size"
            Local $result = _Party_Size()
            If @error Then
                LogWrite("Error retrieving party size.")
            Else
                LogWrite("Party Size: " & $result)
            EndIf

        Case "Party Overview"
            DisplayPartyOverview()
    EndSwitch
EndFunc

Func GetPartyMembersInfo($itemText, $index)
    Switch $itemText
        Case "Count"
            Local $result = _Nexus_PartyMembersInfo($PARTY_MEMBERS_INFO_COUNT)
            If @error Then
                LogWrite("Error retrieving party members count.")
            Else
                LogWrite("Party Members Count: " & $result)
            EndIf

        Case "By Index"
            Local $result = _Nexus_PartyMembersInfo($PARTY_MEMBERS_INFO_BY_INDEX, $index)
            If @error Then
                LogWrite("Error retrieving party member at index " & $index & ".")
            Else
                LogWrite("Party Member at index " & $index & ":")
                LogWrite("  Login Number: " & $result[0])
                LogWrite("  Called Target ID: " & $result[1])
                LogWrite("  State: " & $result[2])
            EndIf

        Case "All Members"
            Local $result = _Nexus_PartyMembersInfo($PARTY_MEMBERS_INFO_ALL)
            If @error Then
                LogWrite("Error retrieving all party members.")
            Else
                LogWrite("All Party Members:")
                Local $memberCount = $result[0][0]
                LogWrite("  Total Members: " & $memberCount)

                For $i = 1 To $memberCount
                    LogWrite("  Member " & ($i-1) & ":")
                    LogWrite("    Login Number: " & $result[$i][0])
                    LogWrite("    Called Target ID: " & $result[$i][1])
                    LogWrite("    State: " & $result[$i][2])
                Next
            EndIf
    EndSwitch
EndFunc

Func GetPartyHenchmenInfo($itemText, $index)
    Switch $itemText
        Case "Count"
            Local $result = _Nexus_PartyHenchmenInfo($PARTY_HENCHMEN_INFO_COUNT)
            If @error Then
                LogWrite("Error retrieving party henchmen count.")
            Else
                LogWrite("Party Henchmen Count: " & $result)
            EndIf

        Case "By Index"
            Local $result = _Nexus_PartyHenchmenInfo($PARTY_HENCHMEN_INFO_BY_INDEX, $index)
            If @error Then
                LogWrite("Error retrieving henchman at index " & $index & ".")
            Else
                LogWrite("Henchman at index " & $index & ":")
                LogWrite("  Agent ID: " & $result[0])
                LogWrite("  Profession: " & $result[1])
                LogWrite("  Level: " & $result[2])
            EndIf

        Case "All Henchmen"
            Local $result = _Nexus_PartyHenchmenInfo($PARTY_HENCHMEN_INFO_ALL)
            If @error Then
                LogWrite("Error retrieving all henchmen.")
            Else
                LogWrite("All Henchmen:")
                Local $henchCount = $result[0][0]
                LogWrite("  Total Henchmen: " & $henchCount)

                For $i = 1 To $henchCount
                    LogWrite("  Henchman " & ($i-1) & ":")
                    LogWrite("    Agent ID: " & $result[$i][0])
                    LogWrite("    Profession: " & $result[$i][1])
                    LogWrite("    Level: " & $result[$i][2])
                Next
            EndIf
    EndSwitch
EndFunc

Func GetPartyHeroesInfo($itemText, $index)
    Switch $itemText
        Case "Count"
            Local $result = _Nexus_PartyHeroesInfo($PARTY_HEROES_INFO_COUNT)
            If @error Then
                LogWrite("Error retrieving party heroes count.")
            Else
                LogWrite("Party Heroes Count: " & $result)
            EndIf

        Case "By Index"
            Local $result = _Nexus_PartyHeroesInfo($PARTY_HEROES_INFO_BY_INDEX, $index)
            If @error Then
                LogWrite("Error retrieving hero at index " & $index & ".")
            Else
                LogWrite("Hero at index " & $index & ":")
                LogWrite("  Agent ID: " & $result[0])
                LogWrite("  Owner Player ID: " & $result[1])
                LogWrite("  Hero ID: " & $result[2])
                LogWrite("  Level: " & $result[3])
            EndIf

        Case "All Heroes"
            Local $result = _Nexus_PartyHeroesInfo($PARTY_HEROES_INFO_ALL)
            If @error Then
                LogWrite("Error retrieving all heroes.")
            Else
                LogWrite("All Heroes:")
                Local $heroCount = $result[0][0]
                LogWrite("  Total Heroes: " & $heroCount)

                For $i = 1 To $heroCount
                    LogWrite("  Hero " & ($i-1) & ":")
                    LogWrite("    Agent ID: " & $result[$i][0])
                    LogWrite("    Owner Player ID: " & $result[$i][1])
                    LogWrite("    Hero ID: " & $result[$i][2])
                    LogWrite("    Level: " & $result[$i][3])
                Next
            EndIf
    EndSwitch
EndFunc

Func GetHeroFlagsInfo($itemText, $index)
    Switch $itemText
        Case "Count"
            Local $result = _Nexus_HeroFlagsInfo($HERO_FLAGS_INFO_COUNT)
            If @error Then
                LogWrite("Error retrieving hero flags count.")
            Else
                LogWrite("Hero Flags Count: " & $result)
            EndIf

        Case "By Index"
            Local $result = _Nexus_HeroFlagsInfo($HERO_FLAGS_INFO_BY_INDEX, $index)
            If @error Then
                LogWrite("Error retrieving hero flag at index " & $index & ".")
            Else
                LogWrite("Hero Flag at index " & $index & ":")
                LogWrite("  Hero ID: " & $result[0])
                LogWrite("  Agent ID: " & $result[1])
                LogWrite("  Level: " & $result[2])
                LogWrite("  Hero Behavior: " & $result[3])
                LogWrite("  Flag X: " & $result[4])
                LogWrite("  Flag Y: " & $result[5])
                LogWrite("  Locked Target ID: " & $result[8])
            EndIf

        Case "All Hero Flags"
            Local $result = _Nexus_HeroFlagsInfo($HERO_FLAGS_INFO_ALL)
            If @error Then
                LogWrite("Error retrieving all hero flags.")
            Else
                LogWrite("All Hero Flags:")
                Local $flagCount = $result[0][0]
                LogWrite("  Total Flags: " & $flagCount)

                For $i = 1 To $flagCount
                    LogWrite("  Flag " & ($i-1) & ":")
                    LogWrite("    Hero ID: " & $result[$i][0])
                    LogWrite("    Agent ID: " & $result[$i][1])
                    LogWrite("    Level: " & $result[$i][2])
                    LogWrite("    Hero Behavior: " & $result[$i][3])
                    LogWrite("    Flag Coordinates: X=" & $result[$i][4] & ", Y=" & $result[$i][5])
                    LogWrite("    Locked Target ID: " & $result[$i][8])
                Next
            EndIf
    EndSwitch
EndFunc

Func GetHeroDetailsInfo($itemText, $index)
    Switch $itemText
        Case "Count"
            Local $result = _Nexus_HeroInfos($HERO_INFOS_COUNT)
            If @error Then
                LogWrite("Error retrieving hero details count.")
            Else
                LogWrite("Hero Details Count: " & $result)
            EndIf

        Case "By Index"
            Local $result = _Nexus_HeroInfos($HERO_INFOS_BY_INDEX, $index)
            If @error Then
                LogWrite("Error retrieving hero details at index " & $index & ".")
            Else
                LogWrite("Hero Details at index " & $index & ":")
                LogWrite("  Hero ID: " & $result[0])
                LogWrite("  Agent ID: " & $result[1])
                LogWrite("  Level: " & $result[2])
                LogWrite("  Primary Profession: " & $result[3])
                LogWrite("  Secondary Profession: " & $result[4])
                LogWrite("  Hero File ID: " & $result[5])
                LogWrite("  Model File ID: " & $result[6])
                LogWrite("  Name: " & $result[7])
            EndIf

        Case "All Hero Details"
            Local $result = _Nexus_HeroInfos($HERO_INFOS_ALL)
            If @error Then
                LogWrite("Error retrieving all hero details.")
            Else
                LogWrite("All Hero Details:")
                Local $infoCount = $result[0][0]
                LogWrite("  Total Heroes: " & $infoCount)

                For $i = 1 To $infoCount
                    LogWrite("  Hero " & ($i-1) & ":")
                    LogWrite("    Hero ID: " & $result[$i][0])
                    LogWrite("    Agent ID: " & $result[$i][1])
                    LogWrite("    Level: " & $result[$i][2])
                    LogWrite("    Primary Profession: " & $result[$i][3])
                    LogWrite("    Secondary Profession: " & $result[$i][4])
                    LogWrite("    Name: " & $result[$i][7])
                Next
            EndIf
    EndSwitch
EndFunc

Func GetPartyAlliesInfo($itemText, $index)
    Switch $itemText
        Case "Count"
            Local $result = _Nexus_PartyAlliesInfo($PARTY_ALLIES_INFO_COUNT)
            If @error Then
                LogWrite("Error retrieving party allies count.")
            Else
                LogWrite("Party Allies Count: " & $result)
            EndIf

        Case "By Index"
            Local $result = _Nexus_PartyAlliesInfo($PARTY_ALLIES_INFO_BY_INDEX, $index)
            If @error Then
                LogWrite("Error retrieving ally at index " & $index & ".")
            Else
                LogWrite("Ally at index " & $index & ":")
                LogWrite("  Agent ID: " & $result[0])
                LogWrite("  Unknown: " & $result[1])
                LogWrite("  Composite ID: " & $result[2])
            EndIf

        Case "All Allies"
            Local $result = _Nexus_PartyAlliesInfo($PARTY_ALLIES_INFO_ALL)
            If @error Then
                LogWrite("Error retrieving all allies.")
            Else
                LogWrite("All Allies:")
                Local $allyCount = $result[0][0]
                LogWrite("  Total Allies: " & $allyCount)

                For $i = 1 To $allyCount
                    LogWrite("  Ally " & ($i-1) & ":")
                    LogWrite("    Agent ID: " & $result[$i][0])
                    LogWrite("    Unknown: " & $result[$i][1])
                    LogWrite("    Composite ID: " & $result[$i][2])
                Next
            EndIf
    EndSwitch
EndFunc

Func GetControlledMinionsInfo($itemText, $index)
    Switch $itemText
        Case "Count"
            Local $result = _Nexus_ControlledMinionsInfo($CONTROLLED_MINIONS_INFO_COUNT)
            If @error Then
                LogWrite("Error retrieving controlled minions count.")
            Else
                LogWrite("Controlled Minions Count: " & $result)
            EndIf

        Case "By Index"
            Local $result = _Nexus_ControlledMinionsInfo($CONTROLLED_MINIONS_INFO_BY_INDEX, $index)
            If @error Then
                LogWrite("Error retrieving minion at index " & $index & ".")
            Else
                LogWrite("Minion at index " & $index & ":")
                LogWrite("  Agent ID: " & $result[0])
                LogWrite("  Minion Count: " & $result[1])
            EndIf

        Case "All Minions"
            Local $result = _Nexus_ControlledMinionsInfo($CONTROLLED_MINIONS_INFO_ALL)
            If @error Then
                LogWrite("Error retrieving all minions.")
            Else
                LogWrite("All Controlled Minions:")
                Local $minionCount = $result[0][0]
                LogWrite("  Total Minion Entries: " & $minionCount)

                For $i = 1 To $minionCount
                    LogWrite("  Entry " & ($i-1) & ":")
                    LogWrite("    Agent ID: " & $result[$i][0])
                    LogWrite("    Minion Count: " & $result[$i][1])
                Next
            EndIf
    EndSwitch
EndFunc

Func GetPetsInfo($itemText, $index)
    Switch $itemText
        Case "Count"
            Local $result = _Nexus_PetsInfo($PETS_INFO_COUNT)
            If @error Then
                LogWrite("Error retrieving pets count.")
            Else
                LogWrite("Pets Count: " & $result)
            EndIf

        Case "By Index"
            Local $result = _Nexus_PetsInfo($PETS_INFO_BY_INDEX, $index)
            If @error Then
                LogWrite("Error retrieving pet at index " & $index & ".")
            Else
                LogWrite("Pet at index " & $index & ":")
                LogWrite("  Agent ID: " & $result[0])
                LogWrite("  Owner Agent ID: " & $result[1])
                LogWrite("  Pet Name: " & $result[2])
                LogWrite("  Model File ID 1: " & $result[3])
                LogWrite("  Model File ID 2: " & $result[4])
                LogWrite("  Behavior: " & $result[5])
                LogWrite("  Locked Target ID: " & $result[6])
            EndIf

        Case "All Pets"
            Local $result = _Nexus_PetsInfo($PETS_INFO_ALL)
            If @error Then
                LogWrite("Error retrieving all pets.")
            Else
                LogWrite("All Pets:")
                Local $petCount = $result[0][0]
                LogWrite("  Total Pets: " & $petCount)

                For $i = 1 To $petCount
                    LogWrite("  Pet " & ($i-1) & ":")
                    LogWrite("    Agent ID: " & $result[$i][0])
                    LogWrite("    Owner Agent ID: " & $result[$i][1])
                    LogWrite("    Pet Name: " & $result[$i][2])
                    LogWrite("    Behavior: " & $result[$i][5])
                Next
            EndIf
    EndSwitch
EndFunc

Func GetPartySearchInfo($itemText, $index)
    Switch $itemText
        Case "Count"
            Local $result = _Nexus_PartySearchInfo($PARTY_SEARCH_INFO_COUNT)
            If @error Then
                LogWrite("Error retrieving party search count.")
            Else
                LogWrite("Party Search Count: " & $result)
            EndIf

        Case "By Index"
            Local $result = _Nexus_PartySearchInfo($PARTY_SEARCH_INFO_BY_INDEX, $index)
            If @error Then
                LogWrite("Error retrieving party search at index " & $index & ".")
            Else
                LogWrite("Party Search at index " & $index & ":")
                LogWrite("  Party Search ID: " & $result[0])
                LogWrite("  Party Search Type: " & $result[1])
                LogWrite("  Hardmode: " & $result[2])
                LogWrite("  Party Size: " & $result[5])
                LogWrite("  Hero Count: " & $result[6])
                LogWrite("  Message: " & $result[7])
                LogWrite("  Party Leader: " & $result[8])
                LogWrite("  Primary Profession: " & $result[9])
                LogWrite("  Secondary Profession: " & $result[10])
                LogWrite("  Level: " & $result[11])
            EndIf

        Case "All Search Data"
            Local $result = _Nexus_PartySearchInfo($PARTY_SEARCH_INFO_ALL)
            If @error Then
                LogWrite("Error retrieving all party search data.")
            Else
                LogWrite("All Party Search Data:")
                Local $searchCount = $result[0][0]
                LogWrite("  Total Search Entries: " & $searchCount)

                For $i = 1 To $searchCount
                    LogWrite("  Entry " & ($i-1) & ":")
                    LogWrite("    Party Search ID: " & $result[$i][0])
                    LogWrite("    Party Leader: " & $result[$i][8])
                    LogWrite("    Message: " & $result[$i][7])
                    LogWrite("    Party Size: " & $result[$i][5] & " (+" & $result[$i][6] & " heroes)")
                Next
            EndIf
    EndSwitch
EndFunc

Func GetSkillbarsInfo($itemText, $agentID, $index)
    Switch $itemText
        Case "Count"
            Local $result = _Nexus_SkillbarsInfo($SKILLBARS_INFO_COUNT)
            If @error Then
                LogWrite("Error retrieving skillbars count.")
            Else
                LogWrite("Skillbars Count: " & $result)
            EndIf

        Case "By Index"
            Local $result = _Nexus_SkillbarsInfo($SKILLBARS_INFO_BY_INDEX, $index)
            If @error Then
                LogWrite("Error retrieving skillbar at index " & $index & ".")
            Else
                LogWrite("Skillbar at index " & $index & ":")
                DisplaySkillbar($result)
            EndIf

        Case "By Agent ID"
            If $agentID <= 0 Then
                LogWrite("Error: Please enter a valid Agent ID.")
                Return
            EndIf

            Local $result = _Nexus_SkillbarsInfo($SKILLBARS_INFO_BY_AGENT_ID, $agentID)
            If @error Then
                LogWrite("Error retrieving skillbar for agent ID " & $agentID & ".")
            Else
                LogWrite("Skillbar for Agent ID " & $agentID & ":")
                DisplaySkillbar($result)
            EndIf

		Case "All Skillbars"
			Local $result = _Nexus_SkillbarsInfo($SKILLBARS_INFO_ALL)
			If @error Then
				LogWrite("Error retrieving all skillbars.")
			Else
				LogWrite("All Skillbars:")
				Local $barCount = $result[0][0]
				LogWrite("  Total Skillbars: " & $barCount)

				For $i = 1 To $barCount
					LogWrite("  Skillbar " & ($i-1) & " (Agent ID: " & $result[$i][0] & "):")
					; Afficher les skills sans passer par la fonction DisplaySkillbarCompact
					LogWrite("    Skills: " & _
						$result[$i][4] & ", " & _
						$result[$i][9] & ", " & _
						$result[$i][14] & ", " & _
						$result[$i][19] & ", " & _
						$result[$i][24] & ", " & _
						$result[$i][29] & ", " & _
						$result[$i][34] & ", " & _
						$result[$i][39])
				Next
			EndIf
    EndSwitch
EndFunc

Func GetAgentEffectsInfo($itemText, $agentID, $index)
    Switch $itemText
        Case "Count"
            Local $result = _Nexus_AgentEffectsInfo($AGENT_EFFECTS_INFO_COUNT)
            If @error Then
                LogWrite("Error retrieving agent effects count.")
            Else
                LogWrite("Agent Effects Count: " & $result)
            EndIf

        Case "By Index"
            Local $result = _Nexus_AgentEffectsInfo($AGENT_EFFECTS_INFO_BY_INDEX, $index)
            If @error Then
                LogWrite("Error retrieving agent effect at index " & $index & ".")
            Else
                DisplayAgentEffects($result)
            EndIf

        Case "By Agent ID"
            If $agentID <= 0 Then
                LogWrite("Error: Please enter a valid Agent ID.")
                Return
            EndIf

            Local $result = _Nexus_AgentEffectsInfo($AGENT_EFFECTS_INFO_BY_AGENT_ID, $agentID)
            If @error Then
                LogWrite("Error retrieving effects for agent ID " & $agentID & ".")
            Else
                DisplayAgentEffects($result)
            EndIf

		Case "All Effects"
			Local $result = _Nexus_AgentEffectsInfo($AGENT_EFFECTS_INFO_ALL)
			If @error Then
				LogWrite("Error retrieving all agent effects.")
			Else
				LogWrite("All Agent Effects:")
				Local $count = $result[0][0]
				LogWrite("  Total Effect Data: " & $count)

				For $i = 1 To $count
					LogWrite("  Agent " & $i & " (ID: " & $result[$i][0] & "):")

					; Afficher directement les informations sans passer par DisplayAgentEffectsCompact
					Local $buffCount = $result[$i][1]
					Local $buffs = $result[$i][2]
					Local $effects = $result[$i][3]

					LogWrite("    Buffs (" & $buffCount & ")")

					Local $effectCount = $effects[0][0]
					LogWrite("    Effects (" & $effectCount & ")")

					; Show first 3 effects only
					Local $maxDisplay = _Min($effectCount, 3)
					For $j = 1 To $maxDisplay
						LogWrite("      Effect " & ($j-1) & ": Skill=" & $effects[$j][0] & ", Duration=" & $effects[$j][4])
					Next

					If $effectCount > $maxDisplay Then
						LogWrite("      ... and " & ($effectCount - $maxDisplay) & " more")
					EndIf
				Next
			EndIf
    EndSwitch
EndFunc

Func GetPartyAttributesInfo($itemText, $agentID, $index)
    Switch $itemText
        Case "Count"
            Local $result = _Nexus_PartyAttributesInfo($PARTY_ATTRIBUTES_INFO_COUNT)
            If @error Then
                LogWrite("Error retrieving party attributes count.")
            Else
                LogWrite("Party Attributes Count: " & $result)
            EndIf

        Case "By Index"
            Local $result = _Nexus_PartyAttributesInfo($PARTY_ATTRIBUTES_INFO_BY_INDEX, $index)
            If @error Then
                LogWrite("Error retrieving party attributes at index " & $index & ".")
            Else
                DisplayPartyAttributes($result)
            EndIf

        Case "By Agent ID"
            If $agentID <= 0 Then
                LogWrite("Error: Please enter a valid Agent ID.")
                Return
            EndIf

            Local $result = _Nexus_PartyAttributesInfo($PARTY_ATTRIBUTES_INFO_BY_AGENT_ID, $agentID)
            If @error Then
                LogWrite("Error retrieving attributes for agent ID " & $agentID & ".")
            Else
                DisplayPartyAttributes($result)
            EndIf

		Case "All Attributes"
			Local $result = _Nexus_PartyAttributesInfo($PARTY_ATTRIBUTES_INFO_ALL)
			If @error Then
				LogWrite("Error retrieving all party attributes.")
			Else
				LogWrite("All Party Attributes:")
				Local $count = $result[0][0]
				LogWrite("  Total Attribute Data: " & $count)

				For $i = 1 To $count
					Local $aAgentID = $result[$i][0]
					Local $attributes = $result[$i][1]

					LogWrite("  Agent " & $i & " (ID: " & $aAgentID & "):")

					; Accéder aux informations d'attributs dans le tableau attributes
					Local $attrCount = $attributes[1][0]  ; Nombre d'attributs
					LogWrite("    Attributes Count: " & $attrCount)

					; Afficher seulement quelques attributs pour éviter de surcharger le log
					Local $maxDisplay = _Min($attrCount, 3)
					For $j = 0 To $maxDisplay - 1
						LogWrite("    Attribute " & $j & ":")
						LogWrite("      ID: " & $attributes[$j+2][1])
						LogWrite("      Level: " & $attributes[$j+2][3] & " (Base: " & $attributes[$j+2][2] & ")")
					Next

					If $attrCount > $maxDisplay Then
						LogWrite("    " & ($attrCount - $maxDisplay) & " more attributes...")
					EndIf
				Next
			EndIf
    EndSwitch
EndFunc

Func DisplaySkillbar($skillbar)
    LogWrite("  Agent ID: " & $skillbar[0])
    LogWrite("  Skills:")

    For $i = 0 To 7
        Local $baseIndex = $i * 5 + 1
        LogWrite("    Skill " & $i & ":")
        LogWrite("      Skill ID: " & $skillbar[$baseIndex + 3])
        LogWrite("      Adrenaline: " & $skillbar[$baseIndex] & "/" & $skillbar[$baseIndex + 1])
        LogWrite("      Recharge: " & $skillbar[$baseIndex + 2])
    Next

    LogWrite("  Disabled: " & $skillbar[41])
    LogWrite("  Casting: " & $skillbar[44])
EndFunc

Func DisplaySkillbarCompact($skillbar)
    LogWrite("    Skills: " & _
            $skillbar[4] & ", " & _
            $skillbar[9] & ", " & _
            $skillbar[14] & ", " & _
            $skillbar[19] & ", " & _
            $skillbar[24] & ", " & _
            $skillbar[29] & ", " & _
            $skillbar[34] & ", " & _
            $skillbar[39])
EndFunc

Func DisplayAgentEffects($agentEffectData)
    Local $agentID = $agentEffectData[0]
    Local $buffCount = $agentEffectData[1]
    Local $buffs = $agentEffectData[2]
    Local $effects = $agentEffectData[3]

    LogWrite("Agent Effects for Agent ID " & $agentID & ":")
    LogWrite("  Buffs (" & $buffCount & "):")

    For $i = 1 To $buffCount
        LogWrite("    Buff " & ($i-1) & ":")
        LogWrite("      Skill ID: " & $buffs[$i][0])
        LogWrite("      Buff ID: " & $buffs[$i][2])
        LogWrite("      Target Agent ID: " & $buffs[$i][3])
    Next

    Local $effectCount = $effects[0][0]
    LogWrite("  Effects (" & $effectCount & "):")

    For $i = 1 To $effectCount
        LogWrite("    Effect " & ($i-1) & ":")
        LogWrite("      Skill ID: " & $effects[$i][0])
        LogWrite("      Attribute Level: " & $effects[$i][1])
        LogWrite("      Effect ID: " & $effects[$i][2])
        LogWrite("      Duration: " & $effects[$i][4])
    Next
EndFunc

Func DisplayAgentEffectsCompact($agentEffectData)
    Local $buffCount = $agentEffectData[1]
    Local $buffs = $agentEffectData[2]
    Local $effects = $agentEffectData[3]

    LogWrite("    Buffs (" & $buffCount & ")")

    Local $effectCount = $effects[0][0]
    LogWrite("    Effects (" & $effectCount & ")")

    ; Show first 3 effects only
    Local $maxDisplay = _Min($effectCount, 3)
    For $i = 1 To $maxDisplay
        LogWrite("      Effect " & ($i-1) & ": Skill=" & $effects[$i][0] & ", Duration=" & $effects[$i][4])
    Next

    If $effectCount > $maxDisplay Then
        LogWrite("      ... and " & ($effectCount - $maxDisplay) & " more")
    EndIf
EndFunc

Func DisplayPartyAttributes($attributeData)
    Local $agentID = $attributeData[0]
    Local $attrCount = $attributeData[1]

    LogWrite("Attributes for Agent ID " & $agentID & ":")
    LogWrite("  Total Attributes: " & $attrCount)

    ; Les attributs sont maintenant stockés sous forme de tableaux dans attributeData
    For $i = 0 To $attrCount - 1
        Local $attr = $attributeData[$i + 2]  ; Récupérer le tableau d'attributs

        LogWrite("  Attribute " & $i & ":")
        LogWrite("    Attribute Index: " & $attr[0])
        LogWrite("    Attribute ID: " & $attr[1])
        LogWrite("    Base Level: " & $attr[2])
        LogWrite("    Current Level: " & $attr[3])
        LogWrite("    Decrement Points: " & $attr[4])
        LogWrite("    Increment Points: " & $attr[5])
    Next
EndFunc

Func DisplayPartyOverview()
    LogWrite("================= PARTY OVERVIEW =================")

    ; Basic party info
    Local $partySize = _Party_Size()
    LogWrite("PARTY SIZE: " & $partySize)

    ; Members
    Local $membersCount = _Nexus_PartyMembersInfo($PARTY_MEMBERS_INFO_COUNT)
    LogWrite("PARTY MEMBERS: " & $membersCount)
    If $membersCount > 0 Then
        Local $members = _Nexus_PartyMembersInfo($PARTY_MEMBERS_INFO_ALL)
        For $i = 1 To $members[0][0]
            LogWrite("  Member " & ($i-1) & ": Login=" & $members[$i][0])
        Next
    EndIf

    ; Henchmen
    Local $henchmenCount = _Nexus_PartyHenchmenInfo($PARTY_HENCHMEN_INFO_COUNT)
    LogWrite("HENCHMEN: " & $henchmenCount)
    If $henchmenCount > 0 Then
        Local $henchmen = _Nexus_PartyHenchmenInfo($PARTY_HENCHMEN_INFO_ALL)
        For $i = 1 To $henchmen[0][0]
            LogWrite("  Henchman " & ($i-1) & ": AgentID=" & $henchmen[$i][0] & ", Prof=" & $henchmen[$i][1] & ", Level=" & $henchmen[$i][2])
        Next
    EndIf

    ; Heroes
    Local $heroesCount = _Nexus_PartyHeroesInfo($PARTY_HEROES_INFO_COUNT)
    LogWrite("HEROES: " & $heroesCount)
    If $heroesCount > 0 Then
        Local $heroes = _Nexus_PartyHeroesInfo($PARTY_HEROES_INFO_ALL)
        Local $heroInfo = _Nexus_HeroInfos($HERO_INFOS_ALL)

        For $i = 1 To $heroes[0][0]
            Local $heroID = $heroes[$i][2]
            Local $heroName = "Unknown"

            ; Try to find hero name
            For $j = 1 To $heroInfo[0][0]
                If $heroInfo[$j][0] = $heroID Then
                    $heroName = $heroInfo[$j][7]
                    ExitLoop
                EndIf
            Next

            LogWrite("  Hero " & ($i-1) & ": " & $heroName & " (ID=" & $heroes[$i][0] & ", Level=" & $heroes[$i][3] & ")")
        Next
    EndIf

    ; Allies
    Local $alliesCount = _Nexus_PartyAlliesInfo($PARTY_ALLIES_INFO_COUNT)
    LogWrite("ALLIES: " & $alliesCount)

    ; Pets
    Local $petsCount = _Nexus_PetsInfo($PETS_INFO_COUNT)
    LogWrite("PETS: " & $petsCount)
    If $petsCount > 0 Then
        Local $pets = _Nexus_PetsInfo($PETS_INFO_ALL)
        For $i = 1 To $pets[0][0]
            LogWrite("  Pet " & ($i-1) & ": " & $pets[$i][2] & " (Owner=" & $pets[$i][1] & ")")
        Next
    EndIf

    LogWrite("================= END OF OVERVIEW =================")
EndFunc

Func DisplayPartyMembers()
    Local $membersCount = _Nexus_PartyMembersInfo($PARTY_MEMBERS_INFO_COUNT)
    Local $heroesCount = _Nexus_PartyHeroesInfo($PARTY_HEROES_INFO_COUNT)
    Local $henchmenCount = _Nexus_PartyHenchmenInfo($PARTY_HENCHMEN_INFO_COUNT)

    LogWrite("=================== PARTY MEMBERS ===================")
    LogWrite("Players: " & $membersCount & ", Heroes: " & $heroesCount & ", Henchmen: " & $henchmenCount)
    LogWrite("")

    ; Player Characters
    If $membersCount > 0 Then
        LogWrite("PLAYERS:")
        Local $members = _Nexus_PartyMembersInfo($PARTY_MEMBERS_INFO_ALL)

        ; Try to get additional info for each player
        For $i = 1 To $members[0][0]
            Local $loginNumber = $members[$i][0]

            ; Try to get player name through character context query if available
            Local $playerName = "Player " & ($i-1)
            LogWrite("  " & $playerName & " (Login=" & $loginNumber & ")")
        Next
        LogWrite("")
    EndIf

    ; Heroes
    If $heroesCount > 0 Then
        LogWrite("HEROES:")
        Local $heroes = _Nexus_PartyHeroesInfo($PARTY_HEROES_INFO_ALL)
        Local $heroInfo = _Nexus_HeroInfos($HERO_INFOS_ALL)

        For $i = 1 To $heroes[0][0]
            Local $heroID = $heroes[$i][2]
            Local $heroAgent = $heroes[$i][0]
            Local $heroOwner = $heroes[$i][1]
            Local $heroName = "Unknown"
            Local $primary = 0
            Local $secondary = 0

            ; Try to find hero details
            For $j = 1 To $heroInfo[0][0]
                If $heroInfo[$j][0] = $heroID Then
                    $heroName = $heroInfo[$j][7]
                    $primary = $heroInfo[$j][3]
                    $secondary = $heroInfo[$j][4]
                    ExitLoop
                EndIf
            Next

            LogWrite("  " & $heroName & " (ID=" & $heroAgent & ", Prof=" & $primary & "/" & $secondary & ", Level=" & $heroes[$i][3] & ")")
        Next
        LogWrite("")
    EndIf

    ; Henchmen
    If $henchmenCount > 0 Then
        LogWrite("HENCHMEN:")
        Local $henchmen = _Nexus_PartyHenchmenInfo($PARTY_HENCHMEN_INFO_ALL)

        For $i = 1 To $henchmen[0][0]
            LogWrite("  Henchman " & ($i-1) & " (ID=" & $henchmen[$i][0] & ", Prof=" & $henchmen[$i][1] & ", Level=" & $henchmen[$i][2] & ")")
        Next
    EndIf

    LogWrite("=============== END OF PARTY MEMBERS ===============")
EndFunc

Func DisplayHeroesAndFlags()
    Local $heroesCount = _Nexus_PartyHeroesInfo($PARTY_HEROES_INFO_COUNT)
    Local $flagsCount = _Nexus_HeroFlagsInfo($HERO_FLAGS_INFO_COUNT)
    Local $detailsCount = _Nexus_HeroInfos($HERO_INFOS_COUNT)

    LogWrite("=================== HEROES & FLAGS ===================")

    ; Hero Details
    If $detailsCount > 0 Then
        LogWrite("HERO DETAILS:")
        Local $heroInfo = _Nexus_HeroInfos($HERO_INFOS_ALL)

        For $i = 1 To $heroInfo[0][0]
            LogWrite("  " & $heroInfo[$i][7] & ":")
            LogWrite("    ID: " & $heroInfo[$i][0] & ", Agent: " & $heroInfo[$i][1])
            LogWrite("    Prof: " & $heroInfo[$i][3] & "/" & $heroInfo[$i][4] & ", Level: " & $heroInfo[$i][2])
        Next
        LogWrite("")
    EndIf

    ; Hero Flags
    If $flagsCount > 0 Then
        LogWrite("HERO FLAGS:")
        Local $flags = _Nexus_HeroFlagsInfo($HERO_FLAGS_INFO_ALL)

        For $i = 1 To $flags[0][0]
            LogWrite("  Flag " & ($i-1) & ":")
            LogWrite("    Hero ID: " & $flags[$i][0] & ", Agent: " & $flags[$i][1])
            LogWrite("    Level: " & $flags[$i][2] & ", Behavior: " & $flags[$i][3])
            LogWrite("    Flag: X=" & $flags[$i][4] & ", Y=" & $flags[$i][5])
            LogWrite("    Locked Target: " & $flags[$i][8])
        Next
    EndIf

    LogWrite("================ END OF HEROES & FLAGS ================")
EndFunc

Func DisplayAllSkillbars()
    Local $skillbarsCount = _Nexus_SkillbarsInfo($SKILLBARS_INFO_COUNT)

    LogWrite("=================== SKILLBARS ===================")
    LogWrite("Total Skillbars: " & $skillbarsCount)

    If $skillbarsCount > 0 Then
        Local $skillbars = _Nexus_SkillbarsInfo($SKILLBARS_INFO_ALL)

        For $i = 1 To $skillbars[0][0]
            LogWrite("Skillbar " & ($i-1) & " (Agent ID: " & $skillbars[$i][0] & "):")
            LogWrite("  Skills:")

            For $j = 0 To 7
                Local $baseIndex = $j * 5 + 1
                Local $skillID = $skillbars[$i][$baseIndex + 3]
                Local $recharge = $skillbars[$i][$baseIndex + 2]

                If $skillID > 0 Then
                    LogWrite("    Skill " & $j & ": ID=" & $skillID & ", Recharge=" & $recharge)
                EndIf
            Next
        Next
    EndIf

    LogWrite("================ END OF SKILLBARS ================")
EndFunc

; Main function
Func Main()
    ; Create the interface
    CreateInterface()

    LogWrite("Welcome to the Party Info Explorer!")
    LogWrite("Please enter the character name and click 'Connect'.")

    ; Event handling loop
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $g_idExit
                ExitLoop

            Case $g_idConnectBtn
                ConnectToGwNexus()

            Case $g_idGetInfoBtn
                GetSelectedPartyInfo()

            Case $g_idGetPartyOverviewBtn
                DisplayPartyOverview()

            Case $g_idGetMembersBtn
                DisplayPartyMembers()

            Case $g_idGetHeroesBtn
                DisplayHeroesAndFlags()

            Case $g_idGetSkillbarsBtn
                DisplayAllSkillbars()

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