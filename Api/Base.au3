#include-once
#include <WinAPI.au3>
#include <Process.au3>
#include <WinAPIConv.au3>
#include <Array.au3>
#include <Math.au3>

Global Enum $CMD_NONE = 0, $CMD_ACTION = 1, $CMD_QUERY = 2

Global Enum $QUERY_NONE = 0, _
    $QUERY_Get_PreGame_Info = 1, _
    $QUERY_Get_PreGame_Array_LoginCharacter = 2, _
    $QUERY_Get_Skill_Info = 3, _
    $QUERY_Get_Map_Info = 4, _
    $QUERY_Get_Title_Info = 5, _
    $QUERY_Get_Attribute_Info = 6, _
    $QUERY_Get_Agent_Info = 7, _
    $QUERY_Get_AgentItem_Info = 8, _
    $QUERY_Get_AgentGadget_Info = 9, _
    $QUERY_Get_AgentLiving_Info = 10, _
    $QUERY_Get_Agent_VisibleEffect_Info = 11, _
    $QUERY_Get_Agent_Equipment_Info = 12, _
    $QUERY_Get_Agent_TagInfo = 13, _
    $QUERY_Get_Agent_Array_Living = 15, _
    $QUERY_Get_Agent_Array_Item = 16, _
    $QUERY_Get_Agent_Array_Gadget = 17, _
    $QUERY_Get_Cinematic_Info = 18, _
    $QUERY_Get_Basic_Account_Info = 19, _
    $QUERY_Get_Unlocked_Skills_Info = 20, _
    $QUERY_Get_Unlocked_PvP_Items_Info = 21, _
    $QUERY_Get_Unlocked_PvP_Item_Info_Type = 22, _
    $QUERY_Get_Unlocked_Heroes_Info = 23, _
    $QUERY_Get_Unlocked_Counts_Info = 24, _
    $QUERY_Get_Char_Info = 25, _
    $QUERY_Get_Match_Info = 26, _
    $QUERY_Get_Guild_Info = 27, _
    $QUERY_Get_Guilds_Info = 28, _
    $QUERY_Get_Guild_History_Info = 29, _
    $QUERY_Get_Guild_Roster_Info = 30, _
    $QUERY_Get_Town_Alliance_Info = 31, _
    $QUERY_Get_Party_Info = 32, _
    $QUERY_Get_Party_Members_Info = 33, _
    $QUERY_Get_Party_Henchmen_Info = 34, _
    $QUERY_Get_Party_Heroes_Info = 35, _
    $QUERY_Get_Party_Others_Info = 36, _
    $QUERY_Get_Party_Allies_Info = 37, _
    $QUERY_Get_Hero_Flags_Info = 38, _
    $QUERY_Get_Hero_Infos = 39, _
    $QUERY_Get_Controlled_Minions_Info = 40, _
    $QUERY_Get_Party_Morale_Links_Info = 41, _
    $QUERY_Get_Pets_Info = 42, _
    $QUERY_Get_Party_Search_Info = 43, _
    $QUERY_Get_Skillbars_Info = 44, _
    $QUERY_Get_Agent_Effects_Info = 45, _
    $QUERY_Get_Party_Attributes_Info = 46, _
    $QUERY_Get_Trade_Info = 47, _
    $QUERY_Get_Player_Trade_Items_Info = 48, _
    $QUERY_Get_Partner_Trade_Items_Info = 49, _
    $QUERY_Get_AgentCtx_Info = 50, _
    $QUERY_Get_Agent_Summary_Info = 51, _
    $QUERY_Get_Agent_Movement_Info = 52, _
    $QUERY_Get_Item_Info = 53, _
    $QUERY_Get_Bag_Info = 54, _
    $QUERY_Get_Single_Item_Info = 55, _
    $QUERY_Get_Bag_Items_Info = 56, _
    $QUERY_Get_World_Info = 57, _
    $QUERY_Get_Quest_Info = 58, _
    $QUERY_Get_NPC_Info = 59, _
    $QUERY_Get_Player_Info = 60, _
    $QUERY_Get_World_Title_Info = 61, _
    $QUERY_Get_Profession_State_Info = 62

Global Enum $ACTION_NONE = 0, _
	$ACTION_TRAVEL_TO = 1, _
	$ACTION_SKIP_CINEMATIC = 2, _
	$ACTION_ENTER_CHALLENGE = 3, _
	$ACTION_CANCEL_CHALLENGE = 4, _
	$ACTION_SEND_DIALOG = 5, _
	$ACTION_CHANGE_TARGET = 6, _
	$ACTION_MOVE = 7, _
	$ACTION_INTERACT_AGENT = 8, _
	$ACTION_SEND_CHAT = 9, _
	$ACTION_DROP_BUFF = 10, _
	$ACTION_SET_FRIEND_STATUS = 11, _
	$ACTION_ADD_FRIEND = 12, _
	$ACTION_ADD_IGNORE = 13, _
	$ACTION_REMOVE_FRIEND = 14, _
	$ACTION_TRAVEL_GH = 15, _
	$ACTION_LEAVE_GH = 16, _
	$ACTION_USE_ITEM = 17, _
	$ACTION_EQUIP_ITEM = 18, _
	$ACTION_DROP_ITEM = 19, _
	$ACTION_PING_WEAPON_SET = 20, _
	$ACTION_PICK_UP_ITEM = 21, _
	$ACTION_OPEN_XUNLAI = 22, _
	$ACTION_DROP_GOLD = 23, _
	$ACTION_IDENTIFY_ITEM = 24, _
	$ACTION_DESTROY_ITEM = 25, _
	$ACTION_DEPOSIT_GOLD = 26, _
	$ACTION_WITHDRAW_GOLD = 27, _
	$ACTION_TICK = 28, _
	$ACTION_SET_HARD_MODE = 29, _
	$ACTION_RETURN_TO_OUTPOST = 30, _
	$ACTION_RESPOND_TO_PARTY_REQUEST = 31, _
	$ACTION_LEAVE_PARTY = 32, _
	$ACTION_ADD_HERO = 33, _
	$ACTION_KICK_HERO = 34, _
	$ACTION_KICK_ALL_HEROES = 35, _
	$ACTION_ADD_HENCHMAN = 36, _
	$ACTION_FLAG_HERO = 37, _
	$ACTION_FLAG_ALL = 38, _
	$ACTION_UNFLAG_HERO = 39, _
	$ACTION_UNFLAG_ALL = 40, _
	$ACTION_SET_HERO_BEHAVIOR = 41, _
	$ACTION_SET_PET_BEHAVIOR = 42, _
	$ACTION_SET_ACTIVE_TITLE = 43, _
	$ACTION_REMOVE_ACTIVE_TITLE = 44, _
	$ACTION_CHANGE_SECOND_PROFESSION = 45, _
	$ACTION_DEPOSIT_FACTION = 46, _
	$ACTION_SET_ACTIVE_QUEST = 47, _
	$ACTION_ABANDON_QUEST = 48, _
	$ACTION_USE_SKILL = 49, _
	$ACTION_USE_SKILL_BY_ID = 50, _
	$ACTION_LOAD_SKILL_TEMPLATE = 51, _
	$ACTION_SET_ATTRIBUTES = 52, _
	$ACTION_OPEN_TRADE = 53, _
	$ACTION_ACCEPT_TRADE = 54, _
	$ACTION_CANCEL_TRADE = 55, _
	$ACTION_CHANGE_OFFER = 56, _
	$ACTION_SUBMIT_OFFER = 57, _
	$ACTION_REMOVE_TRADE_ITEM = 58, _
	$ACTION_OFFER_TRADE_ITEM = 59, _
	$ACTION_MERCHANT_BUY_ITEM = 60, _
	$ACTION_TRADER_BUY_ITEM = 61, _
	$ACTION_MERCHANT_SELL_ITEM = 62, _
	$ACTION_TRADER_SELL_ITEM = 63, _
	$ACTION_TRADER_REQUEST_QUOTE = 64, _
	$ACTION_TRADER_REQUEST_SELL_QUOTE = 65, _
	$ACTION_CRAFTER_BUY_ITEM = 66, _
	$ACTION_COLLECTOR_BUY_ITEM = 67, _
	$ACTION_USE_ANIMATION = 68, _
	$ACTION_CHANGE_APPARENCE = 69, _
	$ACTION_SHOW_SPEECH_BUBBLE = 70, _
	$ACTION_SHOW_DISPLAY_DIALOG = 71
#CS
$ACTION_SALVAGE_ITEM = 68, _
$ACTION_ACCEPT_SALVAGE_MATERIALS_WINDOW = 69, _
$ACTION_MOVE_ITEM = 70, _
$ACTION_SEARCH_PARTY = 71, _
$ACTION_SEARCH_PARTY_CANCEL = 72, _
$ACTION_SEARCH_PARTY_REPLY = 73, _
$ACTION_INVITE_PLAYER = 74, _
$ACTION_KICK_PLAYER = 75, _
$ACTION_KICK_HENCHMAN = 76, _
$ACTION_SEND_WHISPER = 77, _
$ACTION_SEND_FAKE_CHAT = 78, _
$ACTION_SEND_FAKE_CHAT_COLORED = 79, _
$ACTION_OPEN_LOCKED_CHEST = 80, _
$ACTION_CANCEL_MOVE = 81, _
$ACTION_HERO_USE_SKILL = 82
#CE

Global Enum $VALUE_TYPE_NONE = 0, $VALUE_TYPE_INT = 1, $VALUE_TYPE_FLOAT = 2, $VALUE_TYPE_STRING = 3, $VALUE_TYPE_BOOL = 4

Global Const $EVENT_MODIFY_STATE = 0x0002
Global Const $EVENT_ALL_ACCESS = 0x1F0003
Global Const $SYNCHRONIZE = 0x00100000

Global Const $tagTypedValue = _
    "byte type;" & _
    "align 4;" & _
    "uint int_value;" & _
    "float float_value;" & _
    "bool bool_value;" & _
    "align 4;" & _
    "uint string_length;" & _
    "uint string_offset"

Global Const $tagCommandInput = _
    "dword type;" & _
    "dword subtype;" & _
    "dword param_count;" & _
    "dword params[16];" & _
    "dword float_count;" & _
    "float float_params[8];" & _
    "char str_256_1[256];" & _
    "char str_256_2[256];" & _
    "char str_512_1[512];" & _
    "char str_512_2[512];" & _
    "char str_1024_1[1024];" & _
    "char str_1024_2[1024]"

Global Const $tagCommandOutput = _
    "byte ready;" & _
    "byte completed;" & _
    "byte success;" & _
    "dword size;" & _
    "dword value_count;" & _
    "byte data[262144];" & _
    "char result[256];" & _
    "char error[256]"

Global Const $tagSharedMemory = _
    "struct input;" & $tagCommandInput & ";endstruct;" & _
    "struct output;" & $tagCommandOutput & ";endstruct"

Global Const $OFFSET_INPUT_TYPE = 0
Global Const $OFFSET_INPUT_SUBTYPE = 4
Global Const $OFFSET_INPUT_PARAM_COUNT = 8
Global Const $OFFSET_INPUT_PARAMS = 12
Global Const $OFFSET_INPUT_FLOAT_COUNT = 76
Global Const $OFFSET_INPUT_FLOAT_PARAMS = 80
Global Const $OFFSET_INPUT_STR_256_1 = 112
Global Const $OFFSET_INPUT_STR_256_2 = 368
Global Const $OFFSET_INPUT_STR_512_1 = 624
Global Const $OFFSET_INPUT_STR_512_2 = 1136
Global Const $OFFSET_INPUT_STR_1024_1 = 1648
Global Const $OFFSET_INPUT_STR_1024_2 = 2672

Global Const $OFFSET_OUTPUT_READY = 3696
Global Const $OFFSET_OUTPUT_COMPLETED = 3697
Global Const $OFFSET_OUTPUT_SUCCESS = 3698
Global Const $OFFSET_OUTPUT_SIZE = 3699
Global Const $OFFSET_OUTPUT_VALUE_COUNT = 3703
Global Const $OFFSET_OUTPUT_DATA = 3707
Global Const $OFFSET_OUTPUT_RESULT = 265851
Global Const $OFFSET_OUTPUT_ERROR = 266107

Global Const $SIZE_TYPED_VALUE = 24

Global $g_hMapping = -1
Global $g_pSharedMem = 0
Global $g_tSharedMem = 0
Global $g_hReadyEvent = 0
Global $g_hCompleteEvent = 0
Global $g_bDebugMode = False

Func _Log($sMessage)
    If $g_bDebugMode Then
        ConsoleWrite(@HOUR & ":" & @MIN & ":" & @SEC & " - " & $sMessage & @CRLF)
    EndIf
EndFunc

Func _SetDebugMode($bEnable)
    $g_bDebugMode = $bEnable
EndFunc

Func GwNexus_GetNames($sCharName)
    Local $sProcessedName = StringReplace($sCharName, " ", "_")
    Local $sSharedMemName = "GwNexusSharedMemory_" & $sProcessedName
    Local $sReadyEventName = "GwNexusCommandReady_" & $sProcessedName
    Local $sCompleteEventName = "GwNexusCommandComplete_" & $sProcessedName

    _Log("GwNexus_GetNames - SharedMemName: " & $sSharedMemName)

    Local $aResult[3] = [$sSharedMemName, $sReadyEventName, $sCompleteEventName]
    Return $aResult
EndFunc

Func GwNexus_Initialize($sCharName)
    _Log("GwNexus_Initialize - Begin with character: " & $sCharName)

    Local $aNames = GwNexus_GetNames($sCharName)

    $g_hReadyEvent = DllCall("kernel32.dll", "handle", "OpenEventW", "dword", $EVENT_ALL_ACCESS, "bool", False, "wstr", $aNames[1])[0]
    If Not $g_hReadyEvent Then
        _Log("Failed to open Ready event: " & _WinAPI_GetLastErrorMessage())
        Return False
    EndIf

    $g_hCompleteEvent = DllCall("kernel32.dll", "handle", "OpenEventW", "dword", $EVENT_ALL_ACCESS, "bool", False, "wstr", $aNames[2])[0]
    If Not $g_hCompleteEvent Then
        _Log("Failed to open Complete event: " & _WinAPI_GetLastErrorMessage())
        _WinAPI_CloseHandle($g_hReadyEvent)
        Return False
    EndIf

    $g_hMapping = DllCall("kernel32.dll", "handle", "OpenFileMappingW", "dword", $FILE_MAP_ALL_ACCESS, "bool", False, "wstr", $aNames[0])[0]
    If Not $g_hMapping Then
        _Log("Failed to open shared memory: " & _WinAPI_GetLastErrorMessage())
        _WinAPI_CloseHandle($g_hReadyEvent)
        _WinAPI_CloseHandle($g_hCompleteEvent)
        Return False
    EndIf

    $g_pSharedMem = DllCall("kernel32.dll", "ptr", "MapViewOfFile", "handle", $g_hMapping, "dword", $FILE_MAP_ALL_ACCESS, "dword", 0, "dword", 0, "ulong_ptr", 0)[0]
    If Not $g_pSharedMem Then
        _Log("Failed to map view of file: " & _WinAPI_GetLastErrorMessage())
        _WinAPI_CloseHandle($g_hMapping)
        _WinAPI_CloseHandle($g_hReadyEvent)
        _WinAPI_CloseHandle($g_hCompleteEvent)
        Return False
    EndIf

    $g_tSharedMem = DllStructCreate($tagSharedMemory, $g_pSharedMem)
    If @error Then
        _Log("Failed to create structure: " & @error)
        _WinAPI_UnmapViewOfFile($g_pSharedMem)
        _WinAPI_CloseHandle($g_hMapping)
        _WinAPI_CloseHandle($g_hReadyEvent)
        _WinAPI_CloseHandle($g_hCompleteEvent)
        Return False
    EndIf

    _Log("GwNexus_Initialize - Success")
    Return True
EndFunc

Func GwNexus_Cleanup()
    _Log("GwNexus_Cleanup - Beginning cleanup")

    If $g_pSharedMem Then
        _WinAPI_UnmapViewOfFile($g_pSharedMem)
        $g_pSharedMem = 0
    EndIf

    If $g_hMapping <> -1 Then
        _WinAPI_CloseHandle($g_hMapping)
        $g_hMapping = -1
    EndIf

    If $g_hReadyEvent Then
        _WinAPI_CloseHandle($g_hReadyEvent)
        $g_hReadyEvent = 0
    EndIf

    If $g_hCompleteEvent Then
        _WinAPI_CloseHandle($g_hCompleteEvent)
        $g_hCompleteEvent = 0
    EndIf

    _Log("GwNexus_Cleanup - Completed")
EndFunc

#Region Read data
Func _ReadByte($offset)
    If Not $g_pSharedMem Then Return SetError(1, 0, 0)

    Local $pAddress = $g_pSharedMem + $offset
    Local $tByte = DllStructCreate("byte", $pAddress)
    Return DllStructGetData($tByte, 1)
EndFunc

Func _ReadUint32($offset)
    If Not $g_pSharedMem Then Return SetError(1, 0, 0)

    Local $pAddress = $g_pSharedMem + $offset
    Local $tUint32 = DllStructCreate("dword", $pAddress)
    Return DllStructGetData($tUint32, 1)
EndFunc

Func _ReadFloat($offset)
    If Not $g_pSharedMem Then Return SetError(1, 0, 0)

    Local $pAddress = $g_pSharedMem + $offset
    Local $tFloat = DllStructCreate("float", $pAddress)
    Return DllStructGetData($tFloat, 1)
EndFunc

Func _ReadString($offset, $maxLength)
    If Not $g_pSharedMem Then Return SetError(1, 0, "")

    Local $pAddress = $g_pSharedMem + $offset
    Local $tString = DllStructCreate("char[" & $maxLength & "]", $pAddress)
    Return DllStructGetData($tString, 1)
EndFunc

Func _ReadBool($offset)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)

    Local $pAddress = $g_pSharedMem + $offset
    Local $tBool = DllStructCreate("bool", $pAddress)
    Return DllStructGetData($tBool, 1)
EndFunc
#EndRegion Read data

#Region Write data
Func _WriteByte($offset, $value)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)

    Local $pAddress = $g_pSharedMem + $offset
    Local $tByte = DllStructCreate("byte", $pAddress)
    DllStructSetData($tByte, 1, $value)
    Return True
EndFunc

Func _WriteUint32($offset, $value)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)

    Local $pAddress = $g_pSharedMem + $offset
    Local $tUint32 = DllStructCreate("dword", $pAddress)
    DllStructSetData($tUint32, 1, $value)
    Return True
EndFunc

Func _WriteFloat($offset, $value)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)

    Local $pAddress = $g_pSharedMem + $offset
    Local $tFloat = DllStructCreate("float", $pAddress)
    DllStructSetData($tFloat, 1, $value)
    Return True
EndFunc

Func _WriteString($offset, $value, $maxLength)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)

    Local $pAddress = $g_pSharedMem + $offset
    Local $tString = DllStructCreate("char[" & $maxLength & "]", $pAddress)
    DllStructSetData($tString, 1, StringLeft($value, $maxLength - 1))
    Return True
EndFunc

Func _WriteBool($offset, $value)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)

    Local $pAddress = $g_pSharedMem + $offset
    Local $tBool = DllStructCreate("bool", $pAddress)
    DllStructSetData($tBool, 1, $value)
    Return True
EndFunc
#EndRegion Write data

#Region Input
Func _SetCommandType($type)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)
    Return _WriteUint32($OFFSET_INPUT_TYPE, $type)
EndFunc

Func _SetCommandSubtype($subtype)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)
    Return _WriteUint32($OFFSET_INPUT_SUBTYPE, $subtype)
EndFunc

Func _SetParamCount($count)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)
    Return _WriteUint32($OFFSET_INPUT_PARAM_COUNT, $count)
EndFunc

Func _SetParam($index, $value)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)
    If $index < 0 Or $index >= 16 Then Return SetError(2, 0, False)
    Return _WriteUint32($OFFSET_INPUT_PARAMS + ($index * 4), $value)
EndFunc

Func _SetFloatCount($count)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)
    Return _WriteUint32($OFFSET_INPUT_FLOAT_COUNT, $count)
EndFunc

Func _SetFloatParam($index, $value)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)
    If $index < 0 Or $index >= 8 Then Return SetError(2, 0, False)
    Return _WriteFloat($OFFSET_INPUT_FLOAT_PARAMS + ($index * 4), $value)
EndFunc

Func _SetStr256_1($value)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)
    Return _WriteString($OFFSET_INPUT_STR_256_1, $value, 256)
EndFunc

Func _SetStr256_2($value)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)
    Return _WriteString($OFFSET_INPUT_STR_256_2, $value, 256)
EndFunc

Func _SetStr512_1($value)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)
    Return _WriteString($OFFSET_INPUT_STR_512_1, $value, 512)
EndFunc

Func _SetStr512_2($value)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)
    Return _WriteString($OFFSET_INPUT_STR_512_2, $value, 512)
EndFunc

Func _SetStr1024_1($value)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)
    Return _WriteString($OFFSET_INPUT_STR_1024_1, $value, 1024)
EndFunc

Func _SetStr1024_2($value)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)
    Return _WriteString($OFFSET_INPUT_STR_1024_2, $value, 1024)
EndFunc
#EndRegion Input

#Region Output
Func _IsReady()
    If Not $g_pSharedMem Then Return SetError(1, 0, False)
    Return _ReadByte($OFFSET_OUTPUT_READY) <> 0
EndFunc

Func _IsCompleted()
    If Not $g_pSharedMem Then Return SetError(1, 0, False)
    Return _ReadByte($OFFSET_OUTPUT_COMPLETED) <> 0
EndFunc

Func _IsSuccess()
    If Not $g_pSharedMem Then Return SetError(1, 0, False)
    Return _ReadByte($OFFSET_OUTPUT_SUCCESS) <> 0
EndFunc

Func _GetDataSize()
    If Not $g_pSharedMem Then Return SetError(1, 0, 0)
    Return _ReadUint32($OFFSET_OUTPUT_SIZE)
EndFunc

Func _GetValueCount()
    If Not $g_pSharedMem Then Return SetError(1, 0, 0)
    Return _ReadUint32($OFFSET_OUTPUT_VALUE_COUNT)
EndFunc

Func _GetTypedValue($index)
    If Not $g_pSharedMem Then Return SetError(1, 0, 0)

    Local $valueCount = _GetValueCount()
    If $index >= $valueCount Then Return SetError(2, 0, 0)

    Local $valueOffset = $OFFSET_OUTPUT_DATA + ($index * $SIZE_TYPED_VALUE)
    Local $pValue = $g_pSharedMem + $valueOffset
    Local $tValue = DllStructCreate($tagTypedValue, $pValue)

    Local $type = DllStructGetData($tValue, "type")
    Local $value

    Switch $type
        Case $VALUE_TYPE_INT
            $value = DllStructGetData($tValue, "int_value")
        Case $VALUE_TYPE_FLOAT
            $value = DllStructGetData($tValue, "float_value")
        Case $VALUE_TYPE_BOOL
            $value = DllStructGetData($tValue, "bool_value")
		Case $VALUE_TYPE_STRING
			Local $strLength = DllStructGetData($tValue, "string_length")
			Local $strOffset = DllStructGetData($tValue, "string_offset")

			Local $stringStart = $OFFSET_OUTPUT_DATA + ($valueCount * $SIZE_TYPED_VALUE) + $strOffset

			If $strLength > 1000 Or $strOffset > 4000 Then
				$value = "(erreur)"
			Else
				$value = _ReadString($stringStart, $strLength)
			EndIf
        Case Else
            Return SetError(3, 0, 0)
    EndSwitch

    Local $result[2] = [$type, $value]
    Return $result
EndFunc

Func _GetAllTypedValues()
    If Not $g_pSharedMem Then Return SetError(1, 0, 0)

    Local $valueCount = _GetValueCount()
    If $valueCount <= 0 Then Return SetError(2, 0, 0)

    Local $values[$valueCount][2]  ; [type, value]

    For $i = 0 To $valueCount - 1
        Local $typedValue = _GetTypedValue($i)
        If @error Then
            $values[$i][0] = $VALUE_TYPE_NONE
            $values[$i][1] = 0
        Else
            $values[$i][0] = $typedValue[0]
            $values[$i][1] = $typedValue[1]
        EndIf
    Next

    Return $values
EndFunc

Func _GetTypedValuesByType($type)
    If Not $g_pSharedMem Then Return SetError(1, 0, 0)

    Local $allValues = _GetAllTypedValues()
    If @error Then Return SetError(@error, 0, 0)

    Local $count = 0
    For $i = 0 To UBound($allValues) - 1
        If $allValues[$i][0] = $type Then
            $count += 1
        EndIf
    Next

    If $count = 0 Then Return SetError(2, 0, 0)

    Local $values[$count]
    $count = 0

    For $i = 0 To UBound($allValues) - 1
        If $allValues[$i][0] = $type Then
            $values[$count] = $allValues[$i][1]
            $count += 1
        EndIf
    Next

    Return $values
EndFunc

Func _GetFirstIntValue($defaultValue = 0)
    Local $values = _GetTypedValuesByType($VALUE_TYPE_INT)
    If @error Or UBound($values) = 0 Then Return $defaultValue
    Return $values[0]
EndFunc

Func _GetFirstFloatValue($defaultValue = 0.0)
    Local $values = _GetTypedValuesByType($VALUE_TYPE_FLOAT)
    If @error Or UBound($values) = 0 Then Return $defaultValue
    Return $values[0]
EndFunc

Func _GetFirstStringValue($defaultValue = "")
    Local $values = _GetTypedValuesByType($VALUE_TYPE_STRING)
    If @error Or UBound($values) = 0 Then Return $defaultValue
    Return $values[0]
EndFunc

Func _GetFirstBoolValue($defaultValue = False)
    Local $values = _GetTypedValuesByType($VALUE_TYPE_BOOL)
    If @error Or UBound($values) = 0 Then Return $defaultValue
    Return $values[0]
EndFunc

Func _GetResultText()
    If Not $g_pSharedMem Then Return SetError(1, 0, "")
    Return _ReadString($OFFSET_OUTPUT_RESULT, 256)
EndFunc

Func _GetErrorText()
    If Not $g_pSharedMem Then Return SetError(1, 0, "")
    Return _ReadString($OFFSET_OUTPUT_ERROR, 256)
EndFunc
#EndRegion Output

Func _PrepareAction($type, $subtype, $paramCount = 0)
    If Not $g_pSharedMem Then Return SetError(1, 0, False)
    _WriteUint32($OFFSET_INPUT_TYPE, $type)
    _WriteUint32($OFFSET_INPUT_SUBTYPE, $subtype)
    _WriteUint32($OFFSET_INPUT_PARAM_COUNT, $paramCount)
    Return True
EndFunc

Func _ExecuteAction()
    _WriteByte($OFFSET_OUTPUT_READY, 1)

    If Not _WinAPI_SetEvent($g_hReadyEvent) Then Return SetError(2, 0, False)

    Local $wait = _WinAPI_WaitForSingleObject($g_hCompleteEvent, 5000)
    If $wait <> 0 Then Return SetError(3, 0, False)

    Local $success = _ReadByte($OFFSET_OUTPUT_SUCCESS)
    Return $success <> 0
EndFunc

Func _CleanupOutput()
    If Not $g_pSharedMem Then Return SetError(1, 0, False)

    _WriteByte($OFFSET_OUTPUT_READY, 0)
    _WriteByte($OFFSET_OUTPUT_COMPLETED, 0)
    _WriteByte($OFFSET_OUTPUT_SUCCESS, 0)
    _WriteUint32($OFFSET_OUTPUT_SIZE, 0)
    _WriteUint32($OFFSET_OUTPUT_VALUE_COUNT, 0)

    _WriteString($OFFSET_OUTPUT_RESULT, "", 256)
    _WriteString($OFFSET_OUTPUT_ERROR, "", 256)

    Return True
EndFunc

Func _DumpTypedValues($aValues, $bVerbose = False)
    If Not IsArray($aValues) Then Return ""

    Local $sResult = "["
    For $i = 0 To UBound($aValues) - 1
        If $i > 0 Then $sResult &= ", "

        If $bVerbose Then
            Switch $aValues[$i][0]
                Case $VALUE_TYPE_INT
                    $sResult &= "INT:" & $aValues[$i][1]
                Case $VALUE_TYPE_FLOAT
                    $sResult &= "FLOAT:" & $aValues[$i][1]
                Case $VALUE_TYPE_STRING
                    $sResult &= "STRING:'" & $aValues[$i][1] & "'"
                Case $VALUE_TYPE_BOOL
                    $sResult &= "BOOL:" & ($aValues[$i][1] ? "true" : "false")
                Case Else
                    $sResult &= "UNKNOWN:" & $aValues[$i][1]
            EndSwitch
        Else
            $sResult &= $aValues[$i][1]
        EndIf
    Next

    $sResult &= "]"
    Return $sResult
EndFunc
