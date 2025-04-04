#include-once

Global Enum $PREGAME_INFO_FRAME_ID = 0, _
$PREGAME_INFO_CHOSEN_CHARACTER_INDEX = 1, _
$PREGAME_INDEX_1 = 2, _
$PREGAME_INDEX_2 = 3

Global Enum $ARRAY_LOGIN_CHARACTER_SIZE = 0, _
$ARRAY_LOGIN_CHARACTER_NAME = 1, _
$ARRAY_LOGIN_CHARACTER_ALL = 2

Func _Nexus_PreGameInfo($infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_PREGAME_INFO, 1) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Local $value = _GetFirstIntValue()
    _CleanupOutput()
    Return $value
EndFunc

Func _Nexus_LoginCharacterInfo($infoType, $charIndex = 0)
    Local $paramCount = 1

    If $infoType = $ARRAY_LOGIN_CHARACTER_NAME Then
        $paramCount = 2
    EndIf

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_PREGAME_ARRAY_LOGINCHARACTER, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount >= 2 Then
        _SetParam(1, $charIndex)
    EndIf

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $ARRAY_LOGIN_CHARACTER_SIZE
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $ARRAY_LOGIN_CHARACTER_NAME
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)

            If @error Or UBound($stringValues) < 1 Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[2] = [$stringValues[0], $intValues[0]]
            _CleanupOutput()
            Return $aResult

        Case $ARRAY_LOGIN_CHARACTER_ALL
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)

            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $charCount = $intValues[0]
            Local $aResult[$charCount]  ; [name, unk0]

            For $i = 0 To $charCount - 1
                $aResult[$i] = $stringValues[$i]
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

Func _PreGame_FrameID()
    Local $result = _Nexus_PreGameInfo($PREGAME_INFO_FRAME_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _PreGame_ChosenCharacterIndex()
    Local $result = _Nexus_PreGameInfo($PREGAME_INFO_CHOSEN_CHARACTER_INDEX)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _PreGame_Index1()
    Local $result = _Nexus_PreGameInfo($PREGAME_INDEX_1)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _PreGame_Index2()
    Local $result = _Nexus_PreGameInfo($PREGAME_INDEX_2)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _PreGame_CharacterCount()
    Local $result = _Nexus_LoginCharacterInfo($ARRAY_LOGIN_CHARACTER_SIZE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _PreGame_CharacterName($index)
    Local $result = _Nexus_LoginCharacterInfo($ARRAY_LOGIN_CHARACTER_NAME, $index)
    If @error Then Return SetError(1, 0, "")
    Return $result[0]
EndFunc

Func _PreGame_AllCharacters()
    Local $result = _Nexus_LoginCharacterInfo($ARRAY_LOGIN_CHARACTER_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc