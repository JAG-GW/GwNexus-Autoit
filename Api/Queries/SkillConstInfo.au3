#include-once

Global Enum $SKILL_INFO_SKILLID = 0, _
$SKILL_INFO_UNKNOWN0004 = 1, _
$SKILL_INFO_CAMPAIGN = 2, _
$SKILL_INFO_SKILLTYPE = 3, _
$SKILL_INFO_SPECIAL = 4, _
$SKILL_INFO_COMBOREQ = 5, _
$SKILL_INFO_EFFECT1 = 6, _
$SKILL_INFO_CONDITION = 7, _
$SKILL_INFO_EFFECT2 = 8, _
$SKILL_INFO_WEAPONREQ = 9, _
$SKILL_INFO_PROFESSION = 10, _
$SKILL_INFO_ATTRIBUTE = 11, _
$SKILL_INFO_TITLE = 12, _
$SKILL_INFO_COMBO = 13, _
$SKILL_INFO_TARGET = 14, _
$SKILL_INFO_UNKNOWN0032 = 15, _
$SKILL_INFO_SKILL_EQUIP_TYPE = 16, _
$SKILL_INFO_OVERCAST = 17, _
$SKILL_INFO_ENERGY_COST = 18, _
$SKILL_INFO_HEALTH_COST = 19, _
$SKILL_INFO_UNKNOWN0037 = 20, _
$SKILL_INFO_ADRENALINE = 21, _
$SKILL_INFO_ACTIVATION = 22, _
$SKILL_INFO_AFTERCAST = 23, _
$SKILL_INFO_DURATION = 24, _
$SKILL_INFO_RECHARGE = 25, _
$SKILL_INFO_UNKNOWN0050 = 26, _
$SKILL_INFO_SKILL_ARGUMENTS = 27, _
$SKILL_INFO_SCALE = 28, _
$SKILL_INFO_BONUS_SCALE = 29, _
$SKILL_INFO_AOE_RANGE = 30, _
$SKILL_INFO_CONST_EFFECT = 31, _
$SKILL_INFO_CASTER_ANIMATION = 32, _
$SKILL_INFO_TARGET_ANIMATION = 33, _
$SKILL_INFO_PROJECTILE_ANIMATION = 34, _
$SKILL_INFO_ICON_FILE_ID = 35, _
$SKILL_INFO_NAME = 36, _
$SKILL_INFO_CONCISE = 37, _
$SKILL_INFO_DESCRIPTION = 38, _
$SKILL_INFO_NAME_TEXT = 39, _
$SKILL_INFO_DESCRIPTION_TEXT = 40, _
$SKILL_INFO_CONCISE_TEXT = 41, _
$SKILL_INFO_ALL_PROPERTIES = 42

Func _Nexus_SkillConstInfo($skillID, $infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_SKILL_INFO, 2) Then Return SetError(1, 0, 0)
    _SetParam(0, $skillID)
    _SetParam(1, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $SKILL_INFO_UNKNOWN0004, $SKILL_INFO_CAMPAIGN, $SKILL_INFO_SKILLTYPE, _
             $SKILL_INFO_SPECIAL, $SKILL_INFO_COMBOREQ, $SKILL_INFO_EFFECT1, _
             $SKILL_INFO_CONDITION, $SKILL_INFO_EFFECT2, $SKILL_INFO_WEAPONREQ, _
             $SKILL_INFO_PROFESSION, $SKILL_INFO_ATTRIBUTE, $SKILL_INFO_TITLE, _
             $SKILL_INFO_COMBO, $SKILL_INFO_TARGET, $SKILL_INFO_UNKNOWN0032, _
             $SKILL_INFO_SKILL_EQUIP_TYPE, $SKILL_INFO_OVERCAST, $SKILL_INFO_ENERGY_COST, _
             $SKILL_INFO_HEALTH_COST, $SKILL_INFO_UNKNOWN0037, $SKILL_INFO_ADRENALINE, _
             $SKILL_INFO_RECHARGE, $SKILL_INFO_SKILL_ARGUMENTS, _
             $SKILL_INFO_NAME, $SKILL_INFO_CONCISE, $SKILL_INFO_DESCRIPTION
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $SKILL_INFO_ACTIVATION, $SKILL_INFO_AFTERCAST, $SKILL_INFO_AOE_RANGE, $SKILL_INFO_CONST_EFFECT
            Local $value = _GetFirstFloatValue()
            _CleanupOutput()
            Return $value

        Case $SKILL_INFO_SKILLID, $SKILL_INFO_DURATION, $SKILL_INFO_SCALE, _
             $SKILL_INFO_BONUS_SCALE, $SKILL_INFO_CASTER_ANIMATION, _
             $SKILL_INFO_TARGET_ANIMATION, $SKILL_INFO_PROJECTILE_ANIMATION, _
             $SKILL_INFO_ICON_FILE_ID
            Local $values = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($values) < 2 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[2] = [$values[0], $values[1]]
            _CleanupOutput()
            Return $aResult

        Case $SKILL_INFO_UNKNOWN0050
            Local $values = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($values) < 4 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[4] = [$values[0], $values[1], $values[2], $values[3]]
            _CleanupOutput()
            Return $aResult

        Case $SKILL_INFO_NAME_TEXT, $SKILL_INFO_DESCRIPTION_TEXT, $SKILL_INFO_CONCISE_TEXT
            Local $value = _GetFirstStringValue()
            _CleanupOutput()
            Return $value

		Case $SKILL_INFO_ALL_PROPERTIES
			Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
			Local $floatValues = _GetTypedValuesByType($VALUE_TYPE_FLOAT)
			Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

			If @error Or UBound($intValues) < 1 Then
				_CleanupOutput()
				Return SetError(3, 0, 0)
			EndIf

			Local $aResult[34] = [$intValues[0], _ ;SkillID
				$intValues[1], _ ;campaign
				$intValues[2], _ ;type
				$intValues[3], _ ;special
				$intValues[4], _ ;combo_req
				$intValues[5], _ ;effect1
				$intValues[6], _ ;condition
				$intValues[7], _ ;effect2
				$intValues[8], _ ;weapon_req
				$intValues[9], _ ;profession
				$intValues[10], _ ;attribute
				$intValues[11], _ ;title
				$intValues[12], _ ;combo
				$intValues[13], _ ;target
				$intValues[14], _ ;skill_equip_type
				$intValues[15], _ ;overcast
				$intValues[16], _ ;GetEnergyCost
				$intValues[17], _ ;health_cost
				$intValues[18], _ ;adrenaline
				$floatValues[0], _ ;activation
				$floatValues[1], _ ;aftercast
				$intValues[19], _ ;duration0
				$intValues[20], _ ;duration15
				$intValues[21], _ ;recharge
				$intValues[22], _ ;skill_arguments
				$intValues[23], _ ;scale0
				$intValues[24], _ ;scale15
				$intValues[25], _ ;bonusScale0
				$intValues[26], _ ;bonusScale15
				$floatValues[2], _ ;aoe_range
				$floatValues[3], _ ;const_effect
				$stringValues[0], _ ;skill name
				$stringValues[1], _ ;skill concise description
				$stringValues[2]] ;skill description

			_CleanupOutput()
			Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

Func _SkillConst_SkillID($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_SKILLID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Unknown0004($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_UNKNOWN0004)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Campaign($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_CAMPAIGN)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_SkillType($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_SKILLTYPE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Special($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_SPECIAL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_ComboReq($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_COMBOREQ)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Effect1($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_EFFECT1)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Condition($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_CONDITION)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Effect2($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_EFFECT2)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_WeaponReq($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_WEAPONREQ)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Profession($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_PROFESSION)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Attribute($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_ATTRIBUTE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Title($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_TITLE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Combo($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_COMBO)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Target($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_TARGET)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Unknown0032($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_UNKNOWN0032)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_SkillEquipType($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_SKILL_EQUIP_TYPE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Overcast($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_OVERCAST)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_HealthCost($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_HEALTH_COST)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Unknown0037($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_UNKNOWN0037)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Adrenaline($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_ADRENALINE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_AfterCast($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_AFTERCAST)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Duration($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_DURATION)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Unknown0050($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_UNKNOWN0050)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_SkillArguments($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_SKILL_ARGUMENTS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Scale($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_SCALE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_BonusScale($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_BONUS_SCALE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_AOERange($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_AOE_RANGE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_ConstEffect($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_CONST_EFFECT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_CasterAnimation($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_CASTER_ANIMATION)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_TargetAnimation($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_TARGET_ANIMATION)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_ProjectileAnimation($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_PROJECTILE_ANIMATION)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_IconFileID($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_ICON_FILE_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Name($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_NAME)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Concise($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_CONCISE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Description($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_DESCRIPTION)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_AllProperties($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_ALL_PROPERTIES)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_NameText($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_NAME_TEXT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_DescriptionText($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_DESCRIPTION_TEXT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_ConciseDescriptionText($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_CONCISE_TEXT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_EnergyCost($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_ENERGY_COST)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Recharge($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_RECHARGE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _SkillConst_Activation($skillID)
    Local $result = _Nexus_SkillConstInfo($skillID, $SKILL_INFO_ACTIVATION)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc