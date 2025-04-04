#include-once

Global Enum $CINEMATIC_INFO_H0000 = 0, _
$CINEMATIC_INFO_H0004 = 1, _
$CINEMATIC_INFO_ALL_PROPERTIES = 2

Func _Nexus_CinematicInfo($infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_CINEMATIC_INFO, 1) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $CINEMATIC_INFO_H0000, $CINEMATIC_INFO_H0004
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $CINEMATIC_INFO_ALL_PROPERTIES
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)

            If @error Or UBound($intValues) < 2 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aProperties[2] = [ _
                $intValues[0], _
                $intValues[1]]

            _CleanupOutput()
            Return $aProperties

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

Func _Cinematic_H0000()
    Local $result = _Nexus_CinematicInfo($CINEMATIC_INFO_H0000)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Cinematic_H0004()
    Local $result = _Nexus_CinematicInfo($CINEMATIC_INFO_H0004)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Cinematic_AllProperties()
    Local $result = _Nexus_CinematicInfo($CINEMATIC_INFO_ALL_PROPERTIES)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc