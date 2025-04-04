#include-once

Global Enum $ATTRIBUTE_INFO_PROFESSION_ID = 0, _
$ATTRIBUTE_INFO_ATTRIBUTE_ID = 1, _
$ATTRIBUTE_INFO_NAME_ID = 2, _
$ATTRIBUTE_INFO_DESC_ID = 3, _
$ATTRIBUTE_INFO_IS_PVE = 4, _
$ATTRIBUTE_INFO_NAME = 5, _
$ATTRIBUTE_INFO_DESCRIPTION = 6, _
$ATTRIBUTE_INFO_ALL_PROPERTIES = 7

Func _Nexus_AttributeConstInfo($attributeID, $infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_ATTRIBUTE_INFO, 2) Then Return SetError(@error, 0, "")
    _SetParam(0, $attributeID)
    _SetParam(1, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(1, 0, 0)

    Switch $infoType
        Case $ATTRIBUTE_INFO_PROFESSION_ID, $ATTRIBUTE_INFO_ATTRIBUTE_ID, $ATTRIBUTE_INFO_NAME_ID, _
             $ATTRIBUTE_INFO_DESC_ID, $ATTRIBUTE_INFO_IS_PVE
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $ATTRIBUTE_INFO_NAME, $ATTRIBUTE_INFO_DESCRIPTION
            Local $value = _GetFirstStringValue()
            _CleanupOutput()
            Return $value

        Case $ATTRIBUTE_INFO_ALL_PROPERTIES
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 3 Or UBound($stringValues) < 2 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aProperties[5] = [ _
                $intValues[0], _ ;Profession ID
                $intValues[1], _ ;Attribute ID
                $intValues[2], _ ;Is PvE
                $stringValues[0], _ ;Name
                $stringValues[1]] ;Description

            _CleanupOutput()
            Return $aProperties

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

Func _AttributeConst_ProfessionID($attributeID)
    Local $result = _Nexus_AttributeConstInfo($attributeID, $ATTRIBUTE_INFO_PROFESSION_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AttributeConst_AttributeID($attributeID)
    Local $result = _Nexus_AttributeConstInfo($attributeID, $ATTRIBUTE_INFO_ATTRIBUTE_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AttributeConst_NameID($attributeID)
    Local $result = _Nexus_AttributeConstInfo($attributeID, $ATTRIBUTE_INFO_NAME_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AttributeConst_DescriptionID($attributeID)
    Local $result = _Nexus_AttributeConstInfo($attributeID, $ATTRIBUTE_INFO_DESC_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AttributeConst_IsPvE($attributeID)
    Local $result = _Nexus_AttributeConstInfo($attributeID, $ATTRIBUTE_INFO_IS_PVE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AttributeConst_Name($attributeID)
    Local $result = _Nexus_AttributeConstInfo($attributeID, $ATTRIBUTE_INFO_NAME)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AttributeConst_Description($attributeID)
    Local $result = _Nexus_AttributeConstInfo($attributeID, $ATTRIBUTE_INFO_DESCRIPTION)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AttributeConst_AllProperties($attributeID)
    Local $result = _Nexus_AttributeConstInfo($attributeID, $ATTRIBUTE_INFO_ALL_PROPERTIES)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc