#include-once

; Trade Information Types
Global Enum $TRADE_INFO_TRADE_STATUS = 0, _
$TRADE_INFO_PLAYER_GOLD = 1, _
$TRADE_INFO_PLAYER_ITEMS_COUNT = 2, _
$TRADE_INFO_PARTNER_GOLD = 3, _
$TRADE_INFO_PARTNER_ITEMS_COUNT = 4, _
$TRADE_INFO_PLAYER_ITEM_BY_INDEX = 5, _
$TRADE_INFO_PARTNER_ITEM_BY_INDEX = 6, _
$TRADE_INFO_ALL_PLAYER_ITEMS = 7, _
$TRADE_INFO_ALL_PARTNER_ITEMS = 8, _
$TRADE_INFO_ALL = 9

; Trade Items Information Types
Global Enum $TRADE_ITEMS_INFO_COUNT = 0, _
$TRADE_ITEMS_INFO_BY_INDEX = 1, _
$TRADE_ITEMS_INFO_ALL = 2

; Main function to get trade information
Func _Nexus_TradeInfo($infoType, $index = 0)
    Local $paramCount = 1
    If $infoType = $TRADE_INFO_PLAYER_ITEM_BY_INDEX Or $infoType = $TRADE_INFO_PARTNER_ITEM_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_TRADE_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $index)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $TRADE_INFO_TRADE_STATUS, $TRADE_INFO_PLAYER_GOLD, $TRADE_INFO_PLAYER_ITEMS_COUNT, _
             $TRADE_INFO_PARTNER_GOLD, $TRADE_INFO_PARTNER_ITEMS_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $TRADE_INFO_PLAYER_ITEM_BY_INDEX, $TRADE_INFO_PARTNER_ITEM_BY_INDEX
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 2 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[2]
            $aResult[0] = $intValues[0]  ; item_id
            $aResult[1] = $intValues[1]  ; quantity

            _CleanupOutput()
            Return $aResult

        Case $TRADE_INFO_ALL_PLAYER_ITEMS, $TRADE_INFO_ALL_PARTNER_ITEMS
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $itemCount = $intValues[0]
            Local $aResult[$itemCount][2]

            For $i = 0 To $itemCount - 1
                $aResult[$i][0] = $intValues[$i * 2 + 1]  ; item_id
                $aResult[$i][1] = $intValues[$i * 2 + 2]  ; quantity
            Next

            _CleanupOutput()
            Return $aResult

		Case $TRADE_INFO_ALL
			Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
			If @error Then
				_CleanupOutput()
				Return SetError(3, 0, 0)
			EndIf

			Local $statusValue = $intValues[0]
			Local $playerGold = $intValues[1]
			Local $playerItemCount = $intValues[2]

			; Create arrays with proper dimensioning
			Local $playerItems[$playerItemCount][2]

			Local $valueIndex = 3
			For $i = 0 To $playerItemCount - 1
				$playerItems[$i][0] = $intValues[$valueIndex]      ; item_id
				$playerItems[$i][1] = $intValues[$valueIndex + 1]  ; quantity
				$valueIndex += 2
			Next

			Local $partnerGold = $intValues[$valueIndex]
			$valueIndex += 1
			Local $partnerItemCount = $intValues[$valueIndex]
			$valueIndex += 1

			Local $partnerItems[$partnerItemCount][2]
			For $i = 0 To $partnerItemCount - 1
				$partnerItems[$i][0] = $intValues[$valueIndex]      ; item_id
				$partnerItems[$i][1] = $intValues[$valueIndex + 1]  ; quantity
				$valueIndex += 2
			Next

			; Create result array properly
			Local $aResult[5]
			$aResult[0] = $statusValue
			$aResult[1] = $playerGold
			$aResult[2] = $playerItems
			$aResult[3] = $partnerGold
			$aResult[4] = $partnerItems

			_CleanupOutput()
			Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get player trade items information
Func _Nexus_PlayerTradeItemsInfo($infoType, $index = 0)
    Local $paramCount = 1
    If $infoType = $TRADE_ITEMS_INFO_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_PLAYER_TRADE_ITEMS_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $index)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $TRADE_ITEMS_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $TRADE_ITEMS_INFO_BY_INDEX
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 2 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[2]
            $aResult[0] = $intValues[0]  ; item_id
            $aResult[1] = $intValues[1]  ; quantity

            _CleanupOutput()
            Return $aResult

        Case $TRADE_ITEMS_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $itemCount = $intValues[0]
            Local $aResult[$itemCount][2]

            For $i = 0 To $itemCount - 1
                $aResult[$i][0] = $intValues[$i * 2 + 1]  ; item_id
                $aResult[$i][1] = $intValues[$i * 2 + 2]  ; quantity
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get partner trade items information
Func _Nexus_PartnerTradeItemsInfo($infoType, $index = 0)
    Local $paramCount = 1
    If $infoType = $TRADE_ITEMS_INFO_BY_INDEX Then $paramCount = 2

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_PARTNER_TRADE_ITEMS_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then _SetParam(1, $index)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $TRADE_ITEMS_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $TRADE_ITEMS_INFO_BY_INDEX
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 2 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[2]
            $aResult[0] = $intValues[0]  ; item_id
            $aResult[1] = $intValues[1]  ; quantity

            _CleanupOutput()
            Return $aResult

        Case $TRADE_ITEMS_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $itemCount = $intValues[0]
            Local $aResult[$itemCount][2]

            For $i = 0 To $itemCount - 1
                $aResult[$i][0] = $intValues[$i * 2 + 1]  ; item_id
                $aResult[$i][1] = $intValues[$i * 2 + 2]  ; quantity
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Helper functions for trade information
Func _Trade_Status()
    Local $result = _Nexus_TradeInfo($TRADE_INFO_TRADE_STATUS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Trade_PlayerGold()
    Local $result = _Nexus_TradeInfo($TRADE_INFO_PLAYER_GOLD)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Trade_PlayerItemsCount()
    Local $result = _Nexus_TradeInfo($TRADE_INFO_PLAYER_ITEMS_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Trade_PartnerGold()
    Local $result = _Nexus_TradeInfo($TRADE_INFO_PARTNER_GOLD)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Trade_PartnerItemsCount()
    Local $result = _Nexus_TradeInfo($TRADE_INFO_PARTNER_ITEMS_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Trade_PlayerItemByIndex($index)
    Local $result = _Nexus_TradeInfo($TRADE_INFO_PLAYER_ITEM_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Trade_PartnerItemByIndex($index)
    Local $result = _Nexus_TradeInfo($TRADE_INFO_PARTNER_ITEM_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Trade_AllPlayerItems()
    Local $result = _Nexus_TradeInfo($TRADE_INFO_ALL_PLAYER_ITEMS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Trade_AllPartnerItems()
    Local $result = _Nexus_TradeInfo($TRADE_INFO_ALL_PARTNER_ITEMS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Trade_All()
    Local $result = _Nexus_TradeInfo($TRADE_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for player trade items
Func _Trade_PlayerItems_Count()
    Local $result = _Nexus_PlayerTradeItemsInfo($TRADE_ITEMS_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Trade_PlayerItems_ByIndex($index)
    Local $result = _Nexus_PlayerTradeItemsInfo($TRADE_ITEMS_INFO_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Trade_PlayerItems_All()
    Local $result = _Nexus_PlayerTradeItemsInfo($TRADE_ITEMS_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for partner trade items
Func _Trade_PartnerItems_Count()
    Local $result = _Nexus_PartnerTradeItemsInfo($TRADE_ITEMS_INFO_COUNT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Trade_PartnerItems_ByIndex($index)
    Local $result = _Nexus_PartnerTradeItemsInfo($TRADE_ITEMS_INFO_BY_INDEX, $index)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _Trade_PartnerItems_All()
    Local $result = _Nexus_PartnerTradeItemsInfo($TRADE_ITEMS_INFO_ALL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc