#include-once

; Agent Info Types
Global Enum $AGENT_INFO_VTABLE = 0, _
$AGENT_INFO_H0004 = 1, _
$AGENT_INFO_H0008 = 2, _
$AGENT_INFO_H000C = 3, _
$AGENT_INFO_TIMERS = 4, _
$AGENT_INFO_AGENT_ID = 5, _
$AGENT_INFO_COORDS = 6, _
$AGENT_INFO_SIZE1 = 7, _
$AGENT_INFO_SIZE2 = 8, _
$AGENT_INFO_SIZE3 = 9, _
$AGENT_INFO_ROTATION = 10, _
$AGENT_INFO_NAME_PROPERTIES = 11, _
$AGENT_INFO_GROUND = 12, _
$AGENT_INFO_H0060 = 13, _
$AGENT_INFO_TERRAIN_NORMAL_COORDS = 14, _
$AGENT_INFO_H0070 = 15, _
$AGENT_INFO_PLANE = 16, _
$AGENT_INFO_H0080 = 17, _
$AGENT_INFO_NAME_TAG_COORDS = 18, _
$AGENT_INFO_VISUAL_EFFECTS = 19, _
$AGENT_INFO_H0092 = 20, _
$AGENT_INFO_H0094 = 21, _
$AGENT_INFO_TYPE = 22, _
$AGENT_INFO_MOVE_VELOCITY = 23, _
$AGENT_INFO_H00A8 = 24, _
$AGENT_INFO_ROTATION2 = 25, _
$AGENT_INFO_H00B4 = 26

; Agent Item Info Types
Global Enum $AGENT_ITEM_INFO_OWNER = 0, _
$AGENT_ITEM_INFO_ITEM_ID = 1, _
$AGENT_ITEM_INFO_H00CC = 2, _
$AGENT_ITEM_INFO_EXTRA_TYPE = 3

; Agent Gadget Info Types
Global Enum $AGENT_GADGET_INFO_H00C4_C8 = 0, _
$AGENT_GADGET_INFO_EXTRA_TYPE = 1, _
$AGENT_GADGET_INFO_GADGET_ID = 2, _
$AGENT_GADGET_INFO_H00D4 = 3

; Agent Living Info Types
Global Enum $AGENT_LIVING_INFO_OWNER = 0, _
$AGENT_LIVING_INFO_H00C8 = 1, _
$AGENT_LIVING_INFO_H00CC = 2, _
$AGENT_LIVING_INFO_H00D0 = 3, _
$AGENT_LIVING_INFO_H00D4 = 4, _
$AGENT_LIVING_INFO_ANIMATION_TYPE = 5, _
$AGENT_LIVING_INFO_H00E4 = 6, _
$AGENT_LIVING_INFO_WEAPON_ATTACK_SPEED = 7, _
$AGENT_LIVING_INFO_ATTACK_SPEED_MODIFIER = 8, _
$AGENT_LIVING_INFO_PLAYER_NUMBER = 9, _
$AGENT_LIVING_INFO_AGENT_MODEL_TYPE = 10, _
$AGENT_LIVING_INFO_TRANSMOG_NPC_ID = 11, _
$AGENT_LIVING_INFO_H0100 = 12, _
$AGENT_LIVING_INFO_H0108 = 13, _
$AGENT_LIVING_INFO_PRIMARY = 14, _
$AGENT_LIVING_INFO_SECONDARY = 15, _
$AGENT_LIVING_INFO_LEVEL = 16, _
$AGENT_LIVING_INFO_TEAM_ID = 17, _
$AGENT_LIVING_INFO_H010E = 18, _
$AGENT_LIVING_INFO_H0110 = 19, _
$AGENT_LIVING_INFO_ENERGY_REGEN = 20, _
$AGENT_LIVING_INFO_OVERCAST = 21, _
$AGENT_LIVING_INFO_ENERGY = 22, _
$AGENT_LIVING_INFO_MAX_ENERGY = 23, _
$AGENT_LIVING_INFO_H0124 = 24, _
$AGENT_LIVING_INFO_HP_PIPS = 25, _
$AGENT_LIVING_INFO_H012C = 26, _
$AGENT_LIVING_INFO_HP = 27, _
$AGENT_LIVING_INFO_MAX_HP = 28, _
$AGENT_LIVING_INFO_EFFECTS = 29, _
$AGENT_LIVING_INFO_H013C = 30, _
$AGENT_LIVING_INFO_HEX = 31, _
$AGENT_LIVING_INFO_MODEL_STATE = 32, _
$AGENT_LIVING_INFO_TYPE_MAP = 33, _
$AGENT_LIVING_INFO_IN_SPIRIT_RANGE = 34, _
$AGENT_LIVING_INFO_H017C = 35, _
$AGENT_LIVING_INFO_LOGIN_NUMBER = 36, _
$AGENT_LIVING_INFO_ANIMATION_SPEED = 37, _
$AGENT_LIVING_INFO_ANIMATION_CODE = 38, _
$AGENT_LIVING_INFO_ANIMATION_ID = 39, _
$AGENT_LIVING_INFO_DAGGER_STATUS = 40, _
$AGENT_LIVING_INFO_ALLEGIANCE = 41, _
$AGENT_LIVING_INFO_WEAPON_TYPE = 42, _
$AGENT_LIVING_INFO_SKILL = 43, _
$AGENT_LIVING_INFO_H01B6 = 44, _
$AGENT_LIVING_INFO_WEAPON_ITEM_TYPE = 45, _
$AGENT_LIVING_INFO_OFFHAND_ITEM_TYPE = 46, _
$AGENT_LIVING_INFO_WEAPON_ITEM_ID = 47, _
$AGENT_LIVING_INFO_OFFHAND_ITEM_ID = 48

; Visible Effect Info Types
Global Enum $VISIBLE_EFFECT_INFO_COUNT = 0, _
$VISIBLE_EFFECT_INFO_UNK = 1, _
$VISIBLE_EFFECT_INFO_ID = 2, _
$VISIBLE_EFFECT_INFO_HAS_ENDED = 3

; Equipment Info Types
Global Enum $EQUIPMENT_INFO_WEAPON = 0, _
$EQUIPMENT_INFO_OFFHAND = 1, _
$EQUIPMENT_INFO_CHEST = 2, _
$EQUIPMENT_INFO_LEGS = 3, _
$EQUIPMENT_INFO_HEAD = 4, _
$EQUIPMENT_INFO_FEET = 5, _
$EQUIPMENT_INFO_HANDS = 6, _
$EQUIPMENT_INFO_COSTUME_BODY = 7, _
$EQUIPMENT_INFO_COSTUME_HEAD = 8

; Tag Info Types
Global Enum $TAG_INFO_GUILD_ID = 0, _
$TAG_INFO_PRIMARY = 1, _
$TAG_INFO_SECONDARY = 2, _
$TAG_INFO_LEVEL = 3

; Array Query Types
Global Enum $AGENT_ARRAY_SIZE = 0, _
$AGENT_ARRAY_ALL_IDS = 1, _
$AGENT_ARRAY_ALL_INFO = 2

; Main function to get basic agent information
Func _Nexus_AgentInfo($agentID, $infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_AGENT_INFO, 2) Then Return SetError(1, 0, 0)
    _SetParam(0, $agentID)
    _SetParam(1, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $AGENT_INFO_VTABLE, $AGENT_INFO_H0004, $AGENT_INFO_H0008, $AGENT_INFO_NAME_PROPERTIES, _
             $AGENT_INFO_GROUND, $AGENT_INFO_H0060, $AGENT_INFO_PLANE, $AGENT_INFO_VISUAL_EFFECTS, _
             $AGENT_INFO_H0092, $AGENT_INFO_TYPE, $AGENT_INFO_H00A8
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $AGENT_INFO_H000C, $AGENT_INFO_TIMERS, $AGENT_INFO_H0070, $AGENT_INFO_H0080, _
             $AGENT_INFO_H0094, $AGENT_INFO_H00B4
            Local $values = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[UBound($values)]
            For $i = 0 To UBound($values) - 1
                $aResult[$i] = $values[$i]
            Next

            _CleanupOutput()
            Return $aResult

        Case $AGENT_INFO_COORDS, $AGENT_INFO_SIZE1, $AGENT_INFO_SIZE2, $AGENT_INFO_SIZE3, _
             $AGENT_INFO_ROTATION, $AGENT_INFO_TERRAIN_NORMAL_COORDS, $AGENT_INFO_NAME_TAG_COORDS, _
             $AGENT_INFO_MOVE_VELOCITY, $AGENT_INFO_ROTATION2
            Local $floats = _GetTypedValuesByType($VALUE_TYPE_FLOAT)
            If @error Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[UBound($floats)]
            For $i = 0 To UBound($floats) - 1
                $aResult[$i] = $floats[$i]
            Next

            _CleanupOutput()
            Return $aResult

        Case $AGENT_INFO_AGENT_ID
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get agent item information
Func _Nexus_AgentItemInfo($agentID, $infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_AGENTITEM_INFO, 2) Then Return SetError(1, 0, 0)
    _SetParam(0, $agentID)
    _SetParam(1, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Local $value = _GetFirstIntValue()
    _CleanupOutput()
    Return $value
EndFunc

; Function to get agent gadget information
Func _Nexus_AgentGadgetInfo($agentID, $infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_AGENTGADGET_INFO, 2) Then Return SetError(1, 0, 0)
    _SetParam(0, $agentID)
    _SetParam(1, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $AGENT_GADGET_INFO_EXTRA_TYPE, $AGENT_GADGET_INFO_GADGET_ID
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $AGENT_GADGET_INFO_H00C4_C8, $AGENT_GADGET_INFO_H00D4
            Local $values = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[UBound($values)]
            For $i = 0 To UBound($values) - 1
                $aResult[$i] = $values[$i]
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get agent living information
Func _Nexus_AgentLivingInfo($agentID, $infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_AGENTLIVING_INFO, 2) Then Return SetError(1, 0, 0)
    _SetParam(0, $agentID)
    _SetParam(1, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $AGENT_LIVING_INFO_OWNER, $AGENT_LIVING_INFO_H00C8, $AGENT_LIVING_INFO_H00CC, _
             $AGENT_LIVING_INFO_H00D0, $AGENT_LIVING_INFO_H0100, $AGENT_LIVING_INFO_H0108, _
             $AGENT_LIVING_INFO_PRIMARY, $AGENT_LIVING_INFO_SECONDARY, $AGENT_LIVING_INFO_LEVEL, _
             $AGENT_LIVING_INFO_TEAM_ID, $AGENT_LIVING_INFO_H0110, $AGENT_LIVING_INFO_MAX_ENERGY, _
             $AGENT_LIVING_INFO_H0124, $AGENT_LIVING_INFO_H012C, $AGENT_LIVING_INFO_MAX_HP, _
             $AGENT_LIVING_INFO_EFFECTS, $AGENT_LIVING_INFO_H013C, $AGENT_LIVING_INFO_HEX, _
             $AGENT_LIVING_INFO_MODEL_STATE, $AGENT_LIVING_INFO_TYPE_MAP, $AGENT_LIVING_INFO_IN_SPIRIT_RANGE, _
             $AGENT_LIVING_INFO_H017C, $AGENT_LIVING_INFO_LOGIN_NUMBER, $AGENT_LIVING_INFO_ANIMATION_CODE, _
             $AGENT_LIVING_INFO_ANIMATION_ID, $AGENT_LIVING_INFO_DAGGER_STATUS, $AGENT_LIVING_INFO_ALLEGIANCE, _
             $AGENT_LIVING_INFO_WEAPON_TYPE, $AGENT_LIVING_INFO_SKILL, $AGENT_LIVING_INFO_H01B6, _
             $AGENT_LIVING_INFO_WEAPON_ITEM_TYPE, $AGENT_LIVING_INFO_OFFHAND_ITEM_TYPE, _
             $AGENT_LIVING_INFO_WEAPON_ITEM_ID, $AGENT_LIVING_INFO_OFFHAND_ITEM_ID
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $AGENT_LIVING_INFO_H00D4, $AGENT_LIVING_INFO_H00E4, $AGENT_LIVING_INFO_H010E
            Local $values = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[UBound($values)]
            For $i = 0 To UBound($values) - 1
                $aResult[$i] = $values[$i]
            Next

            _CleanupOutput()
            Return $aResult

        Case $AGENT_LIVING_INFO_ANIMATION_TYPE, $AGENT_LIVING_INFO_WEAPON_ATTACK_SPEED, _
             $AGENT_LIVING_INFO_ATTACK_SPEED_MODIFIER, $AGENT_LIVING_INFO_ENERGY_REGEN, _
             $AGENT_LIVING_INFO_OVERCAST, $AGENT_LIVING_INFO_ENERGY, $AGENT_LIVING_INFO_HP_PIPS, _
             $AGENT_LIVING_INFO_HP, $AGENT_LIVING_INFO_ANIMATION_SPEED
            Local $value = _GetFirstFloatValue()
            _CleanupOutput()
            Return $value

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get visible effect information for an agent
Func _Nexus_AgentVisibleEffectInfo($agentID, $effectIndex, $infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_AGENT_VISIBLEEFFECT_INFO, 3) Then Return SetError(1, 0, 0)
    _SetParam(0, $agentID)
    _SetParam(1, $effectIndex)
    _SetParam(2, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Local $value = _GetFirstIntValue()
    _CleanupOutput()
    Return $value
EndFunc

; Function to get equipment information for an agent
Func _Nexus_AgentEquipmentInfo($agentID, $infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_AGENT_EQUIPMENT_INFO, 2) Then Return SetError(1, 0, 0)
    _SetParam(0, $agentID)
    _SetParam(1, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Local $value = _GetFirstIntValue()
    _CleanupOutput()
    Return $value
EndFunc

; Function to get tag information for an agent
Func _Nexus_AgentTagInfo($agentID, $infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_AGENT_TAGINFO, 2) Then Return SetError(1, 0, 0)
    _SetParam(0, $agentID)
    _SetParam(1, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Local $value = _GetFirstIntValue()
    _CleanupOutput()
    Return $value
EndFunc

; Function to get living agent array information
Func _Nexus_AgentLivingArray($queryType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_AGENT_ARRAY_LIVING, 1) Then Return SetError(1, 0, 0)
    _SetParam(0, $queryType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $queryType
        Case $AGENT_ARRAY_SIZE
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $AGENT_ARRAY_ALL_IDS
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

		Case $AGENT_ARRAY_ALL_INFO
			Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
			Local $floatValues = _GetTypedValuesByType($VALUE_TYPE_FLOAT)

			If @error Or UBound($intValues) < 1 Or UBound($floatValues) < 1 Then
				_CleanupOutput()
				Return SetError(3, 0, 0)
			EndIf

			Local $agentCount = $intValues[0]
			Local $aResult[$agentCount + 1][100]
			$aResult[0][0] = $agentCount

			Local $intIndex = 1
			Local $floatIndex = 0

			For $i = 1 To $agentCount
				If $intIndex + 30 >= UBound($intValues) Or $floatIndex + 20 >= UBound($floatValues) Then
					$aResult[0][0] = $i - 1
					ExitLoop
				EndIf
				$aResult[$i][0] = $intValues[$intIndex]      ; agent_id
				$aResult[$i][1] = $intValues[$intIndex + 1]  ; timer
				$aResult[$i][2] = $intValues[$intIndex + 2]  ; timer2

				$aResult[$i][3] = $floatValues[$floatIndex]      ; X
				$aResult[$i][4] = $floatValues[$floatIndex + 1]  ; Y
				$aResult[$i][5] = $floatValues[$floatIndex + 2]  ; Z

				$aResult[$i][6] = $floatValues[$floatIndex + 3]  ; angle
				$aResult[$i][7] = $floatValues[$floatIndex + 4]  ; cos
				$aResult[$i][8] = $floatValues[$floatIndex + 5]  ; sin

				$aResult[$i][9] = $intValues[$intIndex + 3]   ; name_properties
				$aResult[$i][10] = $intValues[$intIndex + 4]  ; ground

				$aResult[$i][11] = $floatValues[$floatIndex + 6]  ; terrain_normal.x
				$aResult[$i][12] = $floatValues[$floatIndex + 7]  ; terrain_normal.y
				$aResult[$i][13] = $floatValues[$floatIndex + 8]  ; terrain_normal.z

				$aResult[$i][14] = $intValues[$intIndex + 5]  ; plane

				$aResult[$i][15] = $floatValues[$floatIndex + 9]   ; name_tag_x
				$aResult[$i][16] = $floatValues[$floatIndex + 10]  ; name_tag_y
				$aResult[$i][17] = $floatValues[$floatIndex + 11]  ; name_tag_z

				$aResult[$i][18] = $intValues[$intIndex + 6]  ; type

				$aResult[$i][19] = $floatValues[$floatIndex + 12]  ; move_x
				$aResult[$i][20] = $floatValues[$floatIndex + 13]  ; move_y

				$aResult[$i][21] = $floatValues[$floatIndex + 14]  ; rotation_cos2
				$aResult[$i][22] = $floatValues[$floatIndex + 15]  ; rotation_sin2

				$aResult[$i][23] = $intValues[$intIndex + 7]   ; owner
				$aResult[$i][24] = $floatValues[$floatIndex + 16]  ; animation_type
				$aResult[$i][25] = $floatValues[$floatIndex + 17]  ; weapon_attack_speed
				$aResult[$i][26] = $floatValues[$floatIndex + 18]  ; attack_speed_modifier
				$aResult[$i][27] = $intValues[$intIndex + 8]   ; player_number
				$aResult[$i][28] = $intValues[$intIndex + 9]   ; agent_model_type
				$aResult[$i][29] = $intValues[$intIndex + 10]  ; transmog_npc_id
				$aResult[$i][30] = $intValues[$intIndex + 11]  ; primary
				$aResult[$i][31] = $intValues[$intIndex + 12]  ; secondary
				$aResult[$i][32] = $intValues[$intIndex + 13]  ; level
				$aResult[$i][33] = $intValues[$intIndex + 14]  ; team_id
				$aResult[$i][34] = $floatValues[$floatIndex + 19]  ; energy_regen
				$aResult[$i][35] = $floatValues[$floatIndex + 20]  ; overcast
				$aResult[$i][36] = $floatValues[$floatIndex + 21]  ; energy
				$aResult[$i][37] = $intValues[$intIndex + 15]  ; max_energy
				$aResult[$i][38] = $floatValues[$floatIndex + 22]  ; hp_pips
				$aResult[$i][39] = $floatValues[$floatIndex + 23]  ; hp
				$aResult[$i][40] = $intValues[$intIndex + 16]  ; max_hp
				$aResult[$i][41] = $intValues[$intIndex + 17]  ; effects
				$aResult[$i][42] = $intValues[$intIndex + 18]  ; hex
				$aResult[$i][43] = $intValues[$intIndex + 19]  ; model_state
				$aResult[$i][44] = $intValues[$intIndex + 20]  ; type_map
				$aResult[$i][45] = $intValues[$intIndex + 21]  ; in_spirit_range
				$aResult[$i][46] = $intValues[$intIndex + 22]  ; login_number
				$aResult[$i][47] = $floatValues[$floatIndex + 24]  ; animation_speed
				$aResult[$i][48] = $intValues[$intIndex + 23]  ; animation_code
				$aResult[$i][49] = $intValues[$intIndex + 24]  ; animation_id
				$aResult[$i][50] = $intValues[$intIndex + 25]  ; dagger_status
				$aResult[$i][51] = $intValues[$intIndex + 26]  ; allegiance
				$aResult[$i][52] = $intValues[$intIndex + 27]  ; weapon_type
				$aResult[$i][53] = $intValues[$intIndex + 28]  ; skill
				$aResult[$i][54] = $intValues[$intIndex + 29]  ; weapon_item_type
				$aResult[$i][55] = $intValues[$intIndex + 30]  ; offhand_item_type
				$aResult[$i][56] = $intValues[$intIndex + 31]  ; weapon_item_id
				$aResult[$i][57] = $intValues[$intIndex + 32]  ; offhand_item_id

				$aResult[$i][58] = $intValues[$intIndex + 33]  ; guild_id
				$aResult[$i][59] = $intValues[$intIndex + 34]  ; item_id_weapon
				$aResult[$i][60] = $intValues[$intIndex + 35]  ; item_id_offhand
				$aResult[$i][61] = $intValues[$intIndex + 36]  ; item_id_chest
				$aResult[$i][62] = $intValues[$intIndex + 37]  ; item_id_legs
				$aResult[$i][63] = $intValues[$intIndex + 38]  ; item_id_head
				$aResult[$i][64] = $intValues[$intIndex + 39]  ; item_id_feet
				$aResult[$i][65] = $intValues[$intIndex + 40]  ; item_id_hands
				$aResult[$i][66] = $intValues[$intIndex + 41]  ; item_id_costume_body
				$aResult[$i][67] = $intValues[$intIndex + 42]  ; item_id_costume_head

				$aResult[$i][68] = $intValues[$intIndex + 43]  ; effect_count
				Local $effectCount = $intValues[$intIndex + 43]
				If $effectCount > 0 Then
					For $j = 0 To $effectCount
						$aResult[$i][70 + ($j * 3)] = $intValues[$intIndex + 44 + ($j * 3)]  ; unk
						$aResult[$i][71 + ($j * 3)] = $intValues[$intIndex + 45 + ($j * 3)]  ; id
						$aResult[$i][72 + ($j * 3)] = $intValues[$intIndex + 46 + ($j * 3)]  ; has_ended
					Next
				Else
					$aResult[$i][69] = 0
				EndIf

				$intIndex += 44 + ($effectCount * 3)
				$floatIndex += 25
			Next

			_CleanupOutput()
			Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get item agent array information
Func _Nexus_AgentItemArray($queryType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_AGENT_ARRAY_ITEM, 1) Then Return SetError(1, 0, 0)
    _SetParam(0, $queryType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $queryType
        Case $AGENT_ARRAY_SIZE
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $AGENT_ARRAY_ALL_IDS
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

		Case $AGENT_ARRAY_ALL_INFO
			Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
			Local $floatValues = _GetTypedValuesByType($VALUE_TYPE_FLOAT)

			If @error Or UBound($intValues) < 1 Or UBound($floatValues) < 1 Then
				_CleanupOutput()
				Return SetError(3, 0, 0)
			EndIf

			Local $agentCount = $intValues[0]
			Local $aResult[$agentCount + 1][20]
			$aResult[0][0] = $agentCount

			Local $intIndex = 1
			Local $floatIndex = 0

			For $i = 1 To $agentCount
				If $intIndex + 10 >= UBound($intValues) Or $floatIndex + 6 >= UBound($floatValues) Then
					$aResult[0][0] = $i - 1
					ExitLoop
				EndIf

				$aResult[$i][0] = $intValues[$intIndex]      ; agent_id
				$aResult[$i][1] = $intValues[$intIndex + 1]  ; timer
				$aResult[$i][2] = $intValues[$intIndex + 2]  ; timer2
				$aResult[$i][3] = $floatValues[$floatIndex]      ; X
				$aResult[$i][4] = $floatValues[$floatIndex + 1]  ; Y
				$aResult[$i][5] = $floatValues[$floatIndex + 2]  ; Z
				$aResult[$i][6] = $intValues[$intIndex + 3]  ; name_properties
				$aResult[$i][7] = $intValues[$intIndex + 4]  ; ground
				$aResult[$i][8] = $floatValues[$floatIndex + 3]  ; terrain_normal.x
				$aResult[$i][9] = $floatValues[$floatIndex + 4]  ; terrain_normal.y
				$aResult[$i][10] = $floatValues[$floatIndex + 5] ; terrain_normal.z
				$aResult[$i][11] = $intValues[$intIndex + 5]  ; plane
				$aResult[$i][12] = $intValues[$intIndex + 6]  ; type
				$aResult[$i][13] = $intValues[$intIndex + 7]  ; owner
				$aResult[$i][14] = $intValues[$intIndex + 8]  ; item_id
				$aResult[$i][15] = $intValues[$intIndex + 9]  ; extra_type

				$intIndex += 10
				$floatIndex += 6
			Next

			_CleanupOutput()
			Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get gadget agent array information
Func _Nexus_AgentGadgetArray($queryType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_AGENT_ARRAY_GADGET, 1) Then Return SetError(1, 0, 0)
    _SetParam(0, $queryType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $queryType
        Case $AGENT_ARRAY_SIZE
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $AGENT_ARRAY_ALL_IDS
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

		Case $AGENT_ARRAY_ALL_INFO
			Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
			Local $floatValues = _GetTypedValuesByType($VALUE_TYPE_FLOAT)

			If @error Or UBound($intValues) < 1 Or UBound($floatValues) < 1 Then
				_CleanupOutput()
				Return SetError(3, 0, 0)
			EndIf

			Local $agentCount = $intValues[0]
			Local $aResult[$agentCount + 1][20]
			$aResult[0][0] = $agentCount

			Local $intIndex = 1
			Local $floatIndex = 0

			For $i = 1 To $agentCount
				If $intIndex + 7 >= UBound($intValues) Or $floatIndex + 6 >= UBound($floatValues) Then
					$aResult[0][0] = $i - 1
					ExitLoop
				EndIf

				$aResult[$i][0] = $intValues[$intIndex]      ; agent_id
				$aResult[$i][1] = $floatValues[$floatIndex]      ; X
				$aResult[$i][2] = $floatValues[$floatIndex + 1]  ; Y
				$aResult[$i][3] = $floatValues[$floatIndex + 2]  ; Z
				$aResult[$i][4] = $intValues[$intIndex + 1]  ; name_properties
				$aResult[$i][5] = $intValues[$intIndex + 2]  ; ground
				$aResult[$i][6] = $floatValues[$floatIndex + 3]  ; terrain_normal.x
				$aResult[$i][7] = $floatValues[$floatIndex + 4]  ; terrain_normal.y
				$aResult[$i][8] = $floatValues[$floatIndex + 5]  ; terrain_normal.z
				$aResult[$i][9] = $intValues[$intIndex + 3]  ; plane
				$aResult[$i][10] = $intValues[$intIndex + 4]  ; type
				$aResult[$i][11] = $intValues[$intIndex + 5]  ; extra_type
				$aResult[$i][12] = $intValues[$intIndex + 6]  ; gadget_id

				$intIndex += 7
				$floatIndex += 6
			Next

			_CleanupOutput()
			Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Helper functions for agent information
Func _Agent_AgentID($agentID)
    Local $result = _Nexus_AgentInfo($agentID, $AGENT_INFO_AGENT_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Agent_Type($agentID)
    Local $result = _Nexus_AgentInfo($agentID, $AGENT_INFO_TYPE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Agent_Coords($agentID)
    Local $result = _Nexus_AgentInfo($agentID, $AGENT_INFO_COORDS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Agent_Rotation($agentID)
    Local $result = _Nexus_AgentInfo($agentID, $AGENT_INFO_ROTATION)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Agent_VisualEffects($agentID)
    Local $result = _Nexus_AgentInfo($agentID, $AGENT_INFO_VISUAL_EFFECTS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for agent item
Func _AgentItem_Owner($agentID)
    Local $result = _Nexus_AgentItemInfo($agentID, $AGENT_ITEM_INFO_OWNER)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentItem_ItemID($agentID)
    Local $result = _Nexus_AgentItemInfo($agentID, $AGENT_ITEM_INFO_ITEM_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentItem_ExtraType($agentID)
    Local $result = _Nexus_AgentItemInfo($agentID, $AGENT_ITEM_INFO_EXTRA_TYPE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for agent gadget
Func _AgentGadget_GadgetID($agentID)
    Local $result = _Nexus_AgentGadgetInfo($agentID, $AGENT_GADGET_INFO_GADGET_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentGadget_ExtraType($agentID)
    Local $result = _Nexus_AgentGadgetInfo($agentID, $AGENT_GADGET_INFO_EXTRA_TYPE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for agent living
Func _AgentLiving_Owner($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_OWNER)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_Profession($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_PRIMARY)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_PrimaryProfession($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_PRIMARY)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_SecondaryProfession($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_SECONDARY)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_Level($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_LEVEL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_TeamID($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_TEAM_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_Energy($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_ENERGY)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_MaxEnergy($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_MAX_ENERGY)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_HP($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_HP)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_MaxHP($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_MAX_HP)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_ModelState($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_MODEL_STATE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_Effects($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_EFFECTS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_Allegiance($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_ALLEGIANCE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for visible effects
Func _AgentVisibleEffect_Count($agentID)
    Local $result = _Nexus_AgentVisibleEffectInfo($agentID, 0, $VISIBLE_EFFECT_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentVisibleEffect_ID($agentID, $effectIndex)
    Local $result = _Nexus_AgentVisibleEffectInfo($agentID, $effectIndex, $VISIBLE_EFFECT_INFO_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentVisibleEffect_HasEnded($agentID, $effectIndex)
    Local $result = _Nexus_AgentVisibleEffectInfo($agentID, $effectIndex, $VISIBLE_EFFECT_INFO_HAS_ENDED)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for equipment info
Func _AgentEquipment_Weapon($agentID)
    Local $result = _Nexus_AgentEquipmentInfo($agentID, $EQUIPMENT_INFO_WEAPON)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentEquipment_Offhand($agentID)
    Local $result = _Nexus_AgentEquipmentInfo($agentID, $EQUIPMENT_INFO_OFFHAND)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentEquipment_Chest($agentID)
    Local $result = _Nexus_AgentEquipmentInfo($agentID, $EQUIPMENT_INFO_CHEST)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentEquipment_Legs($agentID)
    Local $result = _Nexus_AgentEquipmentInfo($agentID, $EQUIPMENT_INFO_LEGS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentEquipment_Head($agentID)
    Local $result = _Nexus_AgentEquipmentInfo($agentID, $EQUIPMENT_INFO_HEAD)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentEquipment_Feet($agentID)
    Local $result = _Nexus_AgentEquipmentInfo($agentID, $EQUIPMENT_INFO_FEET)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentEquipment_Hands($agentID)
    Local $result = _Nexus_AgentEquipmentInfo($agentID, $EQUIPMENT_INFO_HANDS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentEquipment_CostumeBody($agentID)
    Local $result = _Nexus_AgentEquipmentInfo($agentID, $EQUIPMENT_INFO_COSTUME_BODY)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentEquipment_CostumeHead($agentID)
    Local $result = _Nexus_AgentEquipmentInfo($agentID, $EQUIPMENT_INFO_COSTUME_HEAD)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for tag info
Func _AgentTag_GuildID($agentID)
    Local $result = _Nexus_AgentTagInfo($agentID, $TAG_INFO_GUILD_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentTag_Primary($agentID)
    Local $result = _Nexus_AgentTagInfo($agentID, $TAG_INFO_PRIMARY)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentTag_Secondary($agentID)
    Local $result = _Nexus_AgentTagInfo($agentID, $TAG_INFO_SECONDARY)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentTag_Level($agentID)
    Local $result = _Nexus_AgentTagInfo($agentID, $TAG_INFO_LEVEL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for living agent array
Func _AgentLivingArray_Count()
    Local $result = _Nexus_AgentLivingArray($AGENT_ARRAY_SIZE)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLivingArray_AllIDs()
    Local $result = _Nexus_AgentLivingArray($AGENT_ARRAY_ALL_IDS)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLivingArray_AllInfo()
    Local $result = _Nexus_AgentLivingArray($AGENT_ARRAY_ALL_INFO)
    If @error Or Not IsArray($result) Then Return SetError(1, 0, 0)
    If UBound($result) < 2 Or $result[0][0] <= 0 Then Return SetError(2, 0, 0)
    Return $result
EndFunc

; Helper functions for item agent array
Func _AgentItemArray_Count()
    Local $result = _Nexus_AgentItemArray($AGENT_ARRAY_SIZE)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentItemArray_AllIDs()
    Local $result = _Nexus_AgentItemArray($AGENT_ARRAY_ALL_IDS)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentItemArray_AllInfo()
    Local $result = _Nexus_AgentItemArray($AGENT_ARRAY_ALL_INFO)
    If @error Or Not IsArray($result) Then Return SetError(1, 0, 0)
    If UBound($result) < 2 Or $result[0][0] <= 0 Then Return SetError(2, 0, 0)
    Return $result
EndFunc

; Helper functions for gadget agent array
Func _AgentGadgetArray_Count()
    Local $result = _Nexus_AgentGadgetArray($AGENT_ARRAY_SIZE)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentGadgetArray_AllIDs()
    Local $result = _Nexus_AgentGadgetArray($AGENT_ARRAY_ALL_IDS)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentGadgetArray_AllInfo()
    Local $result = _Nexus_AgentGadgetArray($AGENT_ARRAY_ALL_INFO)
    If @error Or Not IsArray($result) Then Return SetError(1, 0, 0)
    If UBound($result) < 2 Or $result[0][0] <= 0 Then Return SetError(2, 0, 0)
    Return $result
EndFunc

; Additional agent living info helper functions
Func _AgentLiving_WeaponAttackSpeed($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_WEAPON_ATTACK_SPEED)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_AttackSpeedModifier($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_ATTACK_SPEED_MODIFIER)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_EnergyRegen($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_ENERGY_REGEN)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_Overcast($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_OVERCAST)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_HPPips($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_HP_PIPS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_ModelType($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_AGENT_MODEL_TYPE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_TransmogNPCID($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_TRANSMOG_NPC_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_Hex($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_HEX)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_TypeMap($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_TYPE_MAP)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_InSpiritRange($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_IN_SPIRIT_RANGE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_LoginNumber($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_LOGIN_NUMBER)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_AnimationSpeed($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_ANIMATION_SPEED)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_AnimationType($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_ANIMATION_TYPE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_AnimationCode($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_ANIMATION_CODE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_AnimationID($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_ANIMATION_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_DaggerStatus($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_DAGGER_STATUS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_WeaponType($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_WEAPON_TYPE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_Skill($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_SKILL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_WeaponItemType($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_WEAPON_ITEM_TYPE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_OffhandItemType($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_OFFHAND_ITEM_TYPE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_WeaponItemID($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_WEAPON_ITEM_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentLiving_OffhandItemID($agentID)
    Local $result = _Nexus_AgentLivingInfo($agentID, $AGENT_LIVING_INFO_OFFHAND_ITEM_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Additional agent info helper functions
Func _Agent_Timers($agentID)
    Local $result = _Nexus_AgentInfo($agentID, $AGENT_INFO_TIMERS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Agent_Size1($agentID)
    Local $result = _Nexus_AgentInfo($agentID, $AGENT_INFO_SIZE1)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Agent_Size2($agentID)
    Local $result = _Nexus_AgentInfo($agentID, $AGENT_INFO_SIZE2)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Agent_Size3($agentID)
    Local $result = _Nexus_AgentInfo($agentID, $AGENT_INFO_SIZE3)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Agent_NameProperties($agentID)
    Local $result = _Nexus_AgentInfo($agentID, $AGENT_INFO_NAME_PROPERTIES)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Agent_Ground($agentID)
    Local $result = _Nexus_AgentInfo($agentID, $AGENT_INFO_GROUND)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Agent_TerrainNormalCoords($agentID)
    Local $result = _Nexus_AgentInfo($agentID, $AGENT_INFO_TERRAIN_NORMAL_COORDS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Agent_Plane($agentID)
    Local $result = _Nexus_AgentInfo($agentID, $AGENT_INFO_PLANE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Agent_NameTagCoords($agentID)
    Local $result = _Nexus_AgentInfo($agentID, $AGENT_INFO_NAME_TAG_COORDS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Agent_MoveVelocity($agentID)
    Local $result = _Nexus_AgentInfo($agentID, $AGENT_INFO_MOVE_VELOCITY)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Agent_Rotation2($agentID)
    Local $result = _Nexus_AgentInfo($agentID, $AGENT_INFO_ROTATION2)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc
