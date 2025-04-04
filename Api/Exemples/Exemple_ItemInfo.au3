#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <TreeViewConstants.au3>
#include <GuiTreeView.au3>
#include <TabConstants.au3>
#include "../Base.au3"
#include "../Queries/ItemInfo.au3"

; Global variables
Global $g_hGUI, $g_idCharInput, $g_idConnectBtn, $g_idInfoTree, $g_idGetInfoBtn, $g_idLog, $g_idClear, $g_idExit
Global $g_idBagIndex, $g_idBagId, $g_idBagType, $g_idItemId, $g_idModelId, $g_idSlot, $g_idTabs
Global $g_idBagInfoCount, $g_idBagInfoByIndex, $g_idBagInfoById, $g_idBagInfoByType, $g_idBagInfoAll, $g_idBagItemsInfo
Global $g_idItemInfoById, $g_idItemInfoByModelId, $g_idItemInfoBySingleItem, $g_idItemInfoAllByBagAndSlot
Global $g_bConnected = False

; Create user interface
Func CreateInterface()
    $g_hGUI = GUICreate("GwNexus - Item Info Explorer", 900, 650)

    ; Connection section
    GUICtrlCreateGroup("Connection", 10, 10, 880, 60)
    GUICtrlCreateLabel("Character name for GwNexus_Initialize:", 20, 30, 250, 20)
    $g_idCharInput = GUICtrlCreateInput("", 270, 30, 500, 20)
    $g_idConnectBtn = GUICtrlCreateButton("Connect", 780, 30, 100, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Tabs for different query types
    $g_idTabs = GUICtrlCreateTab(10, 80, 880, 520)

    ; Item Info Tab
    GUICtrlCreateTabItem("Item Info")

    ; Item info navigation section
    GUICtrlCreateGroup("Item Information", 20, 110, 250, 450)
    $g_idInfoTree = GUICtrlCreateTreeView(30, 130, 230, 400, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_SHOWSELALWAYS))
    $g_idGetInfoBtn = GUICtrlCreateButton("Get Selected Info", 30, 535, 230, 25)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Bag Info Tab
    GUICtrlCreateTabItem("Bag Info")

    ; Bag Parameters
    GUICtrlCreateGroup("Bag Parameters", 20, 110, 250, 150)
    GUICtrlCreateLabel("Bag Index:", 30, 130, 70, 20)
    $g_idBagIndex = GUICtrlCreateInput("0", 110, 130, 150, 20)
    GUICtrlCreateLabel("Bag ID:", 30, 160, 70, 20)
    $g_idBagId = GUICtrlCreateInput("", 110, 160, 150, 20)
    GUICtrlCreateLabel("Bag Type:", 30, 190, 70, 20)
    $g_idBagType = GUICtrlCreateInput("", 110, 190, 150, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Bag Info Action Buttons
    GUICtrlCreateGroup("Bag Info Actions", 20, 270, 250, 210)
    $g_idBagInfoCount = GUICtrlCreateButton("Get Bag Count", 30, 290, 230, 25)
    $g_idBagInfoByIndex = GUICtrlCreateButton("Get Bag By Index", 30, 325, 230, 25)
    $g_idBagInfoById = GUICtrlCreateButton("Get Bag By ID", 30, 360, 230, 25)
    $g_idBagInfoByType = GUICtrlCreateButton("Get Bag By Type", 30, 395, 230, 25)
    $g_idBagInfoAll = GUICtrlCreateButton("Get All Bags", 30, 430, 230, 25)
    $g_idBagItemsInfo = GUICtrlCreateButton("Get Bag Items", 30, 465, 230, 25)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Item Info Tab
    GUICtrlCreateTabItem("Single Item")

    ; Item Parameters
    GUICtrlCreateGroup("Item Parameters", 20, 110, 250, 150)
    GUICtrlCreateLabel("Item ID:", 30, 130, 70, 20)
    $g_idItemId = GUICtrlCreateInput("", 110, 130, 150, 20)
    GUICtrlCreateLabel("Model ID:", 30, 160, 70, 20)
    $g_idModelId = GUICtrlCreateInput("", 110, 160, 150, 20)
    GUICtrlCreateLabel("Slot:", 30, 190, 70, 20)
    $g_idSlot = GUICtrlCreateInput("", 110, 190, 150, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    ; Item Info Action Buttons
    GUICtrlCreateGroup("Item Info Actions", 20, 270, 250, 210)
    $g_idItemInfoById = GUICtrlCreateButton("Get Item By ID", 30, 290, 230, 25)
    $g_idItemInfoByModelId = GUICtrlCreateButton("Get Item By Model ID", 30, 325, 230, 25)
    $g_idItemInfoBySingleItem = GUICtrlCreateButton("Get Item By Bag & Slot", 30, 360, 230, 25)
    $g_idItemInfoAllByBagAndSlot = GUICtrlCreateButton("Get All Items By Bag & Slot", 30, 395, 230, 25)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; End group

    GUICtrlCreateTabItem("") ; End tabs

    ; Results section
    GUICtrlCreateLabel("Results:", 290, 110, 100, 20)
    $g_idLog = GUICtrlCreateEdit("", 290, 130, 590, 430, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL))
    GUICtrlSetFont($g_idLog, 9, 400, 0, "Consolas") ; Fixed-width font for the log

    ; Bottom buttons
    $g_idClear = GUICtrlCreateButton("Clear Log", 690, 610, 100, 30)
    $g_idExit = GUICtrlCreateButton("Exit", 800, 610, 90, 30)

    ; Populate the tree view with item info options
    PopulateItemInfoTree()

    ; Disable controls until connected
    GUICtrlSetState($g_idInfoTree, $GUI_DISABLE)
    GUICtrlSetState($g_idGetInfoBtn, $GUI_DISABLE)
    GUICtrlSetState($g_idBagIndex, $GUI_DISABLE)
    GUICtrlSetState($g_idBagId, $GUI_DISABLE)
    GUICtrlSetState($g_idBagType, $GUI_DISABLE)
    GUICtrlSetState($g_idBagInfoCount, $GUI_DISABLE)
    GUICtrlSetState($g_idBagInfoByIndex, $GUI_DISABLE)
    GUICtrlSetState($g_idBagInfoById, $GUI_DISABLE)
    GUICtrlSetState($g_idBagInfoByType, $GUI_DISABLE)
    GUICtrlSetState($g_idBagInfoAll, $GUI_DISABLE)
    GUICtrlSetState($g_idBagItemsInfo, $GUI_DISABLE)
    GUICtrlSetState($g_idItemId, $GUI_DISABLE)
    GUICtrlSetState($g_idModelId, $GUI_DISABLE)
    GUICtrlSetState($g_idSlot, $GUI_DISABLE)
    GUICtrlSetState($g_idItemInfoById, $GUI_DISABLE)
    GUICtrlSetState($g_idItemInfoByModelId, $GUI_DISABLE)
    GUICtrlSetState($g_idItemInfoBySingleItem, $GUI_DISABLE)
    GUICtrlSetState($g_idItemInfoAllByBagAndSlot, $GUI_DISABLE)

    ; Display the interface
    GUISetState(@SW_SHOW, $g_hGUI)
EndFunc

; Helper function to display item details
Func DisplayItemDetails($item)
    LogWrite("Item Details:")
    LogWrite("  ID: " & $item[0])
    LogWrite("  Agent ID: " & $item[1])
    LogWrite("  Bag ID: " & $item[2])
    LogWrite("  Model File ID: " & $item[3])
    LogWrite("  Type: " & $item[4])

    LogWrite("  Dye Info:")
    LogWrite("    Tint: " & $item[5][0])
    LogWrite("    Dye1: " & $item[5][1])
    LogWrite("    Dye2: " & $item[5][2])
    LogWrite("    Dye3: " & $item[5][3])
    LogWrite("    Dye4: " & $item[5][4])

    LogWrite("  Value: " & $item[6])
    LogWrite("  Interaction: " & $item[7])
    LogWrite("  Model ID: " & $item[8])
    LogWrite("  Item Formula: " & $item[9])
    LogWrite("  Is Material Salvageable: " & $item[10])
    LogWrite("  Quantity: " & $item[11])
    LogWrite("  Equipped: " & $item[12])
    LogWrite("  Profession: " & $item[13])
    LogWrite("  Slot: " & $item[14])

    LogWrite("  Is Stackable: " & $item[15])
    LogWrite("  Is Inscribable: " & $item[16])
    LogWrite("  Is Material: " & $item[17])
    LogWrite("  Is Z-Coin: " & $item[18])

    LogWrite("  Customized: " & $item[19])
    LogWrite("  Name: " & $item[20])
    LogWrite("  Complete Name: " & $item[21])

    If UBound($item) > 22 And IsArray($item[22]) Then
        LogWrite("  Modifiers:")
        Local $mods = $item[22]
        For $i = 0 To UBound($mods) - 1
            LogWrite("    Mod " & $i & ":")
            LogWrite("      Type: " & $mods[$i][0])
            LogWrite("      Identifier: " & $mods[$i][1])
            LogWrite("      Arg1: " & $mods[$i][2])
            LogWrite("      Arg2: " & $mods[$i][3])
            LogWrite("      Arg: " & $mods[$i][4])
        Next
    EndIf
EndFunc

; Main function
Func Main()
    ; Create the interface
    CreateInterface()

    LogWrite("Welcome to the Item Info Explorer!")
    LogWrite("Please enter the character name and click 'Connect'.")

    ; Event handling loop
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $g_idExit
                ExitLoop

            Case $g_idConnectBtn
                ConnectToGwNexus()

            Case $g_idGetInfoBtn
                GetSelectedItemInfo()

            Case $g_idBagInfoCount
                GetBagCount()

            Case $g_idBagInfoByIndex
                GetBagByIndex()

            Case $g_idBagInfoById
                GetBagById()

            Case $g_idBagInfoByType
                GetBagByType()

            Case $g_idBagInfoAll
                GetAllBags()

            Case $g_idBagItemsInfo
                GetBagItems()

            Case $g_idItemInfoById
                GetItemById()

            Case $g_idItemInfoByModelId
                GetItemByModelId()

            Case $g_idItemInfoBySingleItem
                GetItemByBagAndSlot()

            Case $g_idItemInfoAllByBagAndSlot
                GetAllItemsByBagAndSlot()

            Case $g_idClear
                ClearLog()
        EndSwitch
    WEnd

    ; Clean up shared memory before terminating
    If $g_bConnected Then
        GwNexus_Cleanup()
    EndIf

    ; Close the interface
    GUIDelete($g_hGUI)
EndFunc

; Launch the application
Main()

; Populate the tree view with item info options
Func PopulateItemInfoTree()
    ; Basic info categories
    Local $hInventoryInfo = GUICtrlCreateTreeViewItem("Inventory Information", $g_idInfoTree)
    Local $hBagInfo = GUICtrlCreateTreeViewItem("Bag Information", $g_idInfoTree)
    Local $hItemInfo = GUICtrlCreateTreeViewItem("Item Information", $g_idInfoTree)

    ; Inventory info items
    GUICtrlCreateTreeViewItem("Bags Count", $hInventoryInfo)
    GUICtrlCreateTreeViewItem("Items Count", $hInventoryInfo)
    GUICtrlCreateTreeViewItem("Gold (Character)", $hInventoryInfo)
    GUICtrlCreateTreeViewItem("Gold (Storage)", $hInventoryInfo)
    GUICtrlCreateTreeViewItem("Active Weapon Set", $hInventoryInfo)
    GUICtrlCreateTreeViewItem("Weapon Sets", $hInventoryInfo)
    GUICtrlCreateTreeViewItem("Bundle", $hInventoryInfo)
    GUICtrlCreateTreeViewItem("All Basic Info", $hInventoryInfo)

    ; Bag info items
    GUICtrlCreateTreeViewItem("Inventory Bags", $hBagInfo)
    GUICtrlCreateTreeViewItem("Storage Bags", $hBagInfo)
    GUICtrlCreateTreeViewItem("Material Storage", $hBagInfo)
    GUICtrlCreateTreeViewItem("Equipped Bag", $hBagInfo)

    ; Item info items
    GUICtrlCreateTreeViewItem("Items By Bag & Slot", $hItemInfo)

    ; Expand all categories by default
    GUICtrlSetState($hInventoryInfo, $GUI_EXPAND)
    GUICtrlSetState($hBagInfo, $GUI_EXPAND)
    GUICtrlSetState($hItemInfo, $GUI_EXPAND)
EndFunc

; Add text to the log
Func LogWrite($text)
    GUICtrlSetData($g_idLog, GUICtrlRead($g_idLog) & $text & @CRLF)
EndFunc

; Clear the log
Func ClearLog()
    GUICtrlSetData($g_idLog, "")
EndFunc

; Connection function
Func ConnectToGwNexus()
    Local $charName = GUICtrlRead($g_idCharInput)

    If $charName = "" Then
        LogWrite("Error: Please enter a character name for connection.")
        Return False
    EndIf

    LogWrite("Attempting to connect with character: " & $charName)

    ; Initialize connection with the DLL
    GwNexus_Initialize($charName)

    If @error Then
        LogWrite("Error: Unable to connect to GwNexus.")
        Return False
    Else
        LogWrite("Connection to GwNexus established successfully.")
        $g_bConnected = True

        ; Enable controls
        GUICtrlSetState($g_idInfoTree, $GUI_ENABLE)
        GUICtrlSetState($g_idGetInfoBtn, $GUI_ENABLE)
        GUICtrlSetState($g_idBagIndex, $GUI_ENABLE)
        GUICtrlSetState($g_idBagId, $GUI_ENABLE)
        GUICtrlSetState($g_idBagType, $GUI_ENABLE)
        GUICtrlSetState($g_idBagInfoCount, $GUI_ENABLE)
        GUICtrlSetState($g_idBagInfoByIndex, $GUI_ENABLE)
        GUICtrlSetState($g_idBagInfoById, $GUI_ENABLE)
        GUICtrlSetState($g_idBagInfoByType, $GUI_ENABLE)
        GUICtrlSetState($g_idBagInfoAll, $GUI_ENABLE)
        GUICtrlSetState($g_idBagItemsInfo, $GUI_ENABLE)
        GUICtrlSetState($g_idItemId, $GUI_ENABLE)
        GUICtrlSetState($g_idModelId, $GUI_ENABLE)
        GUICtrlSetState($g_idSlot, $GUI_ENABLE)
        GUICtrlSetState($g_idItemInfoById, $GUI_ENABLE)
        GUICtrlSetState($g_idItemInfoByModelId, $GUI_ENABLE)
        GUICtrlSetState($g_idItemInfoBySingleItem, $GUI_ENABLE)
        GUICtrlSetState($g_idItemInfoAllByBagAndSlot, $GUI_ENABLE)

        ; Disable the connect button
        GUICtrlSetState($g_idConnectBtn, $GUI_DISABLE)
        ; Disable the input field
        GUICtrlSetState($g_idCharInput, $GUI_DISABLE)

        Return True
    EndIf
EndFunc

; Get item information based on the selected item in the tree
Func GetSelectedItemInfo()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $selectedItem = GUICtrlRead($g_idInfoTree)
    If $selectedItem = 0 Then
        LogWrite("Error: Please select an information type from the tree.")
        Return
    EndIf

    Local $itemText = _GUICtrlTreeView_GetText($g_idInfoTree, $selectedItem)
    Local $parentHandle = _GUICtrlTreeView_GetParentHandle($g_idInfoTree, $selectedItem)
    Local $parentText = ""

    If $parentHandle Then
        $parentText = _GUICtrlTreeView_GetText($g_idInfoTree, $parentHandle)
    EndIf

    LogWrite("Retrieving item information: " & $parentText & " > " & $itemText)

    ; Process based on parent and selected item
    Switch $parentText
        Case "Inventory Information"
            GetInventoryInfo($itemText)

        Case "Bag Information"
            GetBagInfoType($itemText)

        Case "Item Information"
            GetItemByBagSlot()

        Case Else
            LogWrite("Error: Unknown information category.")
    EndSwitch
EndFunc

; Functions to handle inventory info retrieval
Func GetInventoryInfo($itemText)
    Switch $itemText
        Case "Bags Count"
            Local $result = _ItemInfo_BagsCount()
            If @error Then
                LogWrite("Error retrieving bags count.")
            Else
                LogWrite("Bags Count: " & $result)
            EndIf

        Case "Items Count"
            Local $result = _ItemInfo_ItemsCount()
            If @error Then
                LogWrite("Error retrieving items count.")
            Else
                LogWrite("Items Count: " & $result)
            EndIf

        Case "Gold (Character)"
            Local $result = _ItemInfo_GoldCharacter()
            If @error Then
                LogWrite("Error retrieving character gold.")
            Else
                LogWrite("Character Gold: " & $result)
            EndIf

        Case "Gold (Storage)"
            Local $result = _ItemInfo_GoldStorage()
            If @error Then
                LogWrite("Error retrieving storage gold.")
            Else
                LogWrite("Storage Gold: " & $result)
            EndIf

        Case "Active Weapon Set"
            Local $result = _ItemInfo_ActiveWeaponSet()
            If @error Then
                LogWrite("Error retrieving active weapon set.")
            Else
                LogWrite("Active Weapon Set: " & $result)
            EndIf

        Case "Weapon Sets"
            Local $result = _ItemInfo_WeaponSets()
            If @error Then
                LogWrite("Error retrieving weapon sets.")
            Else
                LogWrite("Weapon Sets:")
                For $i = 0 To 3
                    LogWrite("  Set " & $i & ": Weapon=" & $result[$i][0] & ", Offhand=" & $result[$i][1])
                Next
            EndIf

        Case "Bundle"
            Local $result = _ItemInfo_Bundle()
            If @error Then
                LogWrite("Error retrieving bundle information.")
            Else
                LogWrite("Bundle Item ID: " & $result)
            EndIf

        Case "All Basic Info"
            Local $result = _ItemInfo_All()
            If @error Then
                LogWrite("Error retrieving all basic item information.")
            Else
                LogWrite("All Basic Item Information:")
                LogWrite("  Bags Count: " & $result[0])
                LogWrite("  Items Count: " & $result[1])
                LogWrite("  Gold (Character): " & $result[2])
                LogWrite("  Gold (Storage): " & $result[3])
                LogWrite("  Active Weapon Set: " & $result[4])

                Local $weaponSets = $result[5]
                LogWrite("  Weapon Sets:")
                For $i = 0 To 3
                    LogWrite("    Set " & $i & ": Weapon=" & $weaponSets[$i][0] & ", Offhand=" & $weaponSets[$i][1])
                Next
            EndIf
    EndSwitch
EndFunc

; Functions to handle bag info retrieval
Func GetBagInfoType($itemText)
    Switch $itemText
        Case "Inventory Bags"
            Local $result = _ItemInfo_InventoryBags()
            If @error Then
                LogWrite("Error retrieving inventory bags.")
            Else
                LogWrite("Inventory Bags:")
                For $i = 0 To 4
                    LogWrite("  Bag " & $i & ":")
                    LogWrite("    Type: " & $result[$i][0])
                    LogWrite("    Index: " & $result[$i][1])
                    LogWrite("    ID: " & $result[$i][2])
                    LogWrite("    Container Item: " & $result[$i][3])
                    LogWrite("    Items Count: " & $result[$i][4])
                Next
            EndIf

        Case "Storage Bags"
            Local $result = _ItemInfo_StorageBags()
            If @error Then
                LogWrite("Error retrieving storage bags.")
            Else
                LogWrite("Storage Bags:")
                For $i = 0 To 13
                    LogWrite("  Bag " & $i & ":")
                    LogWrite("    Type: " & $result[$i][0])
                    LogWrite("    Index: " & $result[$i][1])
                    LogWrite("    ID: " & $result[$i][2])
                    LogWrite("    Container Item: " & $result[$i][3])
                    LogWrite("    Items Count: " & $result[$i][4])
                Next
            EndIf

        Case "Material Storage"
            Local $result = _ItemInfo_MaterialStorage()
            If @error Then
                LogWrite("Error retrieving material storage.")
            Else
                LogWrite("Material Storage:")
                LogWrite("  Type: " & $result[0])
                LogWrite("  Index: " & $result[1])
                LogWrite("  ID: " & $result[2])
                LogWrite("  Container Item: " & $result[3])
                LogWrite("  Items Count: " & $result[4])
            EndIf

        Case "Equipped Bag"
            Local $result = _ItemInfo_EquippedBag()
            If @error Then
                LogWrite("Error retrieving equipped bag.")
            Else
                LogWrite("Equipped Bag:")
                LogWrite("  Type: " & $result[0])
                LogWrite("  Index: " & $result[1])
                LogWrite("  ID: " & $result[2])
                LogWrite("  Container Item: " & $result[3])
                LogWrite("  Items Count: " & $result[4])
            EndIf
    EndSwitch
EndFunc

; Function to get items by bag and slot
Func GetItemByBagSlot()
    Local $result = _ItemInfo_AllByBagAndSlot()
    If @error Then
        LogWrite("Error retrieving items by bag and slot.")
    Else
        LogWrite("Items By Bag & Slot:")
        For $i = 0 To UBound($result) - 1
            Local $bagData = $result[$i][0]
            If IsArray($bagData) Then
                LogWrite("  Bag " & $i & ":")
                LogWrite("    Type: " & $bagData[0])
                LogWrite("    Index: " & $bagData[1])
                LogWrite("    ID: " & $bagData[2])
                LogWrite("    Items Count: " & $bagData[3])

                If UBound($result[$i]) > 1 And IsArray($result[$i][1]) Then
                    Local $items = $result[$i][1]
                    LogWrite("    Items:")
                    For $j = 0 To UBound($items) - 1
                        LogWrite("      Slot " & $items[$j][0] & ": ID=" & $items[$j][1] & ", Model=" & $items[$j][2] & ", Name=" & $items[$j][5])
                    Next
                EndIf
            EndIf
        Next
    EndIf
EndFunc

; Function to get bag count
Func GetBagCount()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $result = _BagInfo_Count()
    If @error Then
        LogWrite("Error retrieving bag count.")
    Else
        LogWrite("Bag Count: " & $result)
    EndIf
EndFunc

; Function to get bag by index
Func GetBagByIndex()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $index = Number(GUICtrlRead($g_idBagIndex))
    If $index < 0 Then
        LogWrite("Error: Please enter a valid bag index.")
        Return
    EndIf

    Local $result = _BagInfo_ByIndex($index)
    If @error Then
        LogWrite("Error retrieving bag with index " & $index & ".")
    Else
        LogWrite("Bag with Index " & $index & ":")
        LogWrite("  Type: " & $result[0])
        LogWrite("  Index: " & $result[1])
        LogWrite("  ID: " & $result[2])
        LogWrite("  Container Item: " & $result[3])
        LogWrite("  Items Count: " & $result[4])
        LogWrite("  Valid Items: " & $result[5])
    EndIf
EndFunc

; Function to get bag by ID
Func GetBagById()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $id = Number(GUICtrlRead($g_idBagId))
    If $id <= 0 Then
        LogWrite("Error: Please enter a valid bag ID.")
        Return
    EndIf

    Local $result = _BagInfo_ById($id)
    If @error Then
        LogWrite("Error retrieving bag with ID " & $id & ".")
    Else
        LogWrite("Bag with ID " & $id & ":")
        LogWrite("  Type: " & $result[0])
        LogWrite("  Index: " & $result[1])
        LogWrite("  ID: " & $result[2])
        LogWrite("  Container Item: " & $result[3])
        LogWrite("  Items Count: " & $result[4])
        LogWrite("  Valid Items: " & $result[5])
    EndIf
EndFunc

; Function to get bag by type
Func GetBagByType()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $type = Number(GUICtrlRead($g_idBagType))
    If $type < 0 Then
        LogWrite("Error: Please enter a valid bag type.")
        Return
    EndIf

    Local $result = _BagInfo_ByType($type)
    If @error Then
        LogWrite("Error retrieving bags with type " & $type & ".")
    Else
        LogWrite("Bags with Type " & $type & ":")
        For $i = 0 To UBound($result) - 1
            LogWrite("  Bag " & $i & ":")
            LogWrite("    Type: " & $result[$i][0])
            LogWrite("    Index: " & $result[$i][1])
            LogWrite("    ID: " & $result[$i][2])
            LogWrite("    Container Item: " & $result[$i][3])
            LogWrite("    Items Count: " & $result[$i][4])
        Next
    EndIf
EndFunc

; Function to get all bags
Func GetAllBags()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $result = _BagInfo_All()
    If @error Then
        LogWrite("Error retrieving all bags.")
    Else
        LogWrite("All Bags:")
        For $i = 0 To UBound($result) - 1
            LogWrite("  Bag " & $i & ":")
            LogWrite("    Type: " & $result[$i][0])
            LogWrite("    Index: " & $result[$i][1])
            LogWrite("    ID: " & $result[$i][2])
            LogWrite("    Container Item: " & $result[$i][3])
            LogWrite("    Items Count: " & $result[$i][4])
        Next
    EndIf
EndFunc

; Function to get bag items
Func GetBagItems()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $index = Number(GUICtrlRead($g_idBagIndex))
    If $index < 0 Then
        LogWrite("Error: Please enter a valid bag index.")
        Return
    EndIf

    Local $result = _BagItemsInfo($index)
    If @error Then
        LogWrite("Error retrieving items from bag with index " & $index & ".")
    Else
        LogWrite("Items in Bag with Index " & $index & ":")
        LogWrite("  Bag Info:")
        LogWrite("    Type: " & $result[0][0])
        LogWrite("    Index: " & $result[0][1])
        LogWrite("    ID: " & $result[0][2])
        LogWrite("    Container Item: " & $result[0][3])
        LogWrite("    Items Count: " & $result[0][4])

        If UBound($result) > 1 And IsArray($result[1]) Then
            LogWrite("  Items:")
            For $i = 0 To UBound($result[1]) - 1
                LogWrite("    Slot " & $result[1][$i][0] & ":")
                LogWrite("      ID: " & $result[1][$i][1])
                LogWrite("      Model ID: " & $result[1][$i][2])
                LogWrite("      Type: " & $result[1][$i][3])
                LogWrite("      Quantity: " & $result[1][$i][4])
                LogWrite("      Value: " & $result[1][$i][5])
                LogWrite("      Equipped: " & $result[1][$i][6])
                LogWrite("      Name: " & $result[1][$i][7])
                LogWrite("      Complete Name: " & $result[1][$i][8])
            Next
        EndIf
    EndIf
EndFunc

; Function to get item by ID
Func GetItemById()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $id = Number(GUICtrlRead($g_idItemId))
    If $id <= 0 Then
        LogWrite("Error: Please enter a valid item ID.")
        Return
    EndIf

    Local $result = _ItemInfo_ById($id)
    If @error Then
        LogWrite("Error retrieving item with ID " & $id & ".")
    Else
        DisplayItemDetails($result)
    EndIf
EndFunc

; Function to get item by model ID
Func GetItemByModelId()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $modelId = Number(GUICtrlRead($g_idModelId))
    If $modelId <= 0 Then
        LogWrite("Error: Please enter a valid model ID.")
        Return
    EndIf

    Local $result = _ItemInfo_ByModelId($modelId)
    If @error Then
        LogWrite("Error retrieving item with model ID " & $modelId & ".")
    Else
        DisplayItemDetails($result)
    EndIf
EndFunc

; Function to get item by bag and slot
Func GetItemByBagAndSlot()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $bagIndex = Number(GUICtrlRead($g_idBagIndex))
    Local $slot = Number(GUICtrlRead($g_idSlot))

    If $bagIndex < 0 Then
        LogWrite("Error: Please enter a valid bag index.")
        Return
    EndIf

    If $slot < 0 Then
        LogWrite("Error: Please enter a valid slot.")
        Return
    EndIf

    Local $result = _ItemInfo_BySingleItem($bagIndex, $slot)
    If @error Then
        LogWrite("Error retrieving item at bag " & $bagIndex & ", slot " & $slot & ".")
    Else
        DisplayItemDetails($result)
    EndIf
EndFunc

; Function to get all items by bag and slot
Func GetAllItemsByBagAndSlot()
    If Not $g_bConnected Then
        LogWrite("Error: Please connect to GwNexus first.")
        Return
    EndIf

    Local $result = _ItemInfo_AllByBagAndSlot()
    If @error Then
        LogWrite("Error retrieving all items by bag and slot.")
    Else
        LogWrite("All Items By Bag and Slot:")
        For $i = 0 To UBound($result) - 1
            Local $bagData = $result[$i][0]
            If IsArray($bagData) Then
                LogWrite("  Bag " & $i & ":")
                LogWrite("    Type: " & $bagData[0])
                LogWrite("    Index: " & $bagData[1])
                LogWrite("    ID: " & $bagData[2])
                LogWrite("    Items Count: " & $bagData[3])

                If UBound($result[$i]) > 1 And IsArray($result[$i][1]) Then
                    Local $items = $result[$i][1]
                    LogWrite("    Items:")
                    For $j = 0 To UBound($items) - 1
                        LogWrite("      Slot " & $items[$j][0] & ": ID=" & $items[$j][1] & ", Model=" & $items[$j][2] & ", Name=" & $items[$j][5])
                    Next
                EndIf
            EndIf
        Next
    EndIf
EndFunc