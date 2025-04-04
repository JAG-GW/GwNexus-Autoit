#include-once

; Title Information Types
Global Enum $TITLE_INFO_TITLE_ID = 0, _
$TITLE_INFO_NAME_ID = 1, _
$TITLE_INFO_NAME = 2, _
$TITLE_INFO_ALL_PROPERTIES = 3

; Main function to get title information
Func _Nexus_TitleConstInfo($titleID, $infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_TITLE_INFO, 2) Then Return SetError(1, 0, 0)
    _SetParam(0, $titleID)
    _SetParam(1, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $TITLE_INFO_TITLE_ID, $TITLE_INFO_NAME_ID
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $TITLE_INFO_NAME
            Local $value = _GetFirstStringValue()
            _CleanupOutput()
            Return $value

        Case $TITLE_INFO_ALL_PROPERTIES
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 2 Or UBound($stringValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aProperties[3] = [ _
                $intValues[0], _ ; title id
                $intValues[1], _ ; name id
                $stringValues[0]] ;name

            _CleanupOutput()
            Return $aProperties

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

Func _TitleConst_TitleID($titleID)
    Local $result = _Nexus_TitleConstInfo($titleID, $TITLE_INFO_TITLE_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _TitleConst_Name($titleID)
    Local $result = _Nexus_TitleConstInfo($titleID, $TITLE_INFO_NAME)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _TitleConst_NameID($titleID)
    Local $result = _Nexus_TitleConstInfo($titleID, $TITLE_INFO_NAME_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _TitleConst_AllProperties($titleID)
    Local $result = _Nexus_TitleConstInfo($titleID, $TITLE_INFO_ALL_PROPERTIES)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc