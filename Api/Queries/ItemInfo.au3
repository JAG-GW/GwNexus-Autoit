#include-once

; Item Information Types
Global Enum $ITEM_INFO_BAGS_COUNT = 0, _
           $ITEM_INFO_ITEMS_COUNT = 1, _
           $ITEM_INFO_GOLD_CHARACTER = 2, _
           $ITEM_INFO_GOLD_STORAGE = 3, _
           $ITEM_INFO_ACTIVE_WEAPON_SET = 4, _
           $ITEM_INFO_WEAPON_SETS = 5, _
           $ITEM_INFO_BUNDLE = 6, _
           $ITEM_INFO_INVENTORY_BAGS = 7, _
           $ITEM_INFO_STORAGE_BAGS = 8, _
           $ITEM_INFO_MATERIAL_STORAGE = 9, _
           $ITEM_INFO_EQUIPPED_BAG = 10, _
           $ITEM_INFO_ALL = 11

; Bag Information Types
Global Enum $BAG_INFO_COUNT = 0, _
           $BAG_INFO_BY_INDEX = 1, _
           $BAG_INFO_BY_ID = 2, _
           $BAG_INFO_BY_TYPE = 3, _
           $BAG_INFO_ALL = 4

; Single Item Information Types
Global Enum $SINGLE_ITEM_INFO_BY_ID = 0, _
           $SINGLE_ITEM_INFO_BY_MODEL_ID = 1, _
           $SINGLE_ITEM_INFO_BY_SINGLE_ITEM = 2, _
           $SINGLE_ITEM_INFO_ALL_BY_BAG_AND_SLOT = 3

; Main function to get item information
Func _Nexus_ItemInfo($infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_ITEM_INFO, 1) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $ITEM_INFO_BAGS_COUNT, $ITEM_INFO_ITEMS_COUNT, $ITEM_INFO_GOLD_CHARACTER, _
             $ITEM_INFO_GOLD_STORAGE, $ITEM_INFO_ACTIVE_WEAPON_SET, $ITEM_INFO_BUNDLE
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $ITEM_INFO_WEAPON_SETS
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 8 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[4][2]
            For $i = 0 To 3
                $aResult[$i][0] = $intValues[$i * 2]     ; Weapon
                $aResult[$i][1] = $intValues[$i * 2 + 1] ; Offhand
            Next

            _CleanupOutput()
            Return $aResult

        Case $ITEM_INFO_INVENTORY_BAGS
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 25 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[5][5]
            For $i = 0 To 4
                $aResult[$i][0] = $intValues[$i * 5]     ; bag_type
                $aResult[$i][1] = $intValues[$i * 5 + 1] ; index
                $aResult[$i][2] = $intValues[$i * 5 + 2] ; ID
                $aResult[$i][3] = $intValues[$i * 5 + 3] ; container_item
                $aResult[$i][4] = $intValues[$i * 5 + 4] ; items_count
            Next

            _CleanupOutput()
            Return $aResult

        Case $ITEM_INFO_STORAGE_BAGS
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 70 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[14][5]
            For $i = 0 To 13
                $aResult[$i][0] = $intValues[$i * 5]     ; bag_type
                $aResult[$i][1] = $intValues[$i * 5 + 1] ; index
                $aResult[$i][2] = $intValues[$i * 5 + 2] ; ID
                $aResult[$i][3] = $intValues[$i * 5 + 3] ; container_item
                $aResult[$i][4] = $intValues[$i * 5 + 4] ; items_count
            Next

            _CleanupOutput()
            Return $aResult

        Case $ITEM_INFO_MATERIAL_STORAGE, $ITEM_INFO_EQUIPPED_BAG
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 5 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[5]
            $aResult[0] = $intValues[0] ; bag_type
            $aResult[1] = $intValues[1] ; index
            $aResult[2] = $intValues[2] ; ID
            $aResult[3] = $intValues[3] ; container_item
            $aResult[4] = $intValues[4] ; items_count

            _CleanupOutput()
            Return $aResult

        Case $ITEM_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 13 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[6]
            $aResult[0] = $intValues[0] ; bags_count
            $aResult[1] = $intValues[1] ; items_count
            $aResult[2] = $intValues[2] ; gold_character
            $aResult[3] = $intValues[3] ; gold_storage
            $aResult[4] = $intValues[4] ; active_weapon_set

            ; Weapon sets
            Local $aWeaponSets[4][2]
            For $i = 0 To 3
                $aWeaponSets[$i][0] = $intValues[5 + $i * 2]     ; Weapon
                $aWeaponSets[$i][1] = $intValues[5 + $i * 2 + 1] ; Offhand
            Next
            $aResult[5] = $aWeaponSets

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get bag information
Func _Nexus_BagInfo($infoType, $param = 0)
    Local $paramCount = 1
    If $infoType = $BAG_INFO_BY_INDEX Or $infoType = $BAG_INFO_BY_ID Or $infoType = $BAG_INFO_BY_TYPE Then
        $paramCount = 2
    EndIf

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_BAG_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount = 2 Then
        _SetParam(1, $param)
    EndIf

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $BAG_INFO_COUNT
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $BAG_INFO_BY_INDEX, $BAG_INFO_BY_ID
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 6 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[6]
            $aResult[0] = $intValues[0] ; bag_type
            $aResult[1] = $intValues[1] ; index
            $aResult[2] = $intValues[2] ; ID
            $aResult[3] = $intValues[3] ; container_item
            $aResult[4] = $intValues[4] ; items_count
            $aResult[5] = $intValues[5] ; valid_items

            _CleanupOutput()
            Return $aResult

        Case $BAG_INFO_BY_TYPE
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $matchingCount = $intValues[0]
            Local $aResult[$matchingCount][5]

            For $i = 0 To $matchingCount - 1
                $aResult[$i][0] = $intValues[$i * 5 + 1] ; bag_type
                $aResult[$i][1] = $intValues[$i * 5 + 2] ; index
                $aResult[$i][2] = $intValues[$i * 5 + 3] ; ID
                $aResult[$i][3] = $intValues[$i * 5 + 4] ; container_item
                $aResult[$i][4] = $intValues[$i * 5 + 5] ; items_count
            Next

            _CleanupOutput()
            Return $aResult

        Case $BAG_INFO_ALL
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($intValues) < 3 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $total = $intValues[0]
            Local $valid = $intValues[1]

            Local $aResult[$valid][5]

            Local $index = 2
            For $i = 0 To $valid - 1
                $aResult[$i][0] = $intValues[$index]     ; bag_type
                $aResult[$i][1] = $intValues[$index + 1] ; index
                $aResult[$i][2] = $intValues[$index + 2] ; ID
                $aResult[$i][3] = $intValues[$index + 3] ; container_item
                $aResult[$i][4] = $intValues[$index + 4] ; items_count
                $index += 5
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get single item information
Func _Nexus_SingleItemInfo($infoType, $param1 = 0, $param2 = 0)
    Local $paramCount = 1

    If $infoType = $SINGLE_ITEM_INFO_BY_ID Or $infoType = $SINGLE_ITEM_INFO_BY_MODEL_ID Then
        $paramCount = 2
    ElseIf $infoType = $SINGLE_ITEM_INFO_BY_SINGLE_ITEM Then
        $paramCount = 3
    EndIf

    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_SINGLE_ITEM_INFO, $paramCount) Then Return SetError(1, 0, 0)
    _SetParam(0, $infoType)

    If $paramCount >= 2 Then
        _SetParam(1, $param1)
    EndIf

    If $paramCount >= 3 Then
        _SetParam(2, $param2)
    EndIf

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $SINGLE_ITEM_INFO_BY_ID, $SINGLE_ITEM_INFO_BY_SINGLE_ITEM, $SINGLE_ITEM_INFO_BY_MODEL_ID
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 20 Or UBound($stringValues) < 3 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult = _ParseItemDetails($intValues);, $stringValues)
            _CleanupOutput()
            Return $aResult

        Case $SINGLE_ITEM_INFO_ALL_BY_BAG_AND_SLOT
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
;~             Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 1 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $bagsCount = $intValues[0]
            Local $aResult[$bagsCount]

            Local $intIndex = 1
;~             Local $strIndex = 0

            For $i = 0 To $bagsCount - 1
                If $intIndex + 3 >= UBound($intValues) Then
                    ExitLoop
                EndIf

                ; Get bag info
                Local $iBagType = $intValues[$intIndex]
                Local $iBagIndex = $intValues[$intIndex + 1]
                Local $iBagID = $intValues[$intIndex + 2]
                Local $iItemsCount = $intValues[$intIndex + 3]
                $intIndex += 4

                ; Create bag data array
                Local $bagData[4]
                $bagData[0] = $iBagType
                $bagData[1] = $iBagIndex
                $bagData[2] = $iBagID
                $bagData[3] = $iItemsCount

                ; Get items in this bag
                If $iItemsCount > 0 Then
                    Local $bagAndItems[2]
                    $bagAndItems[0] = $bagData

                    Local $items[$iItemsCount][5]
                    For $j = 0 To $iItemsCount - 1
                        If $intIndex + 4 >= UBound($intValues) Then ;Or $strIndex >= UBound($stringValues) Then
                            ExitLoop
                        EndIf

                        $items[$j][0] = $intValues[$intIndex]     ; slot
                        $items[$j][1] = $intValues[$intIndex + 1] ; item_id
                        $items[$j][2] = $intValues[$intIndex + 2] ; model_id
                        $items[$j][3] = $intValues[$intIndex + 3] ; type
                        $items[$j][4] = $intValues[$intIndex + 4] ; quantity
;~                         $items[$j][5] = $stringValues[$strIndex]  ; name

                        $intIndex += 5
;~                         $strIndex += 1
                    Next

                    $bagAndItems[1] = $items
                    $aResult[$i] = $bagAndItems
                Else
                    $aResult[$i] = $bagData
                EndIf
            Next

            _CleanupOutput()
            Return $aResult

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

; Function to get bag items information
Func _Nexus_BagItemsInfo($bagIndex)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_BAG_ITEMS_INFO, 1) Then Return SetError(1, 0, 0)
    _SetParam(0, $bagIndex)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
;~     Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

    If @error Or UBound($intValues) < 6 Then
        _CleanupOutput()
        Return SetError(3, 0, 0)
    EndIf

    ; Get bag info
    Local $bagType = $intValues[0]
    Local $bagIdx = $intValues[1]
    Local $bagID = $intValues[2]
    Local $containerItem = $intValues[3]
    Local $itemsCount = $intValues[4]
    Local $validItems = $intValues[5]

    ; Create result array
    Local $aResult[2]

    ; Store bag info in the first element as an array
    Local $bagInfo[5]
    $bagInfo[0] = $bagType
    $bagInfo[1] = $bagIdx
    $bagInfo[2] = $bagID
    $bagInfo[3] = $containerItem
    $bagInfo[4] = $itemsCount
    $aResult[0] = $bagInfo

    If $validItems > 0 Then
        Local $items[$validItems][7]
        Local $intIndex = 6
;~         Local $strIndex = 0

        For $i = 0 To $validItems - 1
            If $intIndex + 6 >= UBound($intValues) Then ;Or $strIndex + 1 >= UBound($stringValues) Then
                ExitLoop
            EndIf

            $items[$i][0] = $intValues[$intIndex]     ; slot
            $items[$i][1] = $intValues[$intIndex + 1] ; item_id
            $items[$i][2] = $intValues[$intIndex + 2] ; model_id
            $items[$i][3] = $intValues[$intIndex + 3] ; type
            $items[$i][4] = $intValues[$intIndex + 4] ; quantity
            $items[$i][5] = $intValues[$intIndex + 5] ; value
            $items[$i][6] = $intValues[$intIndex + 6] ; equipped
;~             $items[$i][7] = $stringValues[$strIndex]     ; name
;~             $items[$i][8] = $stringValues[$strIndex + 1] ; complete_name

            $intIndex += 7
;~             $strIndex += 2
        Next

        $aResult[1] = $items
    EndIf

    _CleanupOutput()
    Return $aResult
EndFunc

; Helper function to parse item details
Func _ParseItemDetails($intValues);, $stringValues)
    Local $aResult[27]

    $aResult[0] = $intValues[0]  ; item_id
    $aResult[1] = $intValues[1]  ; agent_id
    $aResult[2] = $intValues[2]  ; bag_id
    $aResult[3] = $intValues[3]  ; model_file_id
    $aResult[4] = $intValues[4]  ; type

    ; Dye info
    Local $dyeInfo[5]
    $dyeInfo[0] = $intValues[5]  ; dye_tint
    $dyeInfo[1] = $intValues[6]  ; dye1
    $dyeInfo[2] = $intValues[7]  ; dye2
    $dyeInfo[3] = $intValues[8]  ; dye3
    $dyeInfo[4] = $intValues[9]  ; dye4
    $aResult[5] = $dyeInfo

    $aResult[6] = $intValues[10]   ; value
    $aResult[7] = $intValues[11]   ; interaction
    $aResult[8] = $intValues[12]   ; model_id
    $aResult[9] = $intValues[13]   ; item_formula
    $aResult[10] = $intValues[14]  ; is_material_salvageable
    $aResult[11] = $intValues[15]  ; quantity
    $aResult[12] = $intValues[16]  ; equipped
    $aResult[13] = $intValues[17]  ; profession
    $aResult[14] = $intValues[18]  ; slot

    $aResult[15] = $intValues[19] <> 0  ; is_stackable
    $aResult[16] = $intValues[20] <> 0  ; is_inscribable
    $aResult[17] = $intValues[21] <> 0  ; is_material
    $aResult[18] = $intValues[22] <> 0  ; is_zcoin

;~     $aResult[19] = $stringValues[0]     ; customized
;~     $aResult[20] = $stringValues[1]     ; name
;~     $aResult[21] = $stringValues[2]     ; complete_name

    ; Mods
    Local $modCount = $intValues[23]
    If $modCount > 0 Then
        Local $mods[$modCount][5]
        For $i = 0 To $modCount - 1
            $mods[$i][0] = $intValues[24 + $i * 5]     ; mod
            $mods[$i][1] = $intValues[24 + $i * 5 + 1] ; identifier
            $mods[$i][2] = $intValues[24 + $i * 5 + 2] ; arg1
            $mods[$i][3] = $intValues[24 + $i * 5 + 3] ; arg2
            $mods[$i][4] = $intValues[24 + $i * 5 + 4] ; arg
        Next
        $aResult[22] = $mods
    EndIf

    Return $aResult
EndFunc

; Helper functions for item information
Func _ItemInfo_BagsCount()
    Local $result = _Nexus_ItemInfo($ITEM_INFO_BAGS_COUNT)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ItemInfo_ItemsCount()
    Local $result = _Nexus_ItemInfo($ITEM_INFO_ITEMS_COUNT)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ItemInfo_GoldCharacter()
    Local $result = _Nexus_ItemInfo($ITEM_INFO_GOLD_CHARACTER)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ItemInfo_GoldStorage()
    Local $result = _Nexus_ItemInfo($ITEM_INFO_GOLD_STORAGE)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ItemInfo_ActiveWeaponSet()
    Local $result = _Nexus_ItemInfo($ITEM_INFO_ACTIVE_WEAPON_SET)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ItemInfo_WeaponSets()
    Local $result = _Nexus_ItemInfo($ITEM_INFO_WEAPON_SETS)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ItemInfo_Bundle()
    Local $result = _Nexus_ItemInfo($ITEM_INFO_BUNDLE)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ItemInfo_InventoryBags()
    Local $result = _Nexus_ItemInfo($ITEM_INFO_INVENTORY_BAGS)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ItemInfo_StorageBags()
    Local $result = _Nexus_ItemInfo($ITEM_INFO_STORAGE_BAGS)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ItemInfo_MaterialStorage()
    Local $result = _Nexus_ItemInfo($ITEM_INFO_MATERIAL_STORAGE)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ItemInfo_EquippedBag()
    Local $result = _Nexus_ItemInfo($ITEM_INFO_EQUIPPED_BAG)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ItemInfo_All()
    Local $result = _Nexus_ItemInfo($ITEM_INFO_ALL)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for bag information
Func _BagInfo_Count()
    Local $result = _Nexus_BagInfo($BAG_INFO_COUNT)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _BagInfo_ByIndex($index)
    Local $result = _Nexus_BagInfo($BAG_INFO_BY_INDEX, $index)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _BagInfo_ById($id)
    Local $result = _Nexus_BagInfo($BAG_INFO_BY_ID, $id)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _BagInfo_ByType($type)
    Local $result = _Nexus_BagInfo($BAG_INFO_BY_TYPE, $type)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _BagInfo_All()
    Local $result = _Nexus_BagInfo($BAG_INFO_ALL)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper functions for single item information
Func _ItemInfo_ById($id)
    Local $result = _Nexus_SingleItemInfo($SINGLE_ITEM_INFO_BY_ID, $id)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ItemInfo_ByModelId($modelId)
    Local $result = _Nexus_SingleItemInfo($SINGLE_ITEM_INFO_BY_MODEL_ID, $modelId)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ItemInfo_BySingleItem($bagIndex, $slot)
    Local $result = _Nexus_SingleItemInfo($SINGLE_ITEM_INFO_BY_SINGLE_ITEM, $bagIndex, $slot)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _ItemInfo_AllByBagAndSlot()
    Local $result = _Nexus_SingleItemInfo($SINGLE_ITEM_INFO_ALL_BY_BAG_AND_SLOT)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

; Helper function for bag items information
Func _BagItemsInfo($bagIndex)
    Local $result = _Nexus_BagItemsInfo($bagIndex)
    If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc