#include-once

; Basic Account Info Types
Global Enum $BASIC_ACCOUNT_INFO_ACCOUNT_NAME = 0, _
$BASIC_ACCOUNT_INFO_WINS = 1, _
$BASIC_ACCOUNT_INFO_LOSSES = 2, _
$BASIC_ACCOUNT_INFO_RATING = 3, _
$BASIC_ACCOUNT_INFO_QUALIFIER_POINTS = 4, _
$BASIC_ACCOUNT_INFO_RANK = 5, _
$BASIC_ACCOUNT_INFO_TOURNAMENT_REWARD_POINTS = 6, _
$BASIC_ACCOUNT_INFO_ACCOUNT_FLAGS = 7, _
$BASIC_ACCOUNT_INFO_ALL = 8

; Unlocked Skills Info Types
Global Enum $UNLOCKED_SKILLS_INFO_COUNT = 0, _
$UNLOCKED_SKILLS_INFO_BY_INDEX = 1, _
$UNLOCKED_SKILLS_INFO_ALL = 2

; Unlocked PvP Items Info Types
Global Enum $UNLOCKED_PVP_ITEMS_INFO_COUNT = 0, _
$UNLOCKED_PVP_ITEMS_INFO_BY_INDEX = 1, _
$UNLOCKED_PVP_ITEMS_INFO_ALL = 2

; Unlocked PvP Item Info Types
Global Enum $UNLOCKED_PVP_ITEM_INFO_TYPE_COUNT = 0, _
$UNLOCKED_PVP_ITEM_INFO_TYPE_BY_INDEX = 1, _
$UNLOCKED_PVP_ITEM_INFO_TYPE_ALL = 2

; Unlocked Heroes Info Types
Global Enum $UNLOCKED_HEROES_INFO_COUNT = 0, _
$UNLOCKED_HEROES_INFO_BY_INDEX = 1, _
$UNLOCKED_HEROES_INFO_ALL = 2

; Unlocked Counts Info Types
Global Enum $UNLOCKED_COUNTS_INFO_SIZE = 0, _
$UNLOCKED_COUNTS_INFO_BY_ID = 1, _
$UNLOCKED_COUNTS_INFO_ALL = 2

; Main function to get basic account information
Func _Nexus_BasicAccountInfo($infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_BASIC_ACCOUNT_INFO, 1) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $BASIC_ACCOUNT_INFO_ACCOUNT_NAME
            Local $value = _GetFirstStringValue()
            _CleanupOutput()
            Return $value

        Case $BASIC_ACCOUNT_INFO_WINS, $BASIC_ACCOUNT_INFO_LOSSES, $BASIC_ACCOUNT_INFO_RATING, _
             $BASIC_ACCOUNT_INFO_QUALIFIER_POINTS, $BASIC_ACCOUNT_INFO_RANK, _
             $BASIC_ACCOUNT_INFO_TOURNAMENT_REWARD_POINTS, $BASIC_ACCOUNT_INFO_ACCOUNT_FLAGS
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $BASIC_ACCOUNT_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 7 Or UBound($stringValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aProperties[8] = [ _
                $stringValues[0], _ ;AccountName
                $intValues[0], _ ;Wins
                $intValues[1], _ ;Losses
                $intValues[2], _ ;Rating
                $intValues[3], _ ;QualifierPoints
                $intValues[4], _ ;Rank
                $intValues[5], _ ;TournamentRewardPoints
                $intValues[6]] ;AccountFlags

            _CleanupOutput()
            Return $aProperties

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get unlocked skills information
Func _Nexus_UnlockedSkillsInfo($infoType, $index = 0)
    Local $paramCount = 1
    If $infoType = $UNLOCKED_SKILLS_INFO_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_UNLOCKED_SKILLS_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $index)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $UNLOCKED_SKILLS_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $UNLOCKED_SKILLS_INFO_BY_INDEX
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $UNLOCKED_SKILLS_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = UBound($intValues) - 1
            Local $aResult[$count]

            For $i = 0 To $count - 1
                $aResult[$i] = $intValues[$i]
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get unlocked PvP items information
Func _Nexus_UnlockedPvPItemsInfo($infoType, $index = 0)
    Local $paramCount = 1
    If $infoType = $UNLOCKED_PVP_ITEMS_INFO_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_UNLOCKED_PVP_ITEMS_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $index)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $UNLOCKED_PVP_ITEMS_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $UNLOCKED_PVP_ITEMS_INFO_BY_INDEX
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $UNLOCKED_PVP_ITEMS_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = UBound($intValues) - 1
            Local $aResult[$count]

            For $i = 0 To $count - 1
                $aResult[$i] = $intValues[$i]
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get unlocked PvP item info
Func _Nexus_UnlockedPvPItemInfo($infoType, $index = 0)
    Local $paramCount = 1
    If $infoType = $UNLOCKED_PVP_ITEM_INFO_TYPE_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_UNLOCKED_PVP_ITEM_INFO_TYPE, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $index)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $UNLOCKED_PVP_ITEM_INFO_TYPE_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $UNLOCKED_PVP_ITEM_INFO_TYPE_BY_INDEX
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 3 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[3]
            $aResult[0] = $intValues[0] ; name_id
            $aResult[1] = $intValues[1] ; mod_struct_index
            $aResult[2] = $intValues[2] ; mod_struct_size

            _CleanupOutput()
            Return $aResult

        Case $UNLOCKED_PVP_ITEM_INFO_TYPE_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = UBound($intValues) / 3
            Local $aResult[$count][3]

            For $i = 0 To $count - 1
                $aResult[$i][0] = $intValues[$i * 3] ; name_id
                $aResult[$i][1] = $intValues[$i * 3 + 1] ; mod_struct_index
                $aResult[$i][2] = $intValues[$i * 3 + 2] ; mod_struct_size
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get unlocked heroes information
Func _Nexus_UnlockedHeroesInfo($infoType, $index = 0)
    Local $paramCount = 1
    If $infoType = $UNLOCKED_HEROES_INFO_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_UNLOCKED_HEROES_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $index)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $UNLOCKED_HEROES_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $UNLOCKED_HEROES_INFO_BY_INDEX
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $UNLOCKED_HEROES_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = UBound($intValues) - 1
            Local $aResult[$count]

            For $i = 0 To $count - 1
                $aResult[$i] = $intValues[$i]
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get unlocked counts information
Func _Nexus_UnlockedCountsInfo($infoType, $id = 0)
    Local $paramCount = 1
    If $infoType = $UNLOCKED_COUNTS_INFO_BY_ID Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_UNLOCKED_COUNTS_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $id)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $UNLOCKED_COUNTS_INFO_SIZE
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $UNLOCKED_COUNTS_INFO_BY_ID
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 3 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[3]
            $aResult[0] = $intValues[0] ; id
            $aResult[1] = $intValues[1] ; unk1
            $aResult[2] = $intValues[2] ; unk2

            _CleanupOutput()
            Return $aResult

        Case $UNLOCKED_COUNTS_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = (UBound($intValues) - 1) / 3
            Local $aResult[$count][3]

            For $i = 0 To $count - 1
                $aResult[$i][0] = $intValues[$i * 3] ; id
                $aResult[$i][1] = $intValues[$i * 3 + 1] ; unk1
                $aResult[$i][2] = $intValues[$i * 3 + 2] ; unk2
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Helper functions for basic account info
Func _AccountInfo_AccountName()
    Local $result = _Nexus_BasicAccountInfo($BASIC_ACCOUNT_INFO_ACCOUNT_NAME)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AccountInfo_Wins()
    Local $result = _Nexus_BasicAccountInfo($BASIC_ACCOUNT_INFO_WINS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AccountInfo_Losses()
    Local $result = _Nexus_BasicAccountInfo($BASIC_ACCOUNT_INFO_LOSSES)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AccountInfo_Rating()
    Local $result = _Nexus_BasicAccountInfo($BASIC_ACCOUNT_INFO_RATING)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AccountInfo_QualifierPoints()
    Local $result = _Nexus_BasicAccountInfo($BASIC_ACCOUNT_INFO_QUALIFIER_POINTS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AccountInfo_Rank()
    Local $result = _Nexus_BasicAccountInfo($BASIC_ACCOUNT_INFO_RANK)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AccountInfo_TournamentRewardPoints()
    Local $result = _Nexus_BasicAccountInfo($BASIC_ACCOUNT_INFO_TOURNAMENT_REWARD_POINTS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AccountInfo_AccountFlags()
    Local $result = _Nexus_BasicAccountInfo($BASIC_ACCOUNT_INFO_ACCOUNT_FLAGS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AccountInfo_All()
    Local $result = _Nexus_BasicAccountInfo($BASIC_ACCOUNT_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for unlocked skills
Func _AccountInfo_UnlockedSkillsCount()
    Local $result = _Nexus_UnlockedSkillsInfo($UNLOCKED_SKILLS_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AccountInfo_UnlockedSkillByIndex($index)
    Local $result = _Nexus_UnlockedSkillsInfo($UNLOCKED_SKILLS_INFO_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AccountInfo_AllUnlockedSkills()
    Local $result = _Nexus_UnlockedSkillsInfo($UNLOCKED_SKILLS_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for unlocked PvP items
Func _AccountInfo_UnlockedPvPItemsCount()
    Local $result = _Nexus_UnlockedPvPItemsInfo($UNLOCKED_PVP_ITEMS_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AccountInfo_UnlockedPvPItemByIndex($index)
    Local $result = _Nexus_UnlockedPvPItemsInfo($UNLOCKED_PVP_ITEMS_INFO_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AccountInfo_AllUnlockedPvPItems()
    Local $result = _Nexus_UnlockedPvPItemsInfo($UNLOCKED_PVP_ITEMS_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for unlocked PvP item info
Func _AccountInfo_UnlockedPvPItemInfoCount()
    Local $result = _Nexus_UnlockedPvPItemInfo($UNLOCKED_PVP_ITEM_INFO_TYPE_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AccountInfo_UnlockedPvPItemInfoByIndex($index)
    Local $result = _Nexus_UnlockedPvPItemInfo($UNLOCKED_PVP_ITEM_INFO_TYPE_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AccountInfo_AllUnlockedPvPItemInfo()
    Local $result = _Nexus_UnlockedPvPItemInfo($UNLOCKED_PVP_ITEM_INFO_TYPE_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for unlocked heroes
Func _AccountInfo_UnlockedHeroesCount()
    Local $result = _Nexus_UnlockedHeroesInfo($UNLOCKED_HEROES_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AccountInfo_UnlockedHeroByIndex($index)
    Local $result = _Nexus_UnlockedHeroesInfo($UNLOCKED_HEROES_INFO_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AccountInfo_AllUnlockedHeroes()
    Local $result = _Nexus_UnlockedHeroesInfo($UNLOCKED_HEROES_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for unlocked counts
Func _AccountInfo_UnlockedCountsSize()
    Local $result = _Nexus_UnlockedCountsInfo($UNLOCKED_COUNTS_INFO_SIZE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AccountInfo_UnlockedCountById($id)
    Local $result = _Nexus_UnlockedCountsInfo($UNLOCKED_COUNTS_INFO_BY_ID, $id)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AccountInfo_AllUnlockedCounts()
    Local $result = _Nexus_UnlockedCountsInfo($UNLOCKED_COUNTS_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc