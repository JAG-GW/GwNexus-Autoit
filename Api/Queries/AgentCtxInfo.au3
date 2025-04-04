#include-once

; Agent Context Information Types
Global Enum $AGENT_CTX_INFO_INSTANCE_TIMER = 0, _
$AGENT_CTX_INFO_RANDOM_VALUES = 1, _
$AGENT_CTX_INFO_AGENT_SUMMARY_INFO_COUNT = 2, _
$AGENT_CTX_INFO_AGENT_MOVEMENT_COUNT = 3, _
$AGENT_CTX_INFO_AGENT_ARRAY1_COUNT = 4, _
$AGENT_CTX_INFO_AGENT_ASYNC_MOVEMENT_COUNT = 5, _
$AGENT_CTX_INFO_ALL_COUNTS = 6, _
$AGENT_CTX_INFO_ALL = 7

; Agent Summary Information Types
Global Enum $AGENT_SUMMARY_INFO_COUNT = 0, _
$AGENT_SUMMARY_INFO_BY_INDEX = 1, _
$AGENT_SUMMARY_INFO_BY_COMPOSITE_ID = 2, _
$AGENT_SUMMARY_INFO_ALL = 3

; Agent Movement Information Types
Global Enum $AGENT_MOVEMENT_INFO_COUNT = 0, _
$AGENT_MOVEMENT_INFO_BY_INDEX = 1, _
$AGENT_MOVEMENT_INFO_BY_AGENT_ID = 2, _
$AGENT_MOVEMENT_INFO_ALL = 3

; Main function to get agent context information
Func _Nexus_AgentCtxInfo($infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_AGENTCTX_INFO, 1) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $AGENT_CTX_INFO_INSTANCE_TIMER
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $AGENT_CTX_INFO_RANDOM_VALUES
            Local $values = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($values) < 2 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[2] = [$values[0], $values[1]]
            _CleanupOutput()
            Return $aResult

        Case $AGENT_CTX_INFO_AGENT_SUMMARY_INFO_COUNT, _
             $AGENT_CTX_INFO_AGENT_MOVEMENT_COUNT, _
             $AGENT_CTX_INFO_AGENT_ARRAY1_COUNT, _
             $AGENT_CTX_INFO_AGENT_ASYNC_MOVEMENT_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $AGENT_CTX_INFO_ALL_COUNTS
            Local $values = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($values) < 4 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[4] = [$values[0], $values[1], $values[2], $values[3]]
            _CleanupOutput()
            Return $aResult

        Case $AGENT_CTX_INFO_ALL
            Local $values = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($values) < 7 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[7] = [$values[0], $values[1], $values[2], $values[3], $values[4], $values[5], $values[6]]
            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get agent summary information
Func _Nexus_AgentSummaryInfo($infoType, $param = 0)
    Local $paramCount = 1

    If $infoType = $AGENT_SUMMARY_INFO_BY_INDEX Or $infoType = $AGENT_SUMMARY_INFO_BY_COMPOSITE_ID Then
        $paramCount = 2
    EndIf

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_AGENT_SUMMARY_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then
        _SetParam(1, $param)  ; Index or composite ID
    EndIf

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $AGENT_SUMMARY_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $AGENT_SUMMARY_INFO_BY_INDEX, $AGENT_SUMMARY_INFO_BY_COMPOSITE_ID
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 8 Or UBound($stringValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[9]
            $aResult[0] = $intValues[0]  ; h0000
            $aResult[1] = $intValues[1]  ; h0004
            $aResult[2] = $intValues[2]  ; sub.h0000
            $aResult[3] = $intValues[3]  ; sub.h0004
            $aResult[4] = $intValues[4]  ; sub.gadget_id
            $aResult[5] = $intValues[5]  ; sub.h000C
            $aResult[6] = $stringValues[0]  ; gadget_name
            $aResult[7] = $intValues[6]  ; sub.h0014
            $aResult[8] = $intValues[7]  ; sub.composite_agent_id

            _CleanupOutput()
            Return $aResult

        Case $AGENT_SUMMARY_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = $intValues[0]
            Local $aResult[$count + 1]
            $aResult[0] = $count

            Local $intIndex = 1
            Local $strIndex = 0

            For $i = 0 To $count - 1
                Local $agentInfo[9]
                $agentInfo[0] = $intValues[$intIndex]       ; h0000
                $agentInfo[1] = $intValues[$intIndex + 1]   ; h0004
                $agentInfo[2] = $intValues[$intIndex + 2]   ; sub.h0000
                $agentInfo[3] = $intValues[$intIndex + 3]   ; sub.h0004
                $agentInfo[4] = $intValues[$intIndex + 4]   ; sub.gadget_id
                $agentInfo[5] = $intValues[$intIndex + 5]   ; sub.h000C
                $agentInfo[6] = $stringValues[$strIndex]    ; gadget_name
                $agentInfo[7] = $intValues[$intIndex + 6]   ; sub.h0014
                $agentInfo[8] = $intValues[$intIndex + 7]   ; sub.composite_agent_id

                $aResult[$i + 1] = $agentInfo

                $intIndex += 8
                $strIndex += 1
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get agent movement information
Func _Nexus_AgentMovementInfo($infoType, $param = 0)
    Local $paramCount = 1

    If $infoType = $AGENT_MOVEMENT_INFO_BY_INDEX Or $infoType = $AGENT_MOVEMENT_INFO_BY_AGENT_ID Then
        $paramCount = 2
    EndIf

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_AGENT_MOVEMENT_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then
        _SetParam(1, $param)  ; Index or agent ID
    EndIf

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $AGENT_MOVEMENT_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $AGENT_MOVEMENT_INFO_BY_INDEX, $AGENT_MOVEMENT_INFO_BY_AGENT_ID
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $floatValues = _GetTypedValuesByType($VALUE_TYPE_FLOAT)

            If @error Or UBound($intValues) < 25 Or UBound($floatValues) < 6 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[32]

            ; h0000 array (3 values)
            $aResult[0] = $intValues[0]
            $aResult[1] = $intValues[1]
            $aResult[2] = $intValues[2]

            ; agent_id
            $aResult[3] = $intValues[3]

            ; h0010 array (3 values)
            $aResult[4] = $intValues[4]
            $aResult[5] = $intValues[5]
            $aResult[6] = $intValues[6]

            ; agentDef
            $aResult[7] = $intValues[7]

            ; h0020 array (6 values)
            $aResult[8] = $intValues[8]
            $aResult[9] = $intValues[9]
            $aResult[10] = $intValues[10]
            $aResult[11] = $intValues[11]
            $aResult[12] = $intValues[12]
            $aResult[13] = $intValues[13]

            ; moving1
            $aResult[14] = $intValues[14]

            ; h003C array (2 values)
            $aResult[15] = $intValues[15]
            $aResult[16] = $intValues[16]

            ; moving2
            $aResult[17] = $intValues[17]

            ; h0048 array (7 values)
            $aResult[18] = $intValues[18]
            $aResult[19] = $intValues[19]
            $aResult[20] = $intValues[20]
            $aResult[21] = $intValues[21]
            $aResult[22] = $intValues[22]
            $aResult[23] = $intValues[23]
            $aResult[24] = $intValues[24]

            ; h0064 (Vector3)
            $aResult[25] = $floatValues[0]  ; x
            $aResult[26] = $floatValues[1]  ; y
            $aResult[27] = $floatValues[2]  ; z

            ; h0070
            $aResult[28] = $intValues[25]

            ; h0074 (Vector3)
            $aResult[29] = $floatValues[3]  ; x
            $aResult[30] = $floatValues[4]  ; y
            $aResult[31] = $floatValues[5]  ; z

            _CleanupOutput()
            Return $aResult

        Case $AGENT_MOVEMENT_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $floatValues = _GetTypedValuesByType($VALUE_TYPE_FLOAT)

            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $count = $intValues[0]
            Local $aResult[$count + 1]
            $aResult[0] = $count

            Local $intIndex = 1
            Local $floatIndex = 0

            For $i = 0 To $count - 1
                Local $movementInfo[32]

                ; h0000 array (3 values)
                $movementInfo[0] = $intValues[$intIndex]
                $movementInfo[1] = $intValues[$intIndex + 1]
                $movementInfo[2] = $intValues[$intIndex + 2]

                ; agent_id
                $movementInfo[3] = $intValues[$intIndex + 3]

                ; h0010 array (3 values)
                $movementInfo[4] = $intValues[$intIndex + 4]
                $movementInfo[5] = $intValues[$intIndex + 5]
                $movementInfo[6] = $intValues[$intIndex + 6]

                ; agentDef
                $movementInfo[7] = $intValues[$intIndex + 7]

                ; h0020 array (6 values)
                $movementInfo[8] = $intValues[$intIndex + 8]
                $movementInfo[9] = $intValues[$intIndex + 9]
                $movementInfo[10] = $intValues[$intIndex + 10]
                $movementInfo[11] = $intValues[$intIndex + 11]
                $movementInfo[12] = $intValues[$intIndex + 12]
                $movementInfo[13] = $intValues[$intIndex + 13]

                ; moving1
                $movementInfo[14] = $intValues[$intIndex + 14]

                ; h003C array (2 values)
                $movementInfo[15] = $intValues[$intIndex + 15]
                $movementInfo[16] = $intValues[$intIndex + 16]

                ; moving2
                $movementInfo[17] = $intValues[$intIndex + 17]

                ; h0048 array (7 values)
                $movementInfo[18] = $intValues[$intIndex + 18]
                $movementInfo[19] = $intValues[$intIndex + 19]
                $movementInfo[20] = $intValues[$intIndex + 20]
                $movementInfo[21] = $intValues[$intIndex + 21]
                $movementInfo[22] = $intValues[$intIndex + 22]
                $movementInfo[23] = $intValues[$intIndex + 23]
                $movementInfo[24] = $intValues[$intIndex + 24]

                ; h0064 (Vector3)
                $movementInfo[25] = $floatValues[$floatIndex]      ; x
                $movementInfo[26] = $floatValues[$floatIndex + 1]  ; y
                $movementInfo[27] = $floatValues[$floatIndex + 2]  ; z

                ; h0070
                $movementInfo[28] = $intValues[$intIndex + 25]

                ; h0074 (Vector3)
                $movementInfo[29] = $floatValues[$floatIndex + 3]  ; x
                $movementInfo[30] = $floatValues[$floatIndex + 4]  ; y
                $movementInfo[31] = $floatValues[$floatIndex + 5]  ; z

                $aResult[$i + 1] = $movementInfo

                $intIndex += 26
                $floatIndex += 6
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Helper functions for agent context info
Func _AgentCtx_InstanceTimer()
    Local $result = _Nexus_AgentCtxInfo($AGENT_CTX_INFO_INSTANCE_TIMER)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentCtx_RandomValues()
    Local $result = _Nexus_AgentCtxInfo($AGENT_CTX_INFO_RANDOM_VALUES)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentCtx_AgentSummaryInfoCount()
    Local $result = _Nexus_AgentCtxInfo($AGENT_CTX_INFO_AGENT_SUMMARY_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentCtx_AgentMovementCount()
    Local $result = _Nexus_AgentCtxInfo($AGENT_CTX_INFO_AGENT_MOVEMENT_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentCtx_AgentArray1Count()
    Local $result = _Nexus_AgentCtxInfo($AGENT_CTX_INFO_AGENT_ARRAY1_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentCtx_AgentAsyncMovementCount()
    Local $result = _Nexus_AgentCtxInfo($AGENT_CTX_INFO_AGENT_ASYNC_MOVEMENT_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentCtx_AllCounts()
    Local $result = _Nexus_AgentCtxInfo($AGENT_CTX_INFO_ALL_COUNTS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentCtx_All()
    Local $result = _Nexus_AgentCtxInfo($AGENT_CTX_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for agent summary info
Func _AgentSummary_Count()
    Local $result = _Nexus_AgentSummaryInfo($AGENT_SUMMARY_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentSummary_ByIndex($index)
    Local $result = _Nexus_AgentSummaryInfo($AGENT_SUMMARY_INFO_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentSummary_ByCompositeId($compositeId)
    Local $result = _Nexus_AgentSummaryInfo($AGENT_SUMMARY_INFO_BY_COMPOSITE_ID, $compositeId)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentSummary_All()
    Local $result = _Nexus_AgentSummaryInfo($AGENT_SUMMARY_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for agent movement info
Func _AgentMovement_Count()
    Local $result = _Nexus_AgentMovementInfo($AGENT_MOVEMENT_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentMovement_ByIndex($index)
    Local $result = _Nexus_AgentMovementInfo($AGENT_MOVEMENT_INFO_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentMovement_ByAgentId($agentId)
    Local $result = _Nexus_AgentMovementInfo($AGENT_MOVEMENT_INFO_BY_AGENT_ID, $agentId)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _AgentMovement_All()
    Local $result = _Nexus_AgentMovementInfo($AGENT_MOVEMENT_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc