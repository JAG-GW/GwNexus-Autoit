#include-once

; Party Information Types
Global Enum $PARTY_INFO_FLAG = 0, _
           $PARTY_INFO_REQUESTS_COUNT = 1, _
           $PARTY_INFO_SENDING_COUNT = 2, _
           $PARTY_INFO_PARTIES_COUNT = 3, _
           $PARTY_INFO_PLAYER_PARTY = 4, _
           $PARTY_INFO_PARTY_SEARCH_COUNT = 5, _
           $PARTY_INFO_PARTY_SIZE = 18, _
           $PARTY_INFO_PARTY_ALLIES_COUNT = 19, _
           $PARTY_INFO_HERO_FLAGS_COUNT = 22, _
           $PARTY_INFO_HERO_INFO_COUNT = 25, _
           $PARTY_INFO_CONTROLLED_MINION_COUNT = 28, _
           $PARTY_INFO_PLAYER_MORALE_INFO = 31, _
           $PARTY_INFO_PARTY_MORALE_RELATED_COUNT = 32, _
           $PARTY_INFO_PETS_COUNT = 35, _
           $PARTY_INFO_ALL = 38

; Party Members Information Types
Global Enum $PARTY_MEMBERS_INFO_COUNT = 0, _
           $PARTY_MEMBERS_INFO_BY_INDEX = 1, _
           $PARTY_MEMBERS_INFO_ALL = 2

; Party Henchmen Information Types
Global Enum $PARTY_HENCHMEN_INFO_COUNT = 0, _
           $PARTY_HENCHMEN_INFO_BY_INDEX = 1, _
           $PARTY_HENCHMEN_INFO_ALL = 2

; Party Heroes Information Types
Global Enum $PARTY_HEROES_INFO_COUNT = 0, _
           $PARTY_HEROES_INFO_BY_INDEX = 1, _
           $PARTY_HEROES_INFO_ALL = 2

; Party Others Information Types
Global Enum $PARTY_OTHERS_INFO_COUNT = 0, _
           $PARTY_OTHERS_INFO_BY_INDEX = 1, _
           $PARTY_OTHERS_INFO_ALL = 2

; Party Allies Information Types
Global Enum $PARTY_ALLIES_INFO_COUNT = 0, _
           $PARTY_ALLIES_INFO_BY_INDEX = 1, _
           $PARTY_ALLIES_INFO_ALL = 2

; Hero Flags Information Types
Global Enum $HERO_FLAGS_INFO_COUNT = 0, _
           $HERO_FLAGS_INFO_BY_INDEX = 1, _
           $HERO_FLAGS_INFO_ALL = 2

; Hero Information Types
Global Enum $HERO_INFOS_COUNT = 0, _
           $HERO_INFOS_BY_INDEX = 1, _
           $HERO_INFOS_ALL = 2

; Controlled Minions Information Types
Global Enum $CONTROLLED_MINIONS_INFO_COUNT = 0, _
           $CONTROLLED_MINIONS_INFO_BY_INDEX = 1, _
           $CONTROLLED_MINIONS_INFO_ALL = 2

; Party Morale Links Information Types
Global Enum $PARTY_MORALE_LINKS_INFO_COUNT = 0, _
           $PARTY_MORALE_LINKS_INFO_BY_INDEX = 1, _
           $PARTY_MORALE_LINKS_INFO_ALL = 2

; Pets Information Types
Global Enum $PETS_INFO_COUNT = 0, _
           $PETS_INFO_BY_INDEX = 1, _
           $PETS_INFO_ALL = 2

; Party Search Information Types
Global Enum $PARTY_SEARCH_INFO_COUNT = 0, _
           $PARTY_SEARCH_INFO_BY_INDEX = 1, _
           $PARTY_SEARCH_INFO_ALL = 2

; Skillbars Information Types
Global Enum $SKILLBARS_INFO_COUNT = 0, _
           $SKILLBARS_INFO_BY_INDEX = 1, _
           $SKILLBARS_INFO_BY_AGENT_ID = 2, _
           $SKILLBARS_INFO_ALL = 3

; Agent Effects Information Types
Global Enum $AGENT_EFFECTS_INFO_COUNT = 0, _
           $AGENT_EFFECTS_INFO_BY_INDEX = 1, _
           $AGENT_EFFECTS_INFO_BY_AGENT_ID = 2, _
           $AGENT_EFFECTS_INFO_ALL = 3

; Party Attributes Information Types
Global Enum $PARTY_ATTRIBUTES_INFO_COUNT = 0, _
           $PARTY_ATTRIBUTES_INFO_BY_INDEX = 1, _
           $PARTY_ATTRIBUTES_INFO_BY_AGENT_ID = 2, _
           $PARTY_ATTRIBUTES_INFO_ALL = 3

; Main function to get party information
Func _Nexus_PartyInfo($infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_PARTY_INFO, 1) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Local $value = _GetFirstIntValue()
    _CleanupOutput()
    Return $value
EndFunc

; Function to get party members information
Func _Nexus_PartyMembersInfo($infoType, $param = 0)
    Local $paramCount = 1
    If $infoType = $PARTY_MEMBERS_INFO_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_PARTY_MEMBERS_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $param)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $PARTY_MEMBERS_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $PARTY_MEMBERS_INFO_BY_INDEX
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 3 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[3]
            $aResult[0] = $intValues[0]  ; login_number
            $aResult[1] = $intValues[1]  ; calledTargetId
            $aResult[2] = $intValues[2]  ; state

            _CleanupOutput()
            Return $aResult

        Case $PARTY_MEMBERS_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = $intValues[0]
            Local $aResult[$count + 1][3]
            $aResult[0][0] = $count

            Local $index = 1
            For $i = 1 To $count
                $aResult[$i][0] = $intValues[$index]      ; login_number
                $aResult[$i][1] = $intValues[$index + 1]  ; calledTargetId
                $aResult[$i][2] = $intValues[$index + 2]  ; state
                $index += 3
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get party henchmen information
Func _Nexus_PartyHenchmenInfo($infoType, $param = 0)
    Local $paramCount = 1
    If $infoType = $PARTY_HENCHMEN_INFO_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_PARTY_HENCHMEN_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $param)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $PARTY_HENCHMEN_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $PARTY_HENCHMEN_INFO_BY_INDEX
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 3 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[3]
            $aResult[0] = $intValues[0]  ; agent_id
            $aResult[1] = $intValues[1]  ; profession
            $aResult[2] = $intValues[2]  ; level

            _CleanupOutput()
            Return $aResult

        Case $PARTY_HENCHMEN_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = $intValues[0]
            Local $aResult[$count + 1][3]
            $aResult[0][0] = $count

            Local $index = 1
            For $i = 1 To $count
                $aResult[$i][0] = $intValues[$index]      ; agent_id
                $aResult[$i][1] = $intValues[$index + 1]  ; profession
                $aResult[$i][2] = $intValues[$index + 2]  ; level
                $index += 3
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get party heroes information
Func _Nexus_PartyHeroesInfo($infoType, $param = 0)
    Local $paramCount = 1
    If $infoType = $PARTY_HEROES_INFO_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_PARTY_HEROES_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $param)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $PARTY_HEROES_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $PARTY_HEROES_INFO_BY_INDEX
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 4 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[4]
            $aResult[0] = $intValues[0]  ; agent_id
            $aResult[1] = $intValues[1]  ; owner_player_id
            $aResult[2] = $intValues[2]  ; hero_id
            $aResult[3] = $intValues[3]  ; level

            _CleanupOutput()
            Return $aResult

        Case $PARTY_HEROES_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = $intValues[0]
            Local $aResult[$count + 1][4]
            $aResult[0][0] = $count

            Local $index = 1
            For $i = 1 To $count
                $aResult[$i][0] = $intValues[$index]      ; agent_id
                $aResult[$i][1] = $intValues[$index + 1]  ; owner_player_id
                $aResult[$i][2] = $intValues[$index + 2]  ; hero_id
                $aResult[$i][3] = $intValues[$index + 3]  ; level
                $index += 4
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get party others information
Func _Nexus_PartyOthersInfo($infoType, $index = 0)
    Local $paramCount = 1
    If $infoType = $PARTY_OTHERS_INFO_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_PARTY_OTHERS_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $index)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $PARTY_OTHERS_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $PARTY_OTHERS_INFO_BY_INDEX
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

		Case $PARTY_OTHERS_INFO_ALL
			Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
			If @error Or UBound($intValues) < 1 Then
				_CleanupOutput()
				Return SetError(3, 0, 0)
			EndIf

			Local $count = $intValues[0]
			Local $aResult[$count + 1][1]
			$aResult[0][0] = $count

			For $i = 1 To $count
				$aResult[$i][0] = $intValues[$i]
			Next

			_CleanupOutput()
			Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get party allies information
Func _Nexus_PartyAlliesInfo($infoType, $param = 0)
    Local $paramCount = 1
    If $infoType = $PARTY_ALLIES_INFO_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_PARTY_ALLIES_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $param)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $PARTY_ALLIES_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $PARTY_ALLIES_INFO_BY_INDEX
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 3 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[3]
            $aResult[0] = $intValues[0]  ; agent_id
            $aResult[1] = $intValues[1]  ; unk
            $aResult[2] = $intValues[2]  ; composite_id

            _CleanupOutput()
            Return $aResult

        Case $PARTY_ALLIES_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = $intValues[0]
            Local $aResult[$count + 1][3]
            $aResult[0][0] = $count

            Local $index = 1
            For $i = 1 To $count
                $aResult[$i][0] = $intValues[$index]      ; agent_id
                $aResult[$i][1] = $intValues[$index + 1]  ; unk
                $aResult[$i][2] = $intValues[$index + 2]  ; composite_id
                $index += 3
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get hero flags information
Func _Nexus_HeroFlagsInfo($infoType, $index = 0)
    Local $paramCount = 1
    If $infoType = $HERO_FLAGS_INFO_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_HERO_FLAGS_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $index)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $HERO_FLAGS_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $HERO_FLAGS_INFO_BY_INDEX
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $floatValues = _GetTypedValuesByType($VALUE_TYPE_FLOAT)

            If @error Or UBound($intValues) < 7 Or UBound($floatValues) < 2 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[9]
            $aResult[0] = $intValues[0]  ; hero_id
            $aResult[1] = $intValues[1]  ; agent_id
            $aResult[2] = $intValues[2]  ; level
            $aResult[3] = $intValues[3]  ; hero_behavior
            $aResult[4] = $floatValues[0]  ; flag.x
            $aResult[5] = $floatValues[1]  ; flag.y
            $aResult[6] = $intValues[4]  ; h0018
            $aResult[7] = $intValues[5]  ; h001C
            $aResult[8] = $intValues[6]  ; locked_target_id

            _CleanupOutput()
            Return $aResult

        Case $HERO_FLAGS_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $floatValues = _GetTypedValuesByType($VALUE_TYPE_FLOAT)

            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = $intValues[0]
            Local $aResult[$count + 1][9]
            $aResult[0][0] = $count

            Local $intIndex = 1
            Local $floatIndex = 0

            For $i = 1 To $count
                $aResult[$i][0] = $intValues[$intIndex]      ; hero_id
                $aResult[$i][1] = $intValues[$intIndex + 1]  ; agent_id
                $aResult[$i][2] = $intValues[$intIndex + 2]  ; level
                $aResult[$i][3] = $intValues[$intIndex + 3]  ; hero_behavior
                $aResult[$i][4] = $floatValues[$floatIndex]      ; flag.x
                $aResult[$i][5] = $floatValues[$floatIndex + 1]  ; flag.y
                $aResult[$i][6] = $intValues[$intIndex + 4]  ; h0018
                $aResult[$i][7] = $intValues[$intIndex + 5]  ; h001C
                $aResult[$i][8] = $intValues[$intIndex + 6]  ; locked_target_id

                $intIndex += 7
                $floatIndex += 2
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get hero information
Func _Nexus_HeroInfos($infoType, $index = 0)
    Local $paramCount = 1
    If $infoType = $HERO_INFOS_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_HERO_INFOS, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $index)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $HERO_INFOS_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $HERO_INFOS_BY_INDEX
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 7 Or UBound($stringValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[8]
            $aResult[0] = $intValues[0]  ; hero_id
            $aResult[1] = $intValues[1]  ; agent_id
            $aResult[2] = $intValues[2]  ; level
            $aResult[3] = $intValues[3]  ; primary
            $aResult[4] = $intValues[4]  ; secondary
            $aResult[5] = $intValues[5]  ; hero_file_id
            $aResult[6] = $intValues[6]  ; model_file_id
            $aResult[7] = $stringValues[0]  ; name

            _CleanupOutput()
            Return $aResult

        Case $HERO_INFOS_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = $intValues[0]
            Local $aResult[$count + 1][8]
            $aResult[0][0] = $count

            Local $intIndex = 1
            Local $strIndex = 0

            For $i = 1 To $count
                $aResult[$i][0] = $intValues[$intIndex]      ; hero_id
                $aResult[$i][1] = $intValues[$intIndex + 1]  ; agent_id
                $aResult[$i][2] = $intValues[$intIndex + 2]  ; level
                $aResult[$i][3] = $intValues[$intIndex + 3]  ; primary
                $aResult[$i][4] = $intValues[$intIndex + 4]  ; secondary
                $aResult[$i][5] = $intValues[$intIndex + 5]  ; hero_file_id
                $aResult[$i][6] = $intValues[$intIndex + 6]  ; model_file_id
                $aResult[$i][7] = $stringValues[$strIndex]   ; name

                $intIndex += 7
                $strIndex += 1
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get controlled minions information
Func _Nexus_ControlledMinionsInfo($infoType, $param = 0)
    Local $paramCount = 1
    If $infoType = $CONTROLLED_MINIONS_INFO_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_CONTROLLED_MINIONS_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $param)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $CONTROLLED_MINIONS_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $CONTROLLED_MINIONS_INFO_BY_INDEX
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 2 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[2]
            $aResult[0] = $intValues[0]  ; agent_id
            $aResult[1] = $intValues[1]  ; minion_count

            _CleanupOutput()
            Return $aResult

        Case $CONTROLLED_MINIONS_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = $intValues[0]
            Local $aResult[$count + 1][2]
            $aResult[0][0] = $count

            Local $index = 1
            For $i = 1 To $count
                $aResult[$i][0] = $intValues[$index]      ; agent_id
                $aResult[$i][1] = $intValues[$index + 1]  ; minion_count
                $index += 2
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get party morale links information
Func _Nexus_PartyMoraleLinksInfo($infoType, $param = 0)
    Local $paramCount = 1
    If $infoType = $PARTY_MORALE_LINKS_INFO_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_PARTY_MORALE_LINKS_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $param)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $PARTY_MORALE_LINKS_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $PARTY_MORALE_LINKS_INFO_BY_INDEX
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 9 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[9]
            $aResult[0] = $intValues[0]  ; unk
            $aResult[1] = $intValues[1]  ; unk2
            $aResult[2] = $intValues[2]  ; agent_id
            $aResult[3] = $intValues[3]  ; agent_id_dup
            $aResult[4] = $intValues[4]  ; unk[0]
            $aResult[5] = $intValues[5]  ; unk[1]
            $aResult[6] = $intValues[6]  ; unk[2]
            $aResult[7] = $intValues[7]  ; unk[3]
            $aResult[8] = $intValues[8]  ; morale

            _CleanupOutput()
            Return $aResult

        Case $PARTY_MORALE_LINKS_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = $intValues[0]
            Local $aResult[$count + 1][9]
            $aResult[0][0] = $count

            Local $index = 1
            For $i = 1 To $count
                $aResult[$i][0] = $intValues[$index]      ; unk
                $aResult[$i][1] = $intValues[$index + 1]  ; unk2
                $aResult[$i][2] = $intValues[$index + 2]  ; agent_id
                $aResult[$i][3] = $intValues[$index + 3]  ; agent_id_dup
                $aResult[$i][4] = $intValues[$index + 4]  ; unk[0]
                $aResult[$i][5] = $intValues[$index + 5]  ; unk[1]
                $aResult[$i][6] = $intValues[$index + 6]  ; unk[2]
                $aResult[$i][7] = $intValues[$index + 7]  ; unk[3]
                $aResult[$i][8] = $intValues[$index + 8]  ; morale

                $index += 9
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get pets information
Func _Nexus_PetsInfo($infoType, $index = 0)
    Local $paramCount = 1
    If $infoType = $PETS_INFO_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_PETS_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $index)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $PETS_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $PETS_INFO_BY_INDEX
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 6 Or UBound($stringValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[7]
            $aResult[0] = $intValues[0]  ; agent_id
            $aResult[1] = $intValues[1]  ; owner_agent_id
            $aResult[2] = $stringValues[0]  ; pet_name
            $aResult[3] = $intValues[2]  ; model_file_id1
            $aResult[4] = $intValues[3]  ; model_file_id2
            $aResult[5] = $intValues[4]  ; behavior
            $aResult[6] = $intValues[5]  ; locked_target_id

            _CleanupOutput()
            Return $aResult

        Case $PETS_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = $intValues[0]
            Local $aResult[$count + 1][7]
            $aResult[0][0] = $count

            Local $intIndex = 1
            Local $strIndex = 0

            For $i = 1 To $count
                $aResult[$i][0] = $intValues[$intIndex]      ; agent_id
                $aResult[$i][1] = $intValues[$intIndex + 1]  ; owner_agent_id
                $aResult[$i][2] = $stringValues[$strIndex]   ; pet_name
                $aResult[$i][3] = $intValues[$intIndex + 2]  ; model_file_id1
                $aResult[$i][4] = $intValues[$intIndex + 3]  ; model_file_id2
                $aResult[$i][5] = $intValues[$intIndex + 4]  ; behavior
                $aResult[$i][6] = $intValues[$intIndex + 5]  ; locked_target_id

                $intIndex += 6
                $strIndex += 1
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get party search information
Func _Nexus_PartySearchInfo($infoType, $index = 0)
    Local $paramCount = 1
    If $infoType = $PARTY_SEARCH_INFO_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_PARTY_SEARCH_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $index)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $PARTY_SEARCH_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $PARTY_SEARCH_INFO_BY_INDEX
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 11 Or UBound($stringValues) < 2 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[13]
            $aResult[0] = $intValues[0]  ; party_search_id
            $aResult[1] = $intValues[1]  ; party_search_type
            $aResult[2] = $intValues[2]  ; hardmode
            $aResult[3] = $intValues[3]  ; district
            $aResult[4] = $intValues[4]  ; language
            $aResult[5] = $intValues[5]  ; party_size
            $aResult[6] = $intValues[6]  ; hero_count
            $aResult[7] = $stringValues[0]  ; message
            $aResult[8] = $stringValues[1]  ; party_leader
            $aResult[9] = $intValues[7]  ; primary
            $aResult[10] = $intValues[8]  ; secondary
            $aResult[11] = $intValues[9]  ; level
            $aResult[12] = $intValues[10]  ; timestamp

            _CleanupOutput()
            Return $aResult

        Case $PARTY_SEARCH_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = $intValues[0]
            Local $aResult[$count + 1][13]
            $aResult[0][0] = $count

            Local $intIndex = 1
            Local $strIndex = 0

            For $i = 1 To $count
                $aResult[$i][0] = $intValues[$intIndex]      ; party_search_id
                $aResult[$i][1] = $intValues[$intIndex + 1]  ; party_search_type
                $aResult[$i][2] = $intValues[$intIndex + 2]  ; hardmode
                $aResult[$i][3] = $intValues[$intIndex + 3]  ; district
                $aResult[$i][4] = $intValues[$intIndex + 4]  ; language
                $aResult[$i][5] = $intValues[$intIndex + 5]  ; party_size
                $aResult[$i][6] = $intValues[$intIndex + 6]  ; hero_count
                $aResult[$i][7] = $stringValues[$strIndex]   ; message
                $aResult[$i][8] = $stringValues[$strIndex + 1]  ; party_leader
                $aResult[$i][9] = $intValues[$intIndex + 7]  ; primary
                $aResult[$i][10] = $intValues[$intIndex + 8]  ; secondary
                $aResult[$i][11] = $intValues[$intIndex + 9]  ; level
                $aResult[$i][12] = $intValues[$intIndex + 10]  ; timestamp

                $intIndex += 11
                $strIndex += 2
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get skillbars information
; Function to get skillbars information
Func _Nexus_SkillbarsInfo($infoType, $param = 0)
    Local $paramCount = 1
    If $infoType = $SKILLBARS_INFO_BY_INDEX Or $infoType = $SKILLBARS_INFO_BY_AGENT_ID Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_SKILLBARS_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $param)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $SKILLBARS_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $SKILLBARS_INFO_BY_INDEX, $SKILLBARS_INFO_BY_AGENT_ID
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)

            If @error Or UBound($intValues) < 47 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[47]
            $aResult[0] = $intValues[0]  ; agent_id

            ; Skills (8 skills, 5 values each)
            Local $index = 1
            For $i = 0 To 7
                $aResult[$i*5 + 1] = $intValues[$index]      ; adrenaline_a
                $aResult[$i*5 + 2] = $intValues[$index + 1]  ; adrenaline_b
                $aResult[$i*5 + 3] = $intValues[$index + 2]  ; recharge
                $aResult[$i*5 + 4] = $intValues[$index + 3]  ; skill_id
                $aResult[$i*5 + 5] = $intValues[$index + 4]  ; event
                $index += 5
            Next

            ; Additional skillbar info
            $aResult[41] = $intValues[$index]      ; disabled
            $aResult[42] = $intValues[$index + 1]  ; h00A8[0]
            $aResult[43] = $intValues[$index + 2]  ; h00A8[1]
            $aResult[44] = $intValues[$index + 3]  ; casting
            $aResult[45] = $intValues[$index + 4]  ; h00B4[0]
            $aResult[46] = $intValues[$index + 5]  ; h00B4[1]

            _CleanupOutput()
            Return $aResult

        Case $SKILLBARS_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)

            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = $intValues[0]
            Local $aResult[$count + 1][47]
            $aResult[0][0] = $count

            Local $index = 1
            For $i = 1 To $count
                $aResult[$i][0] = $intValues[$index]  ; agent_id
                $index += 1

                ; Skills (8 skills, 5 values each)
                For $j = 0 To 7
                    $aResult[$i][$j*5 + 1] = $intValues[$index]      ; adrenaline_a
                    $aResult[$i][$j*5 + 2] = $intValues[$index + 1]  ; adrenaline_b
                    $aResult[$i][$j*5 + 3] = $intValues[$index + 2]  ; recharge
                    $aResult[$i][$j*5 + 4] = $intValues[$index + 3]  ; skill_id
                    $aResult[$i][$j*5 + 5] = $intValues[$index + 4]  ; event
                    $index += 5
                Next

                ; Additional skillbar info
                $aResult[$i][41] = $intValues[$index]      ; disabled
                $aResult[$i][42] = $intValues[$index + 1]  ; h00A8[0]
                $aResult[$i][43] = $intValues[$index + 2]  ; h00A8[1]
                $aResult[$i][44] = $intValues[$index + 3]  ; casting
                $aResult[$i][45] = $intValues[$index + 4]  ; h00B4[0]
                $aResult[$i][46] = $intValues[$index + 5]  ; h00B4[1]
                $index += 6
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get agent effects information
; Function to get agent effects information
Func _Nexus_AgentEffectsInfo($infoType, $param = 0)
    Local $paramCount = 1
    If $infoType = $AGENT_EFFECTS_INFO_BY_INDEX Or $infoType = $AGENT_EFFECTS_INFO_BY_AGENT_ID Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_AGENT_EFFECTS_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $param)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $AGENT_EFFECTS_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $AGENT_EFFECTS_INFO_BY_INDEX, $AGENT_EFFECTS_INFO_BY_AGENT_ID
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $floatValues = _GetTypedValuesByType($VALUE_TYPE_FLOAT)

            If @error Or UBound($intValues) < 3 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $agent_id = $intValues[0]
            Local $buff_count = $intValues[1]
            Local $effect_count = 0

            Local $index = 2
            Local $buffs[$buff_count + 1][4]
            $buffs[0][0] = $buff_count

            For $i = 0 To $buff_count - 1
                $buffs[$i + 1][0] = $intValues[$index]      ; skill_id
                $buffs[$i + 1][1] = $intValues[$index + 1]  ; h0004
                $buffs[$i + 1][2] = $intValues[$index + 2]  ; buff_id
                $buffs[$i + 1][3] = $intValues[$index + 3]  ; target_agent_id
                $index += 4
            Next

            $effect_count = $intValues[$index]
            $index += 1

            Local $floatIndex = 0
            Local $effects[$effect_count + 1][6]
            $effects[0][0] = $effect_count

            For $i = 0 To $effect_count - 1
                $effects[$i + 1][0] = $intValues[$index]      ; skill_id
                $effects[$i + 1][1] = $intValues[$index + 1]  ; attribute_level
                $effects[$i + 1][2] = $intValues[$index + 2]  ; effect_id
                $effects[$i + 1][3] = $intValues[$index + 3]  ; agent_id
                $effects[$i + 1][4] = $floatValues[$floatIndex]  ; duration
                $effects[$i + 1][5] = $intValues[$index + 4]  ; timestamp

                $index += 5
                $floatIndex += 1
            Next

            Local $aResult[4]
            $aResult[0] = $agent_id
            $aResult[1] = $buff_count
            $aResult[2] = $buffs
            $aResult[3] = $effects

            _CleanupOutput()
            Return $aResult

        Case $AGENT_EFFECTS_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $floatValues = _GetTypedValuesByType($VALUE_TYPE_FLOAT)

            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = $intValues[0]
            Local $aResult[$count + 1][4]
            $aResult[0][0] = $count

            Local $index = 1
            Local $floatIndex = 0

            For $i = 1 To $count
                Local $agent_id = $intValues[$index]
                Local $buff_count = $intValues[$index + 1]
                $index += 2

                Local $buffs[$buff_count + 1][4]
                $buffs[0][0] = $buff_count

                For $j = 0 To $buff_count - 1
                    $buffs[$j + 1][0] = $intValues[$index]      ; skill_id
                    $buffs[$j + 1][1] = $intValues[$index + 1]  ; h0004
                    $buffs[$j + 1][2] = $intValues[$index + 2]  ; buff_id
                    $buffs[$j + 1][3] = $intValues[$index + 3]  ; target_agent_id
                    $index += 4
                Next

                Local $effect_count = $intValues[$index]
                $index += 1

                Local $effects[$effect_count + 1][6]
                $effects[0][0] = $effect_count

                For $j = 0 To $effect_count - 1
                    $effects[$j + 1][0] = $intValues[$index]      ; skill_id
                    $effects[$j + 1][1] = $intValues[$index + 1]  ; attribute_level
                    $effects[$j + 1][2] = $intValues[$index + 2]  ; effect_id
                    $effects[$j + 1][3] = $intValues[$index + 3]  ; agent_id
                    $effects[$j + 1][4] = $floatValues[$floatIndex]  ; duration
                    $effects[$j + 1][5] = $intValues[$index + 4]  ; timestamp

                    $index += 5
                    $floatIndex += 1
                Next

                $aResult[$i][0] = $agent_id
                $aResult[$i][1] = $buff_count
                $aResult[$i][2] = $buffs
                $aResult[$i][3] = $effects
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get party attributes information
Func _Nexus_PartyAttributesInfo($infoType, $param = 0)
    Local $paramCount = 1
    If $infoType = $PARTY_ATTRIBUTES_INFO_BY_INDEX Or $infoType = $PARTY_ATTRIBUTES_INFO_BY_AGENT_ID Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_PARTY_ATTRIBUTES_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $param)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $PARTY_ATTRIBUTES_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $PARTY_ATTRIBUTES_INFO_BY_INDEX, $PARTY_ATTRIBUTES_INFO_BY_AGENT_ID
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)

            If @error Or UBound($intValues) < 2 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $agent_id = $intValues[0]
            Local $attr_count = $intValues[1]

            Local $aResult[$attr_count + 2]
            $aResult[0] = $agent_id
            $aResult[1] = $attr_count

            Local $index = 2
            For $i = 0 To $attr_count - 1
                Local $attr[6]
                $attr[0] = $intValues[$index]      ; attribute_index
                $attr[1] = $intValues[$index + 1]  ; id
                $attr[2] = $intValues[$index + 2]  ; level_base
                $attr[3] = $intValues[$index + 3]  ; level
                $attr[4] = $intValues[$index + 4]  ; decrement_points
                $attr[5] = $intValues[$index + 5]  ; increment_points

                $aResult[$i + 2] = $attr
                $index += 6
            Next

            _CleanupOutput()
            Return $aResult

        Case $PARTY_ATTRIBUTES_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)

            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = $intValues[0]
            Local $aResult[$count + 1][2]
            $aResult[0][0] = $count

            Local $index = 1
            For $i = 1 To $count
                Local $agent_id = $intValues[$index]
                Local $attr_count = $intValues[$index + 1]
                $index += 2

                Local $attributes[$attr_count + 2][6]
                $attributes[0][0] = $agent_id
                $attributes[1][0] = $attr_count

                For $j = 0 To $attr_count - 1
                    $attributes[$j + 2][0] = $intValues[$index]      ; attribute_index
                    $attributes[$j + 2][1] = $intValues[$index + 1]  ; id
                    $attributes[$j + 2][2] = $intValues[$index + 2]  ; level_base
                    $attributes[$j + 2][3] = $intValues[$index + 3]  ; level
                    $attributes[$j + 2][4] = $intValues[$index + 4]  ; decrement_points
                    $attributes[$j + 2][5] = $intValues[$index + 5]  ; increment_points
                    $index += 6
                Next

                $aResult[$i][0] = $agent_id
                $aResult[$i][1] = $attributes
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Helper functions for party information
Func _Party_Flag()
    Local $result = _Nexus_PartyInfo($PARTY_INFO_FLAG)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Party_RequestsCount()
    Local $result = _Nexus_PartyInfo($PARTY_INFO_REQUESTS_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Party_SendingCount()
    Local $result = _Nexus_PartyInfo($PARTY_INFO_SENDING_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Party_PartiesCount()
    Local $result = _Nexus_PartyInfo($PARTY_INFO_PARTIES_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Party_PlayerParty()
    Local $result = _Nexus_PartyInfo($PARTY_INFO_PLAYER_PARTY)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Party_PartySearchCount()
    Local $result = _Nexus_PartyInfo($PARTY_INFO_PARTY_SEARCH_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Party_Size()
    Local $result = _Nexus_PartyInfo($PARTY_INFO_PARTY_SIZE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Party_AlliesCount()
    Local $result = _Nexus_PartyInfo($PARTY_INFO_PARTY_ALLIES_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Party_HeroFlagsCount()
    Local $result = _Nexus_PartyInfo($PARTY_INFO_HERO_FLAGS_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Party_HeroInfoCount()
    Local $result = _Nexus_PartyInfo($PARTY_INFO_HERO_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Party_ControlledMinionCount()
    Local $result = _Nexus_PartyInfo($PARTY_INFO_CONTROLLED_MINION_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Party_MoraleRelatedCount()
    Local $result = _Nexus_PartyInfo($PARTY_INFO_PARTY_MORALE_RELATED_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Party_PetsCount()
    Local $result = _Nexus_PartyInfo($PARTY_INFO_PETS_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc