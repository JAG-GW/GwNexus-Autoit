#include-once

; World Context Information Types
Global Enum $WORLD_INFO_ACTIVE_QUEST_ID = 0, _
           $WORLD_INFO_QUEST_LOG_COUNT = 1, _
           $WORLD_INFO_QUEST_BY_INDEX = 2, _
           $WORLD_INFO_ALL_QUESTS = 3, _
           $WORLD_INFO_MISSIONS_COMPLETED = 4, _
           $WORLD_INFO_MISSIONS_BONUS = 5, _
           $WORLD_INFO_MISSIONS_COMPLETED_HM = 6, _
           $WORLD_INFO_MISSIONS_BONUS_HM = 7, _
           $WORLD_INFO_KURZICK = 8, _
           $WORLD_INFO_LUXON = 9, _
           $WORLD_INFO_IMPERIAL = 10, _
           $WORLD_INFO_BALTHAZAR = 11, _
           $WORLD_INFO_EXPERIENCE = 12, _
           $WORLD_INFO_LEVEL = 13, _
           $WORLD_INFO_SKILL_POINTS = 14, _
           $WORLD_INFO_HARD_MODE_UNLOCKED = 15, _
           $WORLD_INFO_PROFESSION_STATES_COUNT = 16, _
           $WORLD_INFO_PROFESSION_STATE_BY_INDEX = 17, _
           $WORLD_INFO_LEARNABLE_SKILLS_COUNT = 18, _
           $WORLD_INFO_UNLOCKED_SKILLS_COUNT = 19, _
           $WORLD_INFO_CARTOGRAPHED_AREAS_COUNT = 20, _
           $WORLD_INFO_VANQUISHED_AREAS_COUNT = 21, _
           $WORLD_INFO_VANQUISH_PROGRESS = 22, _
           $WORLD_INFO_NPCS_COUNT = 23, _
           $WORLD_INFO_NPC_BY_INDEX = 24, _
           $WORLD_INFO_PLAYERS_COUNT = 25, _
           $WORLD_INFO_PLAYER_BY_INDEX = 26, _
           $WORLD_INFO_TITLES_COUNT = 27, _
           $WORLD_INFO_TITLE_BY_INDEX = 28, _
           $WORLD_INFO_TITLE_TIERS_COUNT = 29, _
           $WORLD_INFO_ALL_BASIC_INFO = 30

; Quest Information Types
Global Enum $QUEST_INFO_COUNT = 0, _
           $QUEST_INFO_BY_INDEX = 1, _
           $QUEST_INFO_BY_ID = 2, _
           $QUEST_INFO_ACTIVE_QUEST = 3, _
           $QUEST_INFO_PRIMARY_QUESTS = 4, _
           $QUEST_INFO_COMPLETED_QUESTS = 5, _
           $QUEST_INFO_ALL = 6

; NPC Information Types
Global Enum $NPC_INFO_COUNT = 0, _
           $NPC_INFO_BY_INDEX = 1, _
           $NPC_INFO_BY_MODEL_ID = 2, _
           $NPC_INFO_HENCHMEN = 3, _
           $NPC_INFO_HEROES = 4, _
           $NPC_INFO_ALL = 5

; Player Information Types
Global Enum $PLAYER_INFO_COUNT = 0, _
           $PLAYER_INFO_BY_INDEX = 1, _
           $PLAYER_INFO_BY_NAME = 2, _
           $PLAYER_INFO_BY_AGENT_ID = 3, _
           $PLAYER_INFO_LEADER = 4, _
           $PLAYER_INFO_ALL = 5

; Title Information Types
Global Enum $TITLE_INFO_COUNT = 0, _
           $TITLE_INFO_BY_INDEX = 1, _
           $TITLE_INFO_BY_ID = 2, _
           $TITLE_INFO_ACTIVE_TITLE = 3, _
           $TITLE_INFO_MAXED_TITLES = 4, _
           $TITLE_INFO_ALL = 5

; Profession State Information Types
Global Enum $PROFESSION_STATE_INFO_COUNT = 0, _
           $PROFESSION_STATE_INFO_BY_INDEX = 1, _
           $PROFESSION_STATE_INFO_BY_AGENT_ID = 2, _
           $PROFESSION_STATE_INFO_ALL = 3

; Main function to get world context information
Func _Nexus_WorldContextInfo($infoType, $param = 0)
    Local $paramCount = 1

    If $infoType = $WORLD_INFO_QUEST_BY_INDEX Or $infoType = $WORLD_INFO_PROFESSION_STATE_BY_INDEX Or _
       $infoType = $WORLD_INFO_NPC_BY_INDEX Or $infoType = $WORLD_INFO_PLAYER_BY_INDEX Or _
       $infoType = $WORLD_INFO_TITLE_BY_INDEX Then
        $paramCount = 2
    EndIf

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_WORLD_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then
        _SetParam(1, $param)
    EndIf

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $WORLD_INFO_ACTIVE_QUEST_ID, $WORLD_INFO_QUEST_LOG_COUNT, $WORLD_INFO_EXPERIENCE, $WORLD_INFO_LEVEL, _
             $WORLD_INFO_HARD_MODE_UNLOCKED, $WORLD_INFO_PROFESSION_STATES_COUNT, $WORLD_INFO_LEARNABLE_SKILLS_COUNT, _
             $WORLD_INFO_UNLOCKED_SKILLS_COUNT, $WORLD_INFO_CARTOGRAPHED_AREAS_COUNT, $WORLD_INFO_VANQUISHED_AREAS_COUNT, _
             $WORLD_INFO_NPCS_COUNT, $WORLD_INFO_PLAYERS_COUNT, $WORLD_INFO_TITLES_COUNT, $WORLD_INFO_TITLE_TIERS_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $WORLD_INFO_VANQUISH_PROGRESS
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 2 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[2] = [$intValues[0], $intValues[1]]  ; foes_killed, foes_to_kill
            _CleanupOutput()
            Return $aResult

        Case $WORLD_INFO_SKILL_POINTS
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 2 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[2] = [$intValues[0], $intValues[1]]  ; current_skill_points, total_earned_skill_points
            _CleanupOutput()
            Return $aResult

        Case $WORLD_INFO_KURZICK, $WORLD_INFO_LUXON, $WORLD_INFO_IMPERIAL, $WORLD_INFO_BALTHAZAR
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 3 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[3] = [$intValues[0], $intValues[1], $intValues[2]]  ; current, total_earned, max
            _CleanupOutput()
            Return $aResult

        Case $WORLD_INFO_MISSIONS_COMPLETED, $WORLD_INFO_MISSIONS_BONUS, $WORLD_INFO_MISSIONS_COMPLETED_HM, $WORLD_INFO_MISSIONS_BONUS_HM
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = $intValues[0]
            Local $aResult[$count]

            For $i = 0 To $count - 1
                $aResult[$i] = $intValues[$i + 1]
            Next

            _CleanupOutput()
            Return $aResult

        Case $WORLD_INFO_QUEST_BY_INDEX
            Return _ParseQuestDetails()

        Case $WORLD_INFO_ALL_QUESTS
			Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
			Local $floatValues = _GetTypedValuesByType($VALUE_TYPE_FLOAT)
			Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

			If @error Or UBound($intValues) < 1 Then
				_CleanupOutput()
				Return SetError(3, 0, 0)
			EndIf

			Local $questCount = $intValues[0]
			; Create a 2D array to store all quest information
			Local $aResult[$questCount + 1][12]
			$aResult[0][0] = $questCount

			Local $intIndex = 1
			Local $floatIndex = 0
			Local $stringIndex = 0

			For $i = 1 To $questCount
				$aResult[$i][0] = $intValues[$intIndex]          ; quest_id
				$aResult[$i][1] = $intValues[$intIndex + 1]      ; log_state
				$aResult[$i][2] = $intValues[$intIndex + 2]      ; map_from
				$aResult[$i][3] = $intValues[$intIndex + 3]      ; map_to
				$aResult[$i][4] = $floatValues[$floatIndex]      ; marker.x
				$aResult[$i][5] = $floatValues[$floatIndex + 1]  ; marker.y
				$aResult[$i][6] = $floatValues[$floatIndex + 2]  ; marker.zplane
				$aResult[$i][7] = $stringValues[$stringIndex]    ; location
				$aResult[$i][8] = $stringValues[$stringIndex + 1]; name
				$aResult[$i][9] = $stringValues[$stringIndex + 2]; npc
				$aResult[$i][10] = $stringValues[$stringIndex + 3]; description
				$aResult[$i][11] = $stringValues[$stringIndex + 4]; objectives

				$intIndex += 4   ; quest_id, log_state, map_from, map_to
				$floatIndex += 3  ; marker.x, marker.y, marker.zplane
				$stringIndex += 5  ; location, name, npc, description, objectives
			Next

			_CleanupOutput()
			Return $aResult

        Case $WORLD_INFO_NPC_BY_INDEX
            Return _ParseNPCDetails()

        Case $WORLD_INFO_PLAYER_BY_INDEX
            Return _ParsePlayerDetails()

        Case $WORLD_INFO_TITLE_BY_INDEX
            Return _ParseTitleDetails()

        Case $WORLD_INFO_PROFESSION_STATE_BY_INDEX
            Return _ParseProfessionStateDetails()

        Case $WORLD_INFO_ALL_BASIC_INFO
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 15 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[15]
            $aResult[0] = $intValues[0]    ; active_quest_id
            $aResult[1] = $intValues[1]    ; experience
            $aResult[2] = $intValues[2]    ; level
            $aResult[3] = $intValues[3]    ; current_kurzick
            $aResult[4] = $intValues[4]    ; current_luxon
            $aResult[5] = $intValues[5]    ; current_imperial
            $aResult[6] = $intValues[6]    ; current_balth
            $aResult[7] = $intValues[7]    ; current_skill_points
            $aResult[8] = $intValues[8]    ; is_hard_mode_unlocked
            $aResult[9] = $intValues[9]    ; quest_log_size
            $aResult[10] = $intValues[10]  ; npcs_size
            $aResult[11] = $intValues[11]  ; players_size
            $aResult[12] = $intValues[12]  ; titles_size
            $aResult[13] = $intValues[13]  ; foes_killed
            $aResult[14] = $intValues[14]  ; foes_to_kill

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get quest information
Func _Nexus_QuestInfo($infoType, $param = 0)
    Local $paramCount = 1

    If $infoType = $QUEST_INFO_BY_INDEX Or $infoType = $QUEST_INFO_BY_ID Then
        $paramCount = 2
    EndIf

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_QUEST_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then
        _SetParam(1, $param)
    EndIf

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $QUEST_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $QUEST_INFO_BY_INDEX, $QUEST_INFO_BY_ID, $QUEST_INFO_ACTIVE_QUEST
            Return _ParseQuestDetails()

		Case $QUEST_INFO_PRIMARY_QUESTS, $QUEST_INFO_COMPLETED_QUESTS
				Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
				Local $floatValues = _GetTypedValuesByType($VALUE_TYPE_FLOAT)
				Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

				If @error Or UBound($intValues) < 1 Then
					_CleanupOutput()
					Return SetError(3, 0, 0)
				EndIf

				Local $questCount = $intValues[0]
				; Create a 2D array to store all quest information
				Local $aResult[$questCount + 1][12]
				$aResult[0][0] = $questCount

				Local $intIndex = 1
				Local $floatIndex = 0
				Local $stringIndex = 0

				For $i = 1 To $questCount
					$aResult[$i][0] = $intValues[$intIndex]          ; quest_id
					$aResult[$i][1] = $intValues[$intIndex + 1]      ; log_state
					$aResult[$i][2] = $intValues[$intIndex + 2]      ; map_from
					$aResult[$i][3] = $intValues[$intIndex + 3]      ; map_to
					$aResult[$i][4] = $floatValues[$floatIndex]      ; marker.x
					$aResult[$i][5] = $floatValues[$floatIndex + 1]  ; marker.y
					$aResult[$i][6] = $floatValues[$floatIndex + 2]  ; marker.zplane
					$aResult[$i][7] = $stringValues[$stringIndex]    ; location
					$aResult[$i][8] = $stringValues[$stringIndex + 1]; name
					$aResult[$i][9] = $stringValues[$stringIndex + 2]; npc
					$aResult[$i][10] = $stringValues[$stringIndex + 3]; description
					$aResult[$i][11] = $stringValues[$stringIndex + 4]; objectives

					$intIndex += 4   ; quest_id, log_state, map_from, map_to
					$floatIndex += 3  ; marker.x, marker.y, marker.zplane
					$stringIndex += 5  ; location, name, npc, description, objectives
				Next

				_CleanupOutput()
				Return $aResult

        Case $QUEST_INFO_ALL
            Return _ParseAllQuests()

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get NPC information
Func _Nexus_NPCInfo($infoType, $param = 0)
    Local $paramCount = 1

    If $infoType = $NPC_INFO_BY_INDEX Or $infoType = $NPC_INFO_BY_MODEL_ID Then
        $paramCount = 2
    EndIf

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_NPC_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then
        _SetParam(1, $param)
    EndIf

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $NPC_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $NPC_INFO_BY_INDEX
            Return _ParseNPCDetails()

        Case $NPC_INFO_BY_MODEL_ID, $NPC_INFO_HENCHMEN, $NPC_INFO_HEROES
			Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
			Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

			If @error Or UBound($intValues) < 1 Then
				_CleanupOutput()
				Return SetError(3, 0, 0)
			EndIf

			Local $npcCount = $intValues[0]
			; Create a 2D array to store all NPC information
			Local $aResult[$npcCount + 1][8]
			$aResult[0][0] = $npcCount

			Local $intIndex = 1
			Local $stringIndex = 0

			For $i = 1 To $npcCount
				$aResult[$i][0] = $intValues[$intIndex]      ; model_file_id
				$aResult[$i][1] = $intValues[$intIndex + 1]  ; scale
				$aResult[$i][2] = $intValues[$intIndex + 2]  ; sex
				$aResult[$i][3] = $intValues[$intIndex + 3]  ; npc_flags
				$aResult[$i][4] = $intValues[$intIndex + 4]  ; primary
				$aResult[$i][5] = $intValues[$intIndex + 5]  ; default_level
				$aResult[$i][6] = $stringValues[$stringIndex]; name
				$aResult[$i][7] = $intValues[$intIndex + 6]  ; files_count

				$intIndex += 7   ; 7 integer values per NPC
				$stringIndex += 1  ; 1 string value per NPC
			Next

			_CleanupOutput()
			Return $aResult

        Case $NPC_INFO_ALL
            Return _ParseAllNPCs()

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get player information
Func _Nexus_PlayerInfo($infoType, $param = 0)
    Local $paramCount = 1

    If $infoType = $PLAYER_INFO_BY_INDEX Or $infoType = $PLAYER_INFO_BY_AGENT_ID Then
        $paramCount = 2
    ElseIf $infoType = $PLAYER_INFO_BY_NAME Then
        $paramCount = 2
        If Not _PrepareAction($CMD_QUERY, $QUERY_GET_PLAYER_INFO, $paramCount) Then Return SetError(1, 0, 0)
        _SetParam(0, $infoType)
        _SetStr256_1($param)  ; Set the name as a string
    Else
        If Not _PrepareAction($CMD_QUERY, $QUERY_GET_PLAYER_INFO, $paramCount) Then Return SetError(1, 0, 0)
        _SetParam(0, $infoType)

        If $infoType = $PLAYER_INFO_BY_INDEX Or $infoType = $PLAYER_INFO_BY_AGENT_ID Then
            _SetParam(1, $param)
        EndIf
    EndIf

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $PLAYER_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $PLAYER_INFO_BY_INDEX, $PLAYER_INFO_BY_NAME, $PLAYER_INFO_BY_AGENT_ID, $PLAYER_INFO_LEADER
            Return _ParsePlayerDetails()

        Case $PLAYER_INFO_ALL
			Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
			Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

			If @error Or UBound($intValues) < 1 Then
				_CleanupOutput()
				Return SetError(3, 0, 0)
			EndIf

			Local $playerCount = $intValues[0]
			; Create a 2D array to store all player information
			Local $aResult[$playerCount + 1][10]
			$aResult[0][0] = $playerCount

			Local $intIndex = 1
			Local $stringIndex = 0

			For $i = 1 To $playerCount
				$aResult[$i][0] = $intValues[$intIndex]      ; agent_id
				$aResult[$i][1] = $intValues[$intIndex + 1]  ; appearance_bitmap
				$aResult[$i][2] = $intValues[$intIndex + 2]  ; flags
				$aResult[$i][3] = $intValues[$intIndex + 3]  ; primary
				$aResult[$i][4] = $intValues[$intIndex + 4]  ; secondary
				$aResult[$i][5] = $intValues[$intIndex + 5]  ; party_leader_player_number
				$aResult[$i][6] = $intValues[$intIndex + 6]  ; player_number
				$aResult[$i][7] = $intValues[$intIndex + 7]  ; party_size
				$aResult[$i][8] = $intValues[$intIndex + 8]  ; active_title_tier
				$aResult[$i][9] = $stringValues[$stringIndex]; name

				$intIndex += 9   ; 9 integer values per player
				$stringIndex += 1  ; 1 string value per player
			Next

			_CleanupOutput()
			Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get title information
Func _Nexus_TitleInfo($infoType, $param = 0)
    Local $paramCount = 1

    If $infoType = $TITLE_INFO_BY_INDEX Or $infoType = $TITLE_INFO_BY_ID Then
        $paramCount = 2
    EndIf

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_WORLD_TITLE_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then
        _SetParam(1, $param)
    EndIf

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $TITLE_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $TITLE_INFO_BY_INDEX, $TITLE_INFO_BY_ID, $TITLE_INFO_ACTIVE_TITLE
            Return _ParseTitleDetails()

		Case $TITLE_INFO_MAXED_TITLES
			Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
			Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

			If @error Or UBound($intValues) < 1 Then
				_CleanupOutput()
				Return SetError(3, 0, 0)
			EndIf

			Local $titleCount = $intValues[0]
			; Create a 2D array to store all title information
			Local $aResult[$titleCount + 1][10]
			$aResult[0][0] = $titleCount

			Local $intIndex = 1
			Local $stringIndex = 0

			For $i = 1 To $titleCount
				$aResult[$i][0] = $intValues[$intIndex]      ; props
				$aResult[$i][1] = $intValues[$intIndex + 1]  ; current_points
				$aResult[$i][2] = $intValues[$intIndex + 2]  ; current_title_tier_index
				$aResult[$i][3] = $intValues[$intIndex + 3]  ; points_needed_current_rank
				$aResult[$i][4] = $intValues[$intIndex + 4]  ; next_title_tier_index
				$aResult[$i][5] = $intValues[$intIndex + 5]  ; points_needed_next_rank
				$aResult[$i][6] = $intValues[$intIndex + 6]  ; max_title_rank
				$aResult[$i][7] = $intValues[$intIndex + 7]  ; max_title_tier_index
				$aResult[$i][8] = $stringValues[$stringIndex]; h0020
				$aResult[$i][9] = $stringValues[$stringIndex + 1]; h0024

				$intIndex += 8   ; 8 integer values per title
				$stringIndex += 2  ; 2 string values per title
			Next

			_CleanupOutput()
			Return $aResult

        Case $TITLE_INFO_ALL
            Return _ParseAllTitles()

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get profession state information
Func _Nexus_ProfessionStateInfo($infoType, $param = 0)
    Local $paramCount = 1

    If $infoType = $PROFESSION_STATE_INFO_BY_INDEX Or $infoType = $PROFESSION_STATE_INFO_BY_AGENT_ID Then
        $paramCount = 2
    EndIf

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_PROFESSION_STATE_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then
        _SetParam(1, $param)
    EndIf

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $PROFESSION_STATE_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $PROFESSION_STATE_INFO_BY_INDEX, $PROFESSION_STATE_INFO_BY_AGENT_ID
            Return _ParseProfessionStateDetails()

		Case $PROFESSION_STATE_INFO_ALL
			Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
			If @error Or UBound($intValues) < 1 Then
				_CleanupOutput()
				Return SetError(3, 0, 0)
			EndIf

			Local $stateCount = $intValues[0]
			; Create a 2D array to store all profession state information
			Local $aResult[$stateCount + 1][16]
			$aResult[0][0] = $stateCount

			Local $intIndex = 1

			For $i = 1 To $stateCount
				$aResult[$i][0] = $intValues[$intIndex]      ; agent_id
				$aResult[$i][1] = $intValues[$intIndex + 1]  ; primary
				$aResult[$i][2] = $intValues[$intIndex + 2]  ; secondary
				$aResult[$i][3] = $intValues[$intIndex + 3]  ; unlocked_professions
				$aResult[$i][4] = $intValues[$intIndex + 4]  ; unk

				; Store each profession's unlock status (11 professions)
				For $j = 0 To 10
					$aResult[$i][$j + 5] = $intValues[$intIndex + $j + 5]  ; profession unlock status
				Next

				$intIndex += 16  ; 16 integer values per profession state
			Next

			_CleanupOutput()
			Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Helper function to parse quest details
Func _ParseQuestDetails()
    Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
    Local $floatValues = _GetTypedValuesByType($VALUE_TYPE_FLOAT)
    Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

    If @error Or UBound($intValues) < 4 Or UBound($floatValues) < 3 Or UBound($stringValues) < 5 Then
        _CleanupOutput()
        Return SetError(3, 0, 0)
    EndIf

    ; Create quest data array
    Local $aQuest[10]
    $aQuest[0] = $intValues[0]            ; quest_id
    $aQuest[1] = $intValues[1]            ; log_state
    $aQuest[2] = $intValues[2]            ; map_from
    $aQuest[3] = $intValues[3]            ; map_to
    $aQuest[4] = $floatValues[0]          ; marker.x
    $aQuest[5] = $floatValues[1]          ; marker.y
    $aQuest[6] = $floatValues[2]          ; marker.zplane
    $aQuest[7] = $stringValues[0]         ; location
    $aQuest[8] = $stringValues[1]         ; name
    $aQuest[9] = $stringValues[2]         ; npc

    ; Save description and objectives
    Local $aExtended[12]
    For $i = 0 To 9
        $aExtended[$i] = $aQuest[$i]
    Next
    $aExtended[10] = $stringValues[3]     ; description
    $aExtended[11] = $stringValues[4]     ; objectives

    _CleanupOutput()
    Return $aExtended
EndFunc

; Helper function to parse all quests
Func _ParseAllQuests()
    Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
    Local $floatValues = _GetTypedValuesByType($VALUE_TYPE_FLOAT)
    Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

    If @error Or UBound($intValues) < 1 Then
        _CleanupOutput()
        Return SetError(3, 0, 0)
    EndIf

    Local $questCount = $intValues[0]
    ; Create a 2D array to store all quest information
    Local $aResult[$questCount + 1][12]
    $aResult[0][0] = $questCount

    Local $intIndex = 1
    Local $floatIndex = 0
    Local $stringIndex = 0

    For $i = 1 To $questCount
        $aResult[$i][0] = $intValues[$intIndex]          ; quest_id
        $aResult[$i][1] = $intValues[$intIndex + 1]      ; log_state
        $aResult[$i][2] = $intValues[$intIndex + 2]      ; map_from
        $aResult[$i][3] = $intValues[$intIndex + 3]      ; map_to
        $aResult[$i][4] = $floatValues[$floatIndex]      ; marker.x
        $aResult[$i][5] = $floatValues[$floatIndex + 1]  ; marker.y
        $aResult[$i][6] = $floatValues[$floatIndex + 2]  ; marker.zplane
        $aResult[$i][7] = $stringValues[$stringIndex]    ; location
        $aResult[$i][8] = $stringValues[$stringIndex + 1]; name
        $aResult[$i][9] = $stringValues[$stringIndex + 2]; npc
        $aResult[$i][10] = $stringValues[$stringIndex + 3]; description
        $aResult[$i][11] = $stringValues[$stringIndex + 4]; objectives

        $intIndex += 4   ; quest_id, log_state, map_from, map_to
        $floatIndex += 3  ; marker.x, marker.y, marker.zplane
        $stringIndex += 5  ; location, name, npc, description, objectives
    Next

    _CleanupOutput()
    Return $aResult
EndFunc

; Helper function to extract quest data
Func _ExtractQuestData($intValues, $floatValues, $stringValues, $intIndex, $floatIndex, $stringIndex)
    If UBound($intValues) < ($intIndex + 4) Or UBound($floatValues) < ($floatIndex + 3) Or UBound($stringValues) < ($stringIndex + 5) Then
        Return SetError(1, 0, 0)
    EndIf

    ; Create quest data array
    Local $aQuest[12]
    $aQuest[0] = $intValues[$intIndex]            ; quest_id
    $aQuest[1] = $intValues[$intIndex + 1]        ; log_state
    $aQuest[2] = $intValues[$intIndex + 2]        ; map_from
    $aQuest[3] = $intValues[$intIndex + 3]        ; map_to
    $aQuest[4] = $floatValues[$floatIndex]        ; marker.x
    $aQuest[5] = $floatValues[$floatIndex + 1]    ; marker.y
    $aQuest[6] = $floatValues[$floatIndex + 2]    ; marker.zplane
    $aQuest[7] = $stringValues[$stringIndex]      ; location
    $aQuest[8] = $stringValues[$stringIndex + 1]  ; name
    $aQuest[9] = $stringValues[$stringIndex + 2]  ; npc
    $aQuest[10] = $stringValues[$stringIndex + 3] ; description
    $aQuest[11] = $stringValues[$stringIndex + 4] ; objectives

    Return $aQuest
EndFunc

; Helper function to parse NPC details
Func _ParseNPCDetails()
    Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
    Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

    If @error Or UBound($intValues) < 7 Or UBound($stringValues) < 1 Then
        _CleanupOutput()
        Return SetError(3, 0, 0)
    EndIf

    ; Create NPC data array
    Local $aNPC[8]
    $aNPC[0] = $intValues[0]            ; model_file_id
    $aNPC[1] = $intValues[1]            ; scale
    $aNPC[2] = $intValues[2]            ; sex
    $aNPC[3] = $intValues[3]            ; npc_flags
    $aNPC[4] = $intValues[4]            ; primary
    $aNPC[5] = $intValues[5]            ; default_level
    $aNPC[6] = $stringValues[0]         ; name
    $aNPC[7] = $intValues[6]            ; files_count

    _CleanupOutput()
    Return $aNPC
EndFunc

; Helper function to parse all NPCs
Func _ParseAllNPCs()
    Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
    Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

    If @error Or UBound($intValues) < 1 Then
        _CleanupOutput()
        Return SetError(3, 0, 0)
    EndIf

    Local $npcCount = $intValues[0]
    ; Create a 2D array to store all NPC information
    Local $aResult[$npcCount + 1][8]
    $aResult[0][0] = $npcCount

    Local $intIndex = 1
    Local $stringIndex = 0

    For $i = 1 To $npcCount
        $aResult[$i][0] = $intValues[$intIndex]      ; model_file_id
        $aResult[$i][1] = $intValues[$intIndex + 1]  ; scale
        $aResult[$i][2] = $intValues[$intIndex + 2]  ; sex
        $aResult[$i][3] = $intValues[$intIndex + 3]  ; npc_flags
        $aResult[$i][4] = $intValues[$intIndex + 4]  ; primary
        $aResult[$i][5] = $intValues[$intIndex + 5]  ; default_level
        $aResult[$i][6] = $stringValues[$stringIndex]; name
        $aResult[$i][7] = $intValues[$intIndex + 6]  ; files_count

        $intIndex += 7   ; 7 integer values per NPC
        $stringIndex += 1  ; 1 string value per NPC
    Next

    _CleanupOutput()
    Return $aResult
EndFunc

; Helper function to extract NPC data
Func _ExtractNPCData($intValues, $stringValues, $intIndex, $stringIndex)
    If UBound($intValues) < ($intIndex + 7) Or UBound($stringValues) < ($stringIndex + 1) Then
        Return SetError(1, 0, 0)
    EndIf

    ; Create NPC data array
    Local $aNPC[8]
    $aNPC[0] = $intValues[$intIndex]            ; model_file_id
    $aNPC[1] = $intValues[$intIndex + 1]        ; scale
    $aNPC[2] = $intValues[$intIndex + 2]        ; sex
    $aNPC[3] = $intValues[$intIndex + 3]        ; npc_flags
    $aNPC[4] = $intValues[$intIndex + 4]        ; primary
    $aNPC[5] = $intValues[$intIndex + 5]        ; default_level
    $aNPC[6] = $stringValues[$stringIndex]      ; name
    $aNPC[7] = $intValues[$intIndex + 6]        ; files_count

    Return $aNPC
EndFunc

; Helper function to parse player details
Func _ParsePlayerDetails()
    Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
    Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

    If @error Or UBound($intValues) < 9 Or UBound($stringValues) < 1 Then
        _CleanupOutput()
        Return SetError(3, 0, 0)
    EndIf

    ; Create player data array
    Local $aPlayer[10]
    $aPlayer[0] = $intValues[0]            ; agent_id
    $aPlayer[1] = $intValues[1]            ; appearance_bitmap
    $aPlayer[2] = $intValues[2]            ; flags
    $aPlayer[3] = $intValues[3]            ; primary
    $aPlayer[4] = $intValues[4]            ; secondary
    $aPlayer[5] = $intValues[5]            ; party_leader_player_number
    $aPlayer[6] = $intValues[6]            ; player_number
    $aPlayer[7] = $intValues[7]            ; party_size
    $aPlayer[8] = $intValues[8]            ; active_title_tier
    $aPlayer[9] = $stringValues[0]         ; name

    _CleanupOutput()
    Return $aPlayer
EndFunc

; Helper function to extract player data
Func _ExtractPlayerData($intValues, $stringValues, $intIndex, $stringIndex)
    If UBound($intValues) < ($intIndex + 9) Or UBound($stringValues) < ($stringIndex + 1) Then
        Return SetError(1, 0, 0)
    EndIf

    ; Create player data array
    Local $aPlayer[10]
    $aPlayer[0] = $intValues[$intIndex]            ; agent_id
    $aPlayer[1] = $intValues[$intIndex + 1]        ; appearance_bitmap
    $aPlayer[2] = $intValues[$intIndex + 2]        ; flags
    $aPlayer[3] = $intValues[$intIndex + 3]        ; primary
    $aPlayer[4] = $intValues[$intIndex + 4]        ; secondary
    $aPlayer[5] = $intValues[$intIndex + 5]        ; party_leader_player_number
    $aPlayer[6] = $intValues[$intIndex + 6]        ; player_number
    $aPlayer[7] = $intValues[$intIndex + 7]        ; party_size
    $aPlayer[8] = $intValues[$intIndex + 8]        ; active_title_tier
    $aPlayer[9] = $stringValues[$stringIndex]      ; name

    Return $aPlayer
EndFunc

; Helper function to parse title details
Func _ParseTitleDetails()
    Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
    Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

    If @error Or UBound($intValues) < 8 Or UBound($stringValues) < 2 Then
        _CleanupOutput()
        Return SetError(3, 0, 0)
    EndIf

    ; Create title data array
    Local $aTitle[10]
    $aTitle[0] = $intValues[0]            ; props
    $aTitle[1] = $intValues[1]            ; current_points
    $aTitle[2] = $intValues[2]            ; current_title_tier_index
    $aTitle[3] = $intValues[3]            ; points_needed_current_rank
    $aTitle[4] = $intValues[4]            ; next_title_tier_index
    $aTitle[5] = $intValues[5]            ; points_needed_next_rank
    $aTitle[6] = $intValues[6]            ; max_title_rank
    $aTitle[7] = $intValues[7]            ; max_title_tier_index
    $aTitle[8] = $stringValues[0]         ; h0020
    $aTitle[9] = $stringValues[1]         ; h0024

    _CleanupOutput()
    Return $aTitle
EndFunc

; Helper function to parse all titles
Func _ParseAllTitles()
    Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
    Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

    If @error Or UBound($intValues) < 1 Then
        _CleanupOutput()
        Return SetError(3, 0, 0)
    EndIf

    Local $titleCount = $intValues[0]
    ; Create a 2D array to store all title information
    Local $aResult[$titleCount + 1][10]
    $aResult[0][0] = $titleCount

    Local $intIndex = 1
    Local $stringIndex = 0

    For $i = 1 To $titleCount
        $aResult[$i][0] = $intValues[$intIndex]      ; props
        $aResult[$i][1] = $intValues[$intIndex + 1]  ; current_points
        $aResult[$i][2] = $intValues[$intIndex + 2]  ; current_title_tier_index
        $aResult[$i][3] = $intValues[$intIndex + 3]  ; points_needed_current_rank
        $aResult[$i][4] = $intValues[$intIndex + 4]  ; next_title_tier_index
        $aResult[$i][5] = $intValues[$intIndex + 5]  ; points_needed_next_rank
        $aResult[$i][6] = $intValues[$intIndex + 6]  ; max_title_rank
        $aResult[$i][7] = $intValues[$intIndex + 7]  ; max_title_tier_index
        $aResult[$i][8] = $stringValues[$stringIndex]; h0020
        $aResult[$i][9] = $stringValues[$stringIndex + 1]; h0024

        $intIndex += 8   ; 8 integer values per title
        $stringIndex += 2  ; 2 string values per title
    Next

    _CleanupOutput()
    Return $aResult
EndFunc

; Helper function to extract title data
Func _ExtractTitleData($intValues, $stringValues, $intIndex, $stringIndex)
    If UBound($intValues) < ($intIndex + 8) Or UBound($stringValues) < ($stringIndex + 2) Then
        Return SetError(1, 0, 0)
    EndIf

    ; Create title data array
    Local $aTitle[10]
    $aTitle[0] = $intValues[$intIndex]            ; props
    $aTitle[1] = $intValues[$intIndex + 1]        ; current_points
    $aTitle[2] = $intValues[$intIndex + 2]        ; current_title_tier_index
    $aTitle[3] = $intValues[$intIndex + 3]        ; points_needed_current_rank
    $aTitle[4] = $intValues[$intIndex + 4]        ; next_title_tier_index
    $aTitle[5] = $intValues[$intIndex + 5]        ; points_needed_next_rank
    $aTitle[6] = $intValues[$intIndex + 6]        ; max_title_rank
    $aTitle[7] = $intValues[$intIndex + 7]        ; max_title_tier_index
    $aTitle[8] = $stringValues[$stringIndex]      ; h0020
    $aTitle[9] = $stringValues[$stringIndex + 1]  ; h0024

    Return $aTitle
EndFunc

; Helper function to parse profession state details
Func _ParseProfessionStateDetails()
    Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)

    If @error Or UBound($intValues) < 16 Then
        _CleanupOutput()
        Return SetError(3, 0, 0)
    EndIf

    ; Create profession state data array
    Local $aState[16]
    $aState[0] = $intValues[0]            ; agent_id
    $aState[1] = $intValues[1]            ; primary
    $aState[2] = $intValues[2]            ; secondary
    $aState[3] = $intValues[3]            ; unlocked_professions
    $aState[4] = $intValues[4]            ; unk

    ; Store each profession's unlock status (11 professions)
    For $i = 0 To 10
        $aState[$i + 5] = $intValues[$i + 5]  ; profession unlock status
    Next

    _CleanupOutput()
    Return $aState
EndFunc

; Helper function to extract profession state data
Func _ExtractProfessionStateData($intValues, $intIndex)
    If UBound($intValues) < ($intIndex + 16) Then
        Return SetError(1, 0, 0)
    EndIf

    ; Create profession state data array
    Local $aState[16]
    $aState[0] = $intValues[$intIndex]            ; agent_id
    $aState[1] = $intValues[$intIndex + 1]        ; primary
    $aState[2] = $intValues[$intIndex + 2]        ; secondary
    $aState[3] = $intValues[$intIndex + 3]        ; unlocked_professions
    $aState[4] = $intValues[$intIndex + 4]        ; unk

    ; Store each profession's unlock status (11 professions)
    For $i = 0 To 10
        $aState[$i + 5] = $intValues[$intIndex + $i + 5]  ; profession unlock status
    Next

    Return $aState
EndFunc

; Helper wrapper functions for world context info
Func _World_ActiveQuestId()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_ACTIVE_QUEST_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_QuestLogCount()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_QUEST_LOG_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_QuestByIndex($index)
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_QUEST_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_AllQuests()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_ALL_QUESTS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_MissionsCompleted()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_MISSIONS_COMPLETED)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_MissionsBonus()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_MISSIONS_BONUS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_MissionsCompletedHM()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_MISSIONS_COMPLETED_HM)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_MissionsBonusHM()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_MISSIONS_BONUS_HM)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_Kurzick()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_KURZICK)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_Luxon()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_LUXON)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_Imperial()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_IMPERIAL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_Balthazar()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_BALTHAZAR)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_Experience()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_EXPERIENCE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_Level()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_LEVEL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_SkillPoints()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_SKILL_POINTS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_HardModeUnlocked()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_HARD_MODE_UNLOCKED)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_ProfessionStatesCount()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_PROFESSION_STATES_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_ProfessionStateByIndex($index)
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_PROFESSION_STATE_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_LearnableSkillsCount()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_LEARNABLE_SKILLS_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_UnlockedSkillsCount()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_UNLOCKED_SKILLS_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_CartographedAreasCount()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_CARTOGRAPHED_AREAS_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_VanquishedAreasCount()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_VANQUISHED_AREAS_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_VanquishProgress()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_VANQUISH_PROGRESS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_NPCsCount()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_NPCS_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_NPCByIndex($index)
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_NPC_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_PlayersCount()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_PLAYERS_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_PlayerByIndex($index)
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_PLAYER_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_TitlesCount()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_TITLES_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_TitleByIndex($index)
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_TITLE_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_TitleTiersCount()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_TITLE_TIERS_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _World_AllBasicInfo()
    Local $result = _Nexus_WorldContextInfo($WORLD_INFO_ALL_BASIC_INFO)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper wrapper functions for quest info
Func _Quest_Count()
    Local $result = _Nexus_QuestInfo($QUEST_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Quest_ByIndex($index)
    Local $result = _Nexus_QuestInfo($QUEST_INFO_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Quest_ById($id)
    Local $result = _Nexus_QuestInfo($QUEST_INFO_BY_ID, $id)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Quest_ActiveQuest()
    Local $result = _Nexus_QuestInfo($QUEST_INFO_ACTIVE_QUEST)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Quest_PrimaryQuests()
    Local $result = _Nexus_QuestInfo($QUEST_INFO_PRIMARY_QUESTS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Quest_CompletedQuests()
    Local $result = _Nexus_QuestInfo($QUEST_INFO_COMPLETED_QUESTS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Quest_All()
    Local $result = _Nexus_QuestInfo($QUEST_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper wrapper functions for NPC info
Func _NPC_Count()
    Local $result = _Nexus_NPCInfo($NPC_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _NPC_ByIndex($index)
    Local $result = _Nexus_NPCInfo($NPC_INFO_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _NPC_ByModelId($modelId)
    Local $result = _Nexus_NPCInfo($NPC_INFO_BY_MODEL_ID, $modelId)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _NPC_Henchmen()
    Local $result = _Nexus_NPCInfo($NPC_INFO_HENCHMEN)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _NPC_Heroes()
    Local $result = _Nexus_NPCInfo($NPC_INFO_HEROES)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _NPC_All()
	Local $result =  _Nexus_NPCInfo($NPC_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper wrapper functions for player info
Func _Player_Count()
    Local $result = _Nexus_PlayerInfo($PLAYER_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Player_ByIndex($index)
    Local $result = _Nexus_PlayerInfo($PLAYER_INFO_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Player_ByName($name)
    Local $result = _Nexus_PlayerInfo($PLAYER_INFO_BY_NAME, $name)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Player_ByAgentId($agentId)
    Local $result = _Nexus_PlayerInfo($PLAYER_INFO_BY_AGENT_ID, $agentId)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Player_Leader()
    Local $result = _Nexus_PlayerInfo($PLAYER_INFO_LEADER)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Player_All()
	Local $result = _Nexus_PlayerInfo($PLAYER_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper wrapper functions for title info
Func _Title_Count()
    Local $result = _Nexus_TitleInfo($TITLE_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Title_ByIndex($index)
    Local $result = _Nexus_TitleInfo($TITLE_INFO_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Title_ById($id)
    Local $result = _Nexus_TitleInfo($TITLE_INFO_BY_ID, $id)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Title_ActiveTitle()
    Local $result = _Nexus_TitleInfo($TITLE_INFO_ACTIVE_TITLE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Title_MaxedTitles()
    Local $result = _Nexus_TitleInfo($TITLE_INFO_MAXED_TITLES)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Title_All()
    Local $result = _Nexus_TitleInfo($TITLE_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper wrapper functions for profession state info
Func _ProfessionState_Count()
    Local $result = _Nexus_ProfessionStateInfo($PROFESSION_STATE_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ProfessionState_ByIndex($index)
    Local $result = _Nexus_ProfessionStateInfo($PROFESSION_STATE_INFO_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ProfessionState_ByAgentId($agentId)
    Local $result = _Nexus_ProfessionStateInfo($PROFESSION_STATE_INFO_BY_AGENT_ID, $agentId)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ProfessionState_AllProf()
    Local $result = _Nexus_ProfessionStateInfo($PROFESSION_STATE_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc
