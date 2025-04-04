#include-once

; Character Information Types
Global Enum $CHAR_INFO_PLAYER_AGENT_ID = 0, _
$CHAR_INFO_PLAYER_NAME = 1, _
$CHAR_INFO_PLAYER_UUID = 2, _
$CHAR_INFO_WORLD_FLAGS = 3, _
$CHAR_INFO_TOKEN1 = 4, _
$CHAR_INFO_MAP_ID = 5, _
$CHAR_INFO_IS_EXPLORABLE = 6, _
$CHAR_INFO_TOKEN2 = 7, _
$CHAR_INFO_DISTRICT_NUMBER = 8, _
$CHAR_INFO_LANGUAGE = 9, _
$CHAR_INFO_OBSERVE_MAP_ID = 10, _
$CHAR_INFO_CURRENT_MAP_ID = 11, _
$CHAR_INFO_OBSERVE_MAP_TYPE = 12, _
$CHAR_INFO_CURRENT_MAP_TYPE = 13, _
$CHAR_INFO_PLAYER_FLAGS = 14, _
$CHAR_INFO_PLAYER_NUMBER = 15, _
$CHAR_INFO_PLAYER_EMAIL = 16, _
$CHAR_INFO_ALL = 17

; Observer Match Information Types
Global Enum $OBSERVER_MATCH_INFO_COUNT = 0, _
$OBSERVER_MATCH_INFO_BY_INDEX = 1, _
$OBSERVER_MATCH_INFO_ALL = 2

; Main function to get character information
Func _Nexus_CharacterInfo($infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_CHAR_INFO, 1) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $CHAR_INFO_PLAYER_NAME, $CHAR_INFO_PLAYER_EMAIL
            Local $value = _GetFirstStringValue()
            _CleanupOutput()
            Return $value

        Case $CHAR_INFO_PLAYER_UUID
            Local $values = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($values) < 4 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[4]
            For $i = 0 To 3
                $aResult[$i] = $values[$i]
            Next

            _CleanupOutput()
            Return $aResult

        Case $CHAR_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 18 Or UBound($stringValues) < 2 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aProperties[20] = [ _
                $intValues[0], _ ;PlayerAgentID
                $stringValues[0], _ ;PlayerName
                $intValues[1], _ ;PlayerUUID1
                $intValues[2], _ ;PlayerUUID2
                $intValues[3], _ ;PlayerUUID3
                $intValues[4], _ ;PlayerUUID4
                $intValues[5], _ ;WorldFlags
                $intValues[6], _ ;Token1
                $intValues[7], _ ;MapID
                $intValues[8], _ ;IsExplorable
                $intValues[9], _ ;Token2
                $intValues[10], _ ;DistrictNumber
                $intValues[11], _ ;Language
                $intValues[12], _ ;ObserveMapID
                $intValues[13], _ ;CurrentMapID
                $intValues[14], _ ;ObserveMapType
                $intValues[15], _ ;CurrentMapType
                $intValues[16], _ ;PlayerFlags
                $intValues[17], _ ;PlayerNumber
                $stringValues[1]] ;PlayerEmail

            _CleanupOutput()
            Return $aProperties

        Case Else
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value
    EndSwitch
EndFunc

; Function to get observer match information
Func _Nexus_ObserverMatchInfo($infoType, $index = 0)
    Local $paramCount = 1
    If $infoType = $OBSERVER_MATCH_INFO_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_MATCH_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $index)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $OBSERVER_MATCH_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $OBSERVER_MATCH_INFO_BY_INDEX
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 16 Or UBound($stringValues) < 2 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[18] = [ _
                $intValues[0], _ ;MatchID
                $intValues[1], _ ;MatchIDDup
                $intValues[2], _ ;MapID
                $intValues[3], _ ;Age
                $intValues[4], _ ;FlagsType
                $intValues[5], _ ;FlagsReserved
                $intValues[6], _ ;FlagsVersion
                $intValues[7], _ ;FlagsState
                $intValues[8], _ ;FlagsLevel
                $intValues[9], _ ;FlagsConfig1
                $intValues[10], _ ;FlagsConfig2
                $intValues[11], _ ;FlagsScore1
                $intValues[12], _ ;FlagsScore2
                $intValues[13], _ ;FlagsScore3
                $intValues[14], _ ;FlagsStat1
                $intValues[15], _ ;FlagsStat2
                $stringValues[0], _ ;Team1Name
                $stringValues[1]] ;Team2Name

            _CleanupOutput()
            Return $aResult

		Case $OBSERVER_MATCH_INFO_ALL
			Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
			Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)
			If @error Or UBound($intValues) < 1 Then
				_CleanupOutput()
				Return SetError(3, 0, 0)
			EndIf

			Local $matchCount = $intValues[0]
			Local $aResult[$matchCount + 1][20]  ; Use a 2D array for better organization
			$aResult[0][0] = $matchCount

			Local $intIndex = 1
			Local $strIndex = 0

			For $i = 1 To $matchCount
				$aResult[$i][0] = $intValues[$intIndex]      ; match_id
				$aResult[$i][1] = $intValues[$intIndex + 1]  ; match_id_dup
				$aResult[$i][2] = $intValues[$intIndex + 2]  ; map_id
				$aResult[$i][3] = $intValues[$intIndex + 3]  ; age
				$aResult[$i][4] = $intValues[$intIndex + 4]  ; flags.type
				$aResult[$i][5] = $intValues[$intIndex + 5]  ; flags.reserved
				$aResult[$i][6] = $intValues[$intIndex + 6]  ; flags.version
				$aResult[$i][7] = $intValues[$intIndex + 7]  ; flags.state
				$aResult[$i][8] = $intValues[$intIndex + 8]  ; flags.level
				$aResult[$i][9] = $intValues[$intIndex + 9]  ; flags.config1
				$aResult[$i][10] = $intValues[$intIndex + 10] ; flags.config2
				$aResult[$i][11] = $intValues[$intIndex + 11] ; flags.score1
				$aResult[$i][12] = $intValues[$intIndex + 12] ; flags.score2
				$aResult[$i][13] = $intValues[$intIndex + 13] ; flags.score3
				$aResult[$i][14] = $intValues[$intIndex + 14] ; flags.stat1
				$aResult[$i][15] = $intValues[$intIndex + 15] ; flags.stat2
				$aResult[$i][16] = $intValues[$intIndex + 16] ; flags.data1
				$aResult[$i][17] = $intValues[$intIndex + 17] ; flags.data2

				$aResult[$i][18] = $stringValues[$strIndex]    ; Team1Name
				$aResult[$i][19] = $stringValues[$strIndex + 1] ; Team2Name

				$intIndex += 18  ; Updated to match the 18 integer values sent by DLL
				$strIndex += 2
			Next

			_CleanupOutput()
			Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Helper functions for character information
Func _Character_PlayerAgentID()
    Local $result = _Nexus_CharacterInfo($CHAR_INFO_PLAYER_AGENT_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Character_PlayerName()
    Local $result = _Nexus_CharacterInfo($CHAR_INFO_PLAYER_NAME)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Character_PlayerUUID()
    Local $result = _Nexus_CharacterInfo($CHAR_INFO_PLAYER_UUID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Character_WorldFlags()
    Local $result = _Nexus_CharacterInfo($CHAR_INFO_WORLD_FLAGS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Character_Token1()
    Local $result = _Nexus_CharacterInfo($CHAR_INFO_TOKEN1)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Character_MapID()
    Local $result = _Nexus_CharacterInfo($CHAR_INFO_MAP_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Character_IsExplorable()
    Local $result = _Nexus_CharacterInfo($CHAR_INFO_IS_EXPLORABLE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Character_Token2()
    Local $result = _Nexus_CharacterInfo($CHAR_INFO_TOKEN2)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Character_DistrictNumber()
    Local $result = _Nexus_CharacterInfo($CHAR_INFO_DISTRICT_NUMBER)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Character_Language()
    Local $result = _Nexus_CharacterInfo($CHAR_INFO_LANGUAGE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Character_ObserveMapID()
    Local $result = _Nexus_CharacterInfo($CHAR_INFO_OBSERVE_MAP_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Character_CurrentMapID()
    Local $result = _Nexus_CharacterInfo($CHAR_INFO_CURRENT_MAP_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Character_ObserveMapType()
    Local $result = _Nexus_CharacterInfo($CHAR_INFO_OBSERVE_MAP_TYPE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Character_CurrentMapType()
    Local $result = _Nexus_CharacterInfo($CHAR_INFO_CURRENT_MAP_TYPE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Character_PlayerFlags()
    Local $result = _Nexus_CharacterInfo($CHAR_INFO_PLAYER_FLAGS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Character_PlayerNumber()
    Local $result = _Nexus_CharacterInfo($CHAR_INFO_PLAYER_NUMBER)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Character_PlayerEmail()
    Local $result = _Nexus_CharacterInfo($CHAR_INFO_PLAYER_EMAIL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Character_All()
    Local $result = _Nexus_CharacterInfo($CHAR_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for observer match information
Func _ObserverMatch_Count()
    Local $result = _Nexus_ObserverMatchInfo($OBSERVER_MATCH_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ObserverMatch_ByIndex($index)
    Local $result = _Nexus_ObserverMatchInfo($OBSERVER_MATCH_INFO_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ObserverMatch_All()
    Local $result = _Nexus_ObserverMatchInfo($OBSERVER_MATCH_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc