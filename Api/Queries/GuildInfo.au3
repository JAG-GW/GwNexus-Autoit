#include-once

; Guild Information Types
Global Enum $GUILD_INFO_PLAYER_NAME = 0, _
           $GUILD_INFO_PLAYER_GUILD_INDEX = 1, _
           $GUILD_INFO_PLAYER_GUILD_KEY = 2, _
           $GUILD_INFO_ANNOUNCEMENT = 3, _
           $GUILD_INFO_ANNOUNCEMENT_AUTHOR = 4, _
           $GUILD_INFO_PLAYER_GUILD_RANK = 5, _
           $GUILD_INFO_KURZICK_TOWN_COUNT = 7, _
           $GUILD_INFO_LUXON_TOWN_COUNT = 8, _
           $GUILD_INFO_ALL = 12

; Guilds Information Types
Global Enum $GUILDS_INFO_COUNT = 0, _
           $GUILDS_INFO_BY_INDEX = 1, _
           $GUILDS_INFO_ALL = 2, _
           $GUILDS_INFO_BY_KEY = 3

; Guild History Information Types
Global Enum $GUILD_HISTORY_INFO_COUNT = 0, _
           $GUILD_HISTORY_INFO_BY_INDEX = 1, _
           $GUILD_HISTORY_INFO_ALL = 2

; Guild Roster Information Types
Global Enum $GUILD_ROSTER_INFO_COUNT = 0, _
           $GUILD_ROSTER_INFO_BY_INDEX = 1, _
           $GUILD_ROSTER_INFO_ALL = 2, _
           $GUILD_ROSTER_INFO_BY_NAME = 3

; Town Alliance Information Types
Global Enum $TOWN_ALLIANCE_INFO_COUNT = 0, _
           $TOWN_ALLIANCE_INFO_BY_INDEX = 1, _
           $TOWN_ALLIANCE_INFO_ALL = 2

; Main function to get guild information
Func _Nexus_GuildInfo($infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_GUILD_INFO, 1) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $GUILD_INFO_PLAYER_NAME, $GUILD_INFO_ANNOUNCEMENT, $GUILD_INFO_ANNOUNCEMENT_AUTHOR
            Local $value = _GetFirstStringValue()
            _CleanupOutput()
            Return $value

        Case $GUILD_INFO_PLAYER_GUILD_INDEX, $GUILD_INFO_PLAYER_GUILD_RANK, _
             $GUILD_INFO_KURZICK_TOWN_COUNT, $GUILD_INFO_LUXON_TOWN_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $GUILD_INFO_PLAYER_GUILD_KEY
            Local $values = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($values) < 4 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[4] = [$values[0], $values[1], $values[2], $values[3]]
            _CleanupOutput()
            Return $aResult

        Case $GUILD_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 7 Or UBound($stringValues) < 3 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            ; Create the result array with all guild properties
            Local $aResult[8]
            $aResult[0] = $stringValues[0]                        ; Player Name
            $aResult[1] = $intValues[0]                           ; Player Guild Index

            ; Key array
            Local $keyArray[4] = [$intValues[1], $intValues[2], $intValues[3], $intValues[4]]
            $aResult[2] = $keyArray                               ; Player Guild Key

            $aResult[3] = $stringValues[1]                        ; Announcement
            $aResult[4] = $stringValues[2]                        ; Announcement Author
            $aResult[5] = $intValues[5]                           ; Player Guild Rank
            $aResult[6] = $intValues[6]                           ; Kurzick Town Count
            $aResult[7] = $intValues[7]                           ; Luxon Town Count

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get guilds information
Func _Nexus_GuildsInfo($infoType, $param1 = 0, $param2 = 0, $param3 = 0, $param4 = 0)
    Local $paramCount = 1

    If $infoType = $GUILDS_INFO_BY_INDEX Then
        $paramCount = 2
    ElseIf $infoType = $GUILDS_INFO_BY_KEY Then
        $paramCount = 5
    EndIf

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_GUILDS_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $infoType = $GUILDS_INFO_BY_INDEX Then
        _SetParam(1, $param1)  ; Index
    ElseIf $infoType = $GUILDS_INFO_BY_KEY Then
        _SetParam(1, $param1)  ; Key part 1
        _SetParam(2, $param2)  ; Key part 2
        _SetParam(3, $param3)  ; Key part 3
        _SetParam(4, $param4)  ; Key part 4
    EndIf

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $GUILDS_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $GUILDS_INFO_BY_INDEX, $GUILDS_INFO_BY_KEY
            Return _ParseGuildDetails()

        Case $GUILDS_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            ; Get the number of guilds
            Local $guildCount = $intValues[0]

            ; Create a 2D array to store all guild information
            Local $aResult[$guildCount + 1][17]
            $aResult[0][0] = $guildCount

            Local $intIndex = 1
            Local $strIndex = 0

            For $i = 1 To $guildCount
                ; Store guild key as 4 separate values for consistency
                $aResult[$i][0] = $intValues[$intIndex]      ; Key part 1
                $aResult[$i][1] = $intValues[$intIndex + 1]  ; Key part 2
                $aResult[$i][2] = $intValues[$intIndex + 2]  ; Key part 3
                $aResult[$i][3] = $intValues[$intIndex + 3]  ; Key part 4
                $aResult[$i][4] = $intValues[$intIndex + 4]  ; Index
                $aResult[$i][5] = $intValues[$intIndex + 5]  ; Rank
                $aResult[$i][6] = $intValues[$intIndex + 6]  ; Features
                $aResult[$i][7] = $stringValues[$strIndex]   ; Name
                $aResult[$i][8] = $intValues[$intIndex + 7]  ; Rating
                $aResult[$i][9] = $intValues[$intIndex + 8]  ; Faction
                $aResult[$i][10] = $intValues[$intIndex + 9] ; Faction Point
                $aResult[$i][11] = $intValues[$intIndex + 10]; Qualifier Point
                $aResult[$i][12] = $stringValues[$strIndex + 1]; Tag
                $aResult[$i][13] = $intValues[$intIndex + 11]; Cape BG Color
                $aResult[$i][14] = $intValues[$intIndex + 12]; Cape Detail Color
                $aResult[$i][15] = $intValues[$intIndex + 13]; Cape Emblem Color
                $aResult[$i][16] = $intValues[$intIndex + 14]; Cape Shape

                $intIndex += 15  ; Adjusted based on actual values used
                $strIndex += 2   ; 2 string values per guild (name and tag)
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(5, 0, 0)
    EndSwitch
EndFunc

; Helper function to parse guild details
Func _ParseGuildDetails()
    Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
    Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

    If @error Or UBound($intValues) < 17 Or UBound($stringValues) < 2 Then
        _CleanupOutput()
        Return SetError(3, 0, 0)
    EndIf

    ; Create key array
    Local $keyArray[4] = [$intValues[0], $intValues[1], $intValues[2], $intValues[3]]

    ; Create the full result array
    Local $aResult[17]
    $aResult[0] = $keyArray                ; Guild Key
    $aResult[1] = $intValues[4]            ; Index
    $aResult[2] = $intValues[5]            ; Rank
    $aResult[3] = $intValues[6]            ; Features
    $aResult[4] = $stringValues[0]         ; Name
    $aResult[5] = $intValues[7]            ; Rating
    $aResult[6] = $intValues[8]            ; Faction
    $aResult[7] = $intValues[9]            ; Faction Point
    $aResult[8] = $intValues[10]           ; Qualifier Point
    $aResult[9] = $stringValues[1]         ; Tag
    $aResult[10] = $intValues[11]          ; Cape BG Color
    $aResult[11] = $intValues[12]          ; Cape Detail Color
    $aResult[12] = $intValues[13]          ; Cape Emblem Color
    $aResult[13] = $intValues[14]          ; Cape Shape
    $aResult[14] = $intValues[15]          ; Cape Detail
    $aResult[15] = $intValues[16]          ; Cape Emblem
    $aResult[16] = $intValues[17]          ; Cape Trim

    _CleanupOutput()
    Return $aResult
EndFunc

; Function to get guild history information
Func _Nexus_GuildHistoryInfo($infoType, $index = 0)
    Local $paramCount = 1

    If $infoType = $GUILD_HISTORY_INFO_BY_INDEX Then
        $paramCount = 2
    EndIf

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_GUILD_HISTORY_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $infoType = $GUILD_HISTORY_INFO_BY_INDEX Then
        _SetParam(1, $index)
    EndIf

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $GUILD_HISTORY_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $GUILD_HISTORY_INFO_BY_INDEX
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 2 Or UBound($stringValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[3] = [$intValues[0], $intValues[1], $stringValues[0]]
            _CleanupOutput()
            Return $aResult

        Case $GUILD_HISTORY_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            ; Get the number of events
            Local $eventCount = $intValues[0]

            ; Create a 2D array to store all event information
            Local $aResult[$eventCount + 1][3]
            $aResult[0][0] = $eventCount

            Local $intIndex = 1
            Local $strIndex = 0

            For $i = 1 To $eventCount
                $aResult[$i][0] = $intValues[$intIndex]     ; time1
                $aResult[$i][1] = $intValues[$intIndex + 1] ; time2
                $aResult[$i][2] = $stringValues[$strIndex]  ; name

                ; Update indices
                $intIndex += 2   ; 2 integer values per event (time1, time2)
                $strIndex += 1   ; 1 string value per event (name)
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get guild roster information
Func _Nexus_GuildRosterInfo($infoType, $param = 0)
    Local $paramCount = 1

    If $infoType = $GUILD_ROSTER_INFO_BY_INDEX Then
        $paramCount = 2
    ElseIf $infoType = $GUILD_ROSTER_INFO_BY_NAME Then
        $paramCount = 2
        If Not _PrepareAction($CMD_QUERY, $QUERY_GET_GUILD_ROSTER_INFO, $paramCount) Then Return SetError(1, 0, 0)
        _SetParam(0, $infoType)
        _SetStr256_1($param)  ; Set the name as a string
    Else
        If Not _PrepareAction($CMD_QUERY, $QUERY_GET_GUILD_ROSTER_INFO, $paramCount) Then Return SetError(1, 0, 0)
        _SetParam(0, $infoType)

        If $infoType = $GUILD_ROSTER_INFO_BY_INDEX Then
            _SetParam(1, $param)  ; Index
        EndIf
    EndIf

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $GUILD_ROSTER_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $GUILD_ROSTER_INFO_BY_INDEX, $GUILD_ROSTER_INFO_BY_NAME
            Return _ParseRosterMemberDetails()

        Case $GUILD_ROSTER_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            ; Get the number of members
            Local $memberCount = $intValues[0]

            ; Create a 2D array to store all member information
            Local $aResult[$memberCount + 1][8]
            $aResult[0][0] = $memberCount

            Local $intIndex = 1
            Local $strIndex = 0

            For $i = 1 To $memberCount
                $aResult[$i][0] = $stringValues[$strIndex]     ; Invited Name
                $aResult[$i][1] = $stringValues[$strIndex + 1] ; Current Name
                $aResult[$i][2] = $stringValues[$strIndex + 2] ; Inviter Name
                $aResult[$i][3] = $intValues[$intIndex]        ; Invite Time
                $aResult[$i][4] = $stringValues[$strIndex + 3] ; Promoter Name
                $aResult[$i][5] = $intValues[$intIndex + 1]    ; Offline
                $aResult[$i][6] = $intValues[$intIndex + 2]    ; Member Type
                $aResult[$i][7] = $intValues[$intIndex + 3]    ; Status

                ; Update indices
                $intIndex += 4   ; 4 integer values per member
                $strIndex += 4   ; 4 string values per member
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(5, 0, 0)
    EndSwitch
EndFunc

; Helper function to parse roster member details
Func _ParseRosterMemberDetails()
    Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
    Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

    If @error Or UBound($intValues) < 4 Or UBound($stringValues) < 4 Then
        _CleanupOutput()
        Return SetError(3, 0, 0)
    EndIf

    ; Create the result array
    Local $aResult[8]
    $aResult[0] = $stringValues[0]         ; Invited Name
    $aResult[1] = $stringValues[1]         ; Current Name
    $aResult[2] = $stringValues[2]         ; Inviter Name
    $aResult[3] = $intValues[0]            ; Invite Time
    $aResult[4] = $stringValues[3]         ; Promoter Name
    $aResult[5] = $intValues[1]            ; Offline
    $aResult[6] = $intValues[2]            ; Member Type
    $aResult[7] = $intValues[3]            ; Status

    _CleanupOutput()
    Return $aResult
EndFunc

; Function to get town alliance information
Func _Nexus_TownAllianceInfo($infoType, $index = 0)
    Local $paramCount = 1

    If $infoType = $TOWN_ALLIANCE_INFO_BY_INDEX Then
        $paramCount = 2
    EndIf

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_TOWN_ALLIANCE_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $infoType = $TOWN_ALLIANCE_INFO_BY_INDEX Then
        _SetParam(1, $index)
    EndIf

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $TOWN_ALLIANCE_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $TOWN_ALLIANCE_INFO_BY_INDEX
            Return _ParseTownAllianceDetails()

        Case $TOWN_ALLIANCE_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            ; Get the number of alliances
            Local $allianceCount = $intValues[0]

            ; Create a 2D array to store all alliance information
            Local $aResult[$allianceCount + 1][13]
            $aResult[0][0] = $allianceCount

            Local $intIndex = 1
            Local $strIndex = 0

            For $i = 1 To $allianceCount
                $aResult[$i][0] = $intValues[$intIndex]      ; Rank
                $aResult[$i][1] = $intValues[$intIndex + 1]  ; Allegiance
                $aResult[$i][2] = $intValues[$intIndex + 2]  ; Faction
                $aResult[$i][3] = $stringValues[$strIndex]   ; Name
                $aResult[$i][4] = $stringValues[$strIndex + 1]; Tag
                $aResult[$i][5] = $intValues[$intIndex + 3]  ; Cape BG Color
                $aResult[$i][6] = $intValues[$intIndex + 4]  ; Cape Detail Color
                $aResult[$i][7] = $intValues[$intIndex + 5]  ; Cape Emblem Color
                $aResult[$i][8] = $intValues[$intIndex + 6]  ; Cape Shape
                $aResult[$i][9] = $intValues[$intIndex + 7]  ; Cape Detail
                $aResult[$i][10] = $intValues[$intIndex + 8] ; Cape Emblem
                $aResult[$i][11] = $intValues[$intIndex + 9] ; Cape Trim
                $aResult[$i][12] = $intValues[$intIndex + 10]; Map ID

                ; Update indices
                $intIndex += 11  ; 11 integer values per alliance
                $strIndex += 2   ; 2 string values per alliance
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Helper function to parse town alliance details
Func _ParseTownAllianceDetails()
    Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
    Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

    If @error Or UBound($intValues) < 11 Or UBound($stringValues) < 2 Then
        _CleanupOutput()
        Return SetError(3, 0, 0)
    EndIf

    ; Create the result array
    Local $aResult[13]
    $aResult[0] = $intValues[0]            ; Rank
    $aResult[1] = $intValues[1]            ; Allegiance
    $aResult[2] = $intValues[2]            ; Faction
    $aResult[3] = $stringValues[0]         ; Name
    $aResult[4] = $stringValues[1]         ; Tag
    $aResult[5] = $intValues[3]            ; Cape BG Color
    $aResult[6] = $intValues[4]            ; Cape Detail Color
    $aResult[7] = $intValues[5]            ; Cape Emblem Color
    $aResult[8] = $intValues[6]            ; Cape Shape
    $aResult[9] = $intValues[7]            ; Cape Detail
    $aResult[10] = $intValues[8]           ; Cape Emblem
    $aResult[11] = $intValues[9]           ; Cape Trim
    $aResult[12] = $intValues[10]          ; Map ID

    _CleanupOutput()
    Return $aResult
EndFunc

; Player Guild Information - Wrapper functions
Func _GuildInfo_PlayerName()
    Local $result = _Nexus_GuildInfo($GUILD_INFO_PLAYER_NAME)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _GuildInfo_PlayerGuildIndex()
    Local $result = _Nexus_GuildInfo($GUILD_INFO_PLAYER_GUILD_INDEX)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _GuildInfo_PlayerGuildKey()
    Local $result = _Nexus_GuildInfo($GUILD_INFO_PLAYER_GUILD_KEY)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _GuildInfo_Announcement()
    Local $result = _Nexus_GuildInfo($GUILD_INFO_ANNOUNCEMENT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _GuildInfo_AnnouncementAuthor()
    Local $result = _Nexus_GuildInfo($GUILD_INFO_ANNOUNCEMENT_AUTHOR)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _GuildInfo_PlayerGuildRank()
    Local $result = _Nexus_GuildInfo($GUILD_INFO_PLAYER_GUILD_RANK)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _GuildInfo_KurzickTownCount()
    Local $result = _Nexus_GuildInfo($GUILD_INFO_KURZICK_TOWN_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _GuildInfo_LuxonTownCount()
    Local $result = _Nexus_GuildInfo($GUILD_INFO_LUXON_TOWN_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _GuildInfo_All()
    Local $result = _Nexus_GuildInfo($GUILD_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Guilds Information - Wrapper functions
Func _GuildsInfo_Count()
    Local $result = _Nexus_GuildsInfo($GUILDS_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _GuildsInfo_ByIndex($index)
    Local $result = _Nexus_GuildsInfo($GUILDS_INFO_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _GuildsInfo_ByKey($key1, $key2, $key3, $key4)
    Local $result = _Nexus_GuildsInfo($GUILDS_INFO_BY_KEY, $key1, $key2, $key3, $key4)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _GuildsInfo_All()
    Local $result = _Nexus_GuildsInfo($GUILDS_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Guild History - Wrapper functions
Func _GuildHistory_Count()
    Local $result = _Nexus_GuildHistoryInfo($GUILD_HISTORY_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _GuildHistory_ByIndex($index)
    Local $result = _Nexus_GuildHistoryInfo($GUILD_HISTORY_INFO_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _GuildHistory_All()
    Local $result = _Nexus_GuildHistoryInfo($GUILD_HISTORY_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Guild Roster - Wrapper functions
Func _GuildRoster_Count()
    Local $result = _Nexus_GuildRosterInfo($GUILD_ROSTER_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _GuildRoster_ByIndex($index)
    Local $result = _Nexus_GuildRosterInfo($GUILD_ROSTER_INFO_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _GuildRoster_ByName($name)
    Local $result = _Nexus_GuildRosterInfo($GUILD_ROSTER_INFO_BY_NAME, $name)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _GuildRoster_All()
    Local $result = _Nexus_GuildRosterInfo($GUILD_ROSTER_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Town Alliance - Wrapper functions
Func _TownAlliance_Count()
    Local $result = _Nexus_TownAllianceInfo($TOWN_ALLIANCE_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _TownAlliance_ByIndex($index)
    Local $result = _Nexus_TownAllianceInfo($TOWN_ALLIANCE_INFO_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _TownAlliance_All()
    Local $result = _Nexus_TownAllianceInfo($TOWN_ALLIANCE_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc