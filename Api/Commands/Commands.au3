#include-once

Func TravelTo($mapId, $district = 0, $region = 0, $language = 0)
    If Not _PrepareAction($CMD_ACTION, $ACTION_TRAVEL_TO, 4) Then Return SetError(@error, 0, False)
    ;DllStructSetData($g_tSharedMem, "params", $mapId, 1)
	_SetParam(0, $mapId)
    ;DllStructSetData($g_tSharedMem, "params", $district, 2)
	_SetParam(1, $district)
    ;DllStructSetData($g_tSharedMem, "params", $region, 3)
	_SetParam(2, $region)
    ;DllStructSetData($g_tSharedMem, "params", $language, 4)
	_SetParam(3, $language)
    Return _ExecuteAction()
EndFunc

Func SkipCinematic()
    If Not _PrepareAction($CMD_ACTION, $ACTION_SKIP_CINEMATIC) Then Return SetError(@error, 0, False)
    Return _ExecuteAction()
EndFunc

Func EnterChallenge()
    If Not _PrepareAction($CMD_ACTION, $ACTION_ENTER_CHALLENGE) Then Return SetError(@error, 0, False)
    Return _ExecuteAction()
EndFunc

Func CancelChallenge()
    If Not _PrepareAction($CMD_ACTION, $ACTION_CANCEL_CHALLENGE) Then Return SetError(@error, 0, False)
    Return _ExecuteAction()
EndFunc

Func SendDialog($dialog_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_SEND_DIALOG, 1) Then Return SetError(@error, 0, False)
    ;DllStructSetData($g_tSharedMem, "params", $dialog_id, 1)
	_SetParam(0, $dialog_id)
    Return _ExecuteAction()
EndFunc

Func ChangeTarget($target_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_CHANGE_TARGET, 1) Then Return SetError(@error, 0, False)
    ;DllStructSetData($g_tSharedMem, "params", $target_id, 1)
	_SetParam(0, $target_id)
    Return _ExecuteAction()
EndFunc

Func Move($x, $y, $z = 0)
    If Not _PrepareAction($CMD_ACTION, $ACTION_MOVE, 3) Then Return SetError(@error, 0, False)
    ;DllStructSetData($g_tSharedMem, "params", $x, 1)
	_SetParam(0, $x)
    ;DllStructSetData($g_tSharedMem, "params", $y, 2)
	_SetParam(1, $y)
    ;DllStructSetData($g_tSharedMem, "params", $z, 3)
	_SetParam(2, $z)
    Return _ExecuteAction()
EndFunc

Func InteractAgent($agent_id, $call_target = 0)
    If Not _PrepareAction($CMD_ACTION, $ACTION_INTERACT_AGENT, 2) Then Return SetError(@error, 0, False)
    ;DllStructSetData($g_tSharedMem, "params", $agent_id, 1)
	_SetParam(0, $agent_id)
    ;DllStructSetData($g_tSharedMem, "params", $call_target, 2)
	_SetParam(1, $call_target)
    Return _ExecuteAction()
EndFunc

Func SendChat($channel, $message)
    If Not _PrepareAction($CMD_ACTION, $ACTION_SEND_CHAT, 1) Then Return SetError(@error, 0, False)
    ;DllStructSetData($g_tSharedMem, "params", AscW($channel), 1)  ; Convert channel character to ASCII
	_SetParam(0, AscW($channel))
    ;DllStructSetData($g_tSharedMem, "string_buffer1", $message)
	_SetStr512_1($message)
    Return _ExecuteAction()
EndFunc

Func DropBuff($buff_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_DROP_BUFF, 1) Then Return SetError(@error, 0, False)
    ;DllStructSetData($g_tSharedMem, "params", $buff_id, 1)
	_SetParam(0, $buff_id)
    Return _ExecuteAction()
EndFunc

Func SetFriendStatus($status)
    If Not _PrepareAction($CMD_ACTION, $ACTION_SET_FRIEND_STATUS, 1) Then Return SetError(@error, 0, False)
    ;DllStructSetData($g_tSharedMem, "params", $status, 1)
	_SetParam(0, $status)
    Return _ExecuteAction()
EndFunc

Func AddFriend($name, $alias = "")
    If Not _PrepareAction($CMD_ACTION, $ACTION_ADD_FRIEND, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "string_buffer1", $name)
    DllStructSetData($g_tSharedMem, "string_buffer2", $alias)
    Return _ExecuteAction()
EndFunc

Func AddIgnore($name, $alias = "")
    If Not _PrepareAction($CMD_ACTION, $ACTION_ADD_IGNORE, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "string_buffer1", $name)
    DllStructSetData($g_tSharedMem, "string_buffer2", $alias)
    Return _ExecuteAction()
EndFunc

Func RemoveFriend($name)
    If Not _PrepareAction($CMD_ACTION, $ACTION_REMOVE_FRIEND, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "string_buffer1", $name)
    Return _ExecuteAction()
EndFunc

Func TravelGH()
    If Not _PrepareAction($CMD_ACTION, $ACTION_TRAVEL_GH) Then Return SetError(@error, 0, False)
    Return _ExecuteAction()
EndFunc

Func LeaveGH()
    If Not _PrepareAction($CMD_ACTION, $ACTION_LEAVE_GH) Then Return SetError(@error, 0, False)
    Return _ExecuteAction()
EndFunc

Func UseItem($item_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_USE_ITEM, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $item_id, 1)
    Return _ExecuteAction()
EndFunc

Func EquipItem($item_id, $agent_id = 0)
    If Not _PrepareAction($CMD_ACTION, $ACTION_EQUIP_ITEM, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $item_id, 1)
    DllStructSetData($g_tSharedMem, "params", $agent_id, 2)
    Return _ExecuteAction()
EndFunc

Func DropItem($item_id, $quantity)
    If Not _PrepareAction($CMD_ACTION, $ACTION_DROP_ITEM, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $item_id, 1)
    DllStructSetData($g_tSharedMem, "params", $quantity, 2)
    Return _ExecuteAction()
EndFunc

Func PingWeaponSet($agent_id, $weapon_id, $offhand_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_PING_WEAPON_SET, 3) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $agent_id, 1)
    DllStructSetData($g_tSharedMem, "params", $weapon_id, 2)
    DllStructSetData($g_tSharedMem, "params", $offhand_id, 3)
    Return _ExecuteAction()
EndFunc

Func PickUpItem($item_id, $call_target = 0)
    If Not _PrepareAction($CMD_ACTION, $ACTION_PICK_UP_ITEM, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $item_id, 1)
    DllStructSetData($g_tSharedMem, "params", $call_target, 2)
    Return _ExecuteAction()
EndFunc

Func OpenXunlai($anniversary = True)
    If Not _PrepareAction($CMD_ACTION, $ACTION_OPEN_XUNLAI, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $anniversary, 1)
    Return _ExecuteAction()
EndFunc

Func DropGold($amount = 1)
    If Not _PrepareAction($CMD_ACTION, $ACTION_DROP_GOLD, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $amount, 1)
    Return _ExecuteAction()
EndFunc

Func IdentifyItem($kit_id, $item_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_IDENTIFY_ITEM, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $kit_id, 1)
    DllStructSetData($g_tSharedMem, "params", $item_id, 2)
    Return _ExecuteAction()
EndFunc

Func DestroyItem($item_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_DESTROY_ITEM, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $item_id, 1)
    Return _ExecuteAction()
EndFunc

Func DepositGold($amount = 0)
    If Not _PrepareAction($CMD_ACTION, $ACTION_DEPOSIT_GOLD, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $amount, 1)
    Return _ExecuteAction()
EndFunc

Func WithdrawGold($amount = 0)
    If Not _PrepareAction($CMD_ACTION, $ACTION_WITHDRAW_GOLD, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $amount, 1)
    Return _ExecuteAction()
EndFunc

Func Tick($flag = True)
    If Not _PrepareAction($CMD_ACTION, $ACTION_TICK, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $flag, 1)
    Return _ExecuteAction()
EndFunc

Func SetHardMode($flag)
    If Not _PrepareAction($CMD_ACTION, $ACTION_SET_HARD_MODE, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $flag, 1)
    Return _ExecuteAction()
EndFunc

Func ReturnToOutpost()
    If Not _PrepareAction($CMD_ACTION, $ACTION_RETURN_TO_OUTPOST) Then Return SetError(@error, 0, False)
    Return _ExecuteAction()
EndFunc

Func RespondToPartyRequest($party_id, $accept)
    If Not _PrepareAction($CMD_ACTION, $ACTION_RESPOND_TO_PARTY_REQUEST, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $party_id, 1)
    DllStructSetData($g_tSharedMem, "params", $accept, 2)
    Return _ExecuteAction()
EndFunc

Func LeaveParty()
    If Not _PrepareAction($CMD_ACTION, $ACTION_LEAVE_PARTY) Then Return SetError(@error, 0, False)
    Return _ExecuteAction()
EndFunc

Func AddHero($hero_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_ADD_HERO, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $hero_id, 1)
    Return _ExecuteAction()
EndFunc

Func KickHero($hero_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_KICK_HERO, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $hero_id, 1)
    Return _ExecuteAction()
EndFunc

Func KickAllHeroes()
    If Not _PrepareAction($CMD_ACTION, $ACTION_KICK_ALL_HEROES) Then Return SetError(@error, 0, False)
    Return _ExecuteAction()
EndFunc

Func AddHenchman($agent_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_ADD_HENCHMAN, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $agent_id, 1)
    Return _ExecuteAction()
EndFunc

Func FlagHero($hero_index, $x, $y)
    If Not _PrepareAction($CMD_ACTION, $ACTION_FLAG_HERO, 3) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $hero_index, 1)
    DllStructSetData($g_tSharedMem, "params", $x, 2)
    DllStructSetData($g_tSharedMem, "params", $y, 3)
    Return _ExecuteAction()
EndFunc

Func FlagAll($x, $y)
    If Not _PrepareAction($CMD_ACTION, $ACTION_FLAG_ALL, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $x, 1)
    DllStructSetData($g_tSharedMem, "params", $y, 2)
    Return _ExecuteAction()
EndFunc

Func UnflagHero($hero_index)
    If Not _PrepareAction($CMD_ACTION, $ACTION_UNFLAG_HERO, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $hero_index, 1)
    Return _ExecuteAction()
EndFunc

Func UnflagAll()
    If Not _PrepareAction($CMD_ACTION, $ACTION_UNFLAG_ALL) Then Return SetError(@error, 0, False)
    Return _ExecuteAction()
EndFunc

Func SetHeroBehavior($agent_id, $behavior)
    If Not _PrepareAction($CMD_ACTION, $ACTION_SET_HERO_BEHAVIOR, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $agent_id, 1)
    DllStructSetData($g_tSharedMem, "params", $behavior, 2)
    Return _ExecuteAction()
EndFunc

Func SetPetBehavior($behavior, $owner_agent_id, $lock_target_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_SET_PET_BEHAVIOR, 3) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $behavior, 1)
    DllStructSetData($g_tSharedMem, "params", $owner_agent_id, 2)
    DllStructSetData($g_tSharedMem, "params", $lock_target_id, 3)
    Return _ExecuteAction()
EndFunc

Func SetActiveTitle($title_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_SET_ACTIVE_TITLE, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $title_id, 1)
    Return _ExecuteAction()
EndFunc

Func RemoveActiveTitle()
    If Not _PrepareAction($CMD_ACTION, $ACTION_REMOVE_ACTIVE_TITLE) Then Return SetError(@error, 0, False)
    Return _ExecuteAction()
EndFunc

Func ChangeSecondProfession($profession, $hero_index = 0)
    If Not _PrepareAction($CMD_ACTION, $ACTION_CHANGE_SECOND_PROFESSION, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $profession, 1)
    DllStructSetData($g_tSharedMem, "params", $hero_index, 2)
    Return _ExecuteAction()
EndFunc

Func DepositFaction($allegiance)
    If Not _PrepareAction($CMD_ACTION, $ACTION_DEPOSIT_FACTION, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $allegiance, 1)
    Return _ExecuteAction()
EndFunc

Func SetActiveQuest($quest_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_SET_ACTIVE_QUEST, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $quest_id, 1)
    Return _ExecuteAction()
EndFunc

Func AbandonQuest($quest_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_ABANDON_QUEST, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $quest_id, 1)
    Return _ExecuteAction()
EndFunc

Func UseSkill($slot, $target = 0)
    If Not _PrepareAction($CMD_ACTION, $ACTION_USE_SKILL, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $slot, 1)
    DllStructSetData($g_tSharedMem, "params", $target, 2)
    Return _ExecuteAction()
EndFunc

Func UseSkillByID($skill_id, $target = 0)
    If Not _PrepareAction($CMD_ACTION, $ACTION_USE_SKILL_BY_ID, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $skill_id, 1)
    DllStructSetData($g_tSharedMem, "params", $target, 2)
    Return _ExecuteAction()
EndFunc

Func LoadSkillTemplate($template, $hero_index = 0)
    If Not _PrepareAction($CMD_ACTION, $ACTION_LOAD_SKILL_TEMPLATE, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "string_buffer3", $template)
    DllStructSetData($g_tSharedMem, "params", $hero_index, 1)
    Return _ExecuteAction()
EndFunc

Func SetAttributes($attributes, $hero_index = 0)
    If Not _PrepareAction($CMD_ACTION, $ACTION_SET_ATTRIBUTES, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "string_buffer3", $attributes)
    DllStructSetData($g_tSharedMem, "params", $hero_index, 1)
    Return _ExecuteAction()
EndFunc

Func OpenTrade($agent_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_OPEN_TRADE, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $agent_id, 1)
    Return _ExecuteAction()
EndFunc

Func AcceptTrade()
    If Not _PrepareAction($CMD_ACTION, $ACTION_ACCEPT_TRADE) Then Return SetError(@error, 0, False)
    Return _ExecuteAction()
EndFunc

Func CancelTrade()
    If Not _PrepareAction($CMD_ACTION, $ACTION_CANCEL_TRADE) Then Return SetError(@error, 0, False)
    Return _ExecuteAction()
EndFunc

Func ChangeOffer()
    If Not _PrepareAction($CMD_ACTION, $ACTION_CHANGE_OFFER) Then Return SetError(@error, 0, False)
    Return _ExecuteAction()
EndFunc

Func SubmitOffer($gold)
    If Not _PrepareAction($CMD_ACTION, $ACTION_SUBMIT_OFFER, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $gold, 1)
    Return _ExecuteAction()
EndFunc

Func RemoveTradeItem($slot)
    If Not _PrepareAction($CMD_ACTION, $ACTION_REMOVE_TRADE_ITEM, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $slot, 1)
    Return _ExecuteAction()
EndFunc

Func OfferTradeItem($item_id, $quantity = 0)
    If Not _PrepareAction($CMD_ACTION, $ACTION_OFFER_TRADE_ITEM, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $item_id, 1)
    DllStructSetData($g_tSharedMem, "params", $quantity, 2)
    Return _ExecuteAction()
EndFunc

Func MerchantBuyItem($item_id, $cost)
    If Not _PrepareAction($CMD_ACTION, $ACTION_MERCHANT_BUY_ITEM, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $item_id, 1)
    DllStructSetData($g_tSharedMem, "params", $cost, 2)
    Return _ExecuteAction()
EndFunc

Func TraderBuyItem($item_id, $cost)
    If Not _PrepareAction($CMD_ACTION, $ACTION_TRADER_BUY_ITEM, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $item_id, 1)
    DllStructSetData($g_tSharedMem, "params", $cost, 2)
    Return _ExecuteAction()
EndFunc

Func MerchantSellItem($item_id, $price)
    If Not _PrepareAction($CMD_ACTION, $ACTION_MERCHANT_SELL_ITEM, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $item_id, 1)
    DllStructSetData($g_tSharedMem, "params", $price, 2)
    Return _ExecuteAction()
EndFunc

Func TraderSellItem($item_id, $price)
    If Not _PrepareAction($CMD_ACTION, $ACTION_TRADER_SELL_ITEM, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $item_id, 1)
    DllStructSetData($g_tSharedMem, "params", $price, 2)
    Return _ExecuteAction()
EndFunc

Func TraderRequestQuote($item_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_TRADER_REQUEST_QUOTE, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $item_id, 1)
    Return _ExecuteAction()
EndFunc

Func TraderRequestSellQuote($item_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_TRADER_REQUEST_SELL_QUOTE, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $item_id, 1)
    Return _ExecuteAction()
EndFunc

Func CrafterBuyItem($item_id, $cost, $give_items, $give_quantities)
    If Not _PrepareAction($CMD_ACTION, $ACTION_CRAFTER_BUY_ITEM, 4) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $item_id, 1)
    DllStructSetData($g_tSharedMem, "params", $cost, 2)
    DllStructSetData($g_tSharedMem, "give_items", $give_items)
    DllStructSetData($g_tSharedMem, "give_quantities", $give_quantities)
    Return _ExecuteAction()
EndFunc

Func CollectorBuyItem($item_id, $cost, $give_items, $give_quantities)
    If Not _PrepareAction($CMD_ACTION, $ACTION_COLLECTOR_BUY_ITEM, 4) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $item_id, 1)
    DllStructSetData($g_tSharedMem, "params", $cost, 2)
    DllStructSetData($g_tSharedMem, "give_items", $give_items)
    DllStructSetData($g_tSharedMem, "give_quantities", $give_quantities)
    Return _ExecuteAction()
EndFunc

; Salvage Item
Func SalvageItem($salvage_kit_id, $item_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_SALVAGE_ITEM, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $salvage_kit_id, 1)
    DllStructSetData($g_tSharedMem, "params", $item_id, 2)
    Return _ExecuteAction()
EndFunc

; Accept Salvage Materials Window
Func AcceptSalvageMaterialsWindow()
    If Not _PrepareAction($CMD_ACTION, $ACTION_ACCEPT_SALVAGE_MATERIALS_WINDOW) Then Return SetError(@error, 0, False)
    Return _ExecuteAction()
EndFunc

; Move Item
Func MoveItem($item_id, $bag_id, $slot, $quantity=1)
    If Not _PrepareAction($CMD_ACTION, $ACTION_MOVE_ITEM, 4) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $item_id, 1)
    DllStructSetData($g_tSharedMem, "params", $bag_id, 2)
    DllStructSetData($g_tSharedMem, "params", $slot, 3)
    DllStructSetData($g_tSharedMem, "params", $quantity, 4)
    Return _ExecuteAction()
EndFunc

; Search Party
Func SearchParty($search_type, $advertisement)
    If Not _PrepareAction($CMD_ACTION, $ACTION_SEARCH_PARTY, 2) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $search_type, 1)
    DllStructSetData($g_tSharedMem, "string_buffer1", $advertisement)
    Return _ExecuteAction()
EndFunc

; Cancel Party Search
Func SearchPartyCancel()
    If Not _PrepareAction($CMD_ACTION, $ACTION_SEARCH_PARTY_CANCEL) Then Return SetError(@error, 0, False)
    Return _ExecuteAction()
EndFunc

; Reply to Party Search
Func SearchPartyReply($accept=True)
    If Not _PrepareAction($CMD_ACTION, $ACTION_SEARCH_PARTY_REPLY, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $accept, 1)
    Return _ExecuteAction()
EndFunc

; Invite Player
Func InvitePlayer($agent_id_or_name)
    If Not _PrepareAction($CMD_ACTION, $ACTION_INVITE_PLAYER, 1) Then Return SetError(@error, 0, False)
    If IsString($agent_id_or_name) Then
        DllStructSetData($g_tSharedMem, "string_buffer1", $agent_id_or_name)
        DllStructSetData($g_tSharedMem, "params", 0, 1)  ; 0 indicates a name
    Else
        DllStructSetData($g_tSharedMem, "params", $agent_id_or_name, 1)
    EndIf
    Return _ExecuteAction()
EndFunc

; Kick Player
Func KickPlayer($login_number)
    If Not _PrepareAction($CMD_ACTION, $ACTION_KICK_PLAYER, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $login_number, 1)
    Return _ExecuteAction()
EndFunc

; Kick Henchman
Func KickHenchman($henchman_id)
    If Not _PrepareAction($CMD_ACTION, $ACTION_KICK_HENCHMAN, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $henchman_id, 1)
    Return _ExecuteAction()
EndFunc

; Send Whisper
Func SendWhisper($target_name, $message)
    If Not _PrepareAction($CMD_ACTION, $ACTION_SEND_WHISPER, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "string_buffer1", $target_name)
    DllStructSetData($g_tSharedMem, "string_buffer2", $message)
    Return _ExecuteAction()
EndFunc

; Send Fake Chat
Func SendFakeChat($channel, $message)
    If Not _PrepareAction($CMD_ACTION, $ACTION_SEND_FAKE_CHAT, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", AscW($channel), 1)  ; Convert channel character to ASCII
    DllStructSetData($g_tSharedMem, "string_buffer1", $message)
    Return _ExecuteAction()
EndFunc

; Send Colored Fake Chat
Func SendFakeChatColored($channel, $message, $r, $g, $b)
    If Not _PrepareAction($CMD_ACTION, $ACTION_SEND_FAKE_CHAT_COLORED, 4) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", AscW($channel), 1)  ; Convert channel character to ASCII
    DllStructSetData($g_tSharedMem, "params", $r, 2)
    DllStructSetData($g_tSharedMem, "params", $g, 3)
    DllStructSetData($g_tSharedMem, "params", $b, 4)
    DllStructSetData($g_tSharedMem, "string_buffer1", $message)
    Return _ExecuteAction()
EndFunc

; Open Locked Chest
Func OpenLockedChest($use_key=False)
    If Not _PrepareAction($CMD_ACTION, $ACTION_OPEN_LOCKED_CHEST, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $use_key, 1)
    Return _ExecuteAction()
EndFunc

; Cancel Move
Func CancelMove()
    If Not _PrepareAction($CMD_ACTION, $ACTION_CANCEL_MOVE) Then Return SetError(@error, 0, False)
    Return _ExecuteAction()
EndFunc

; Hero Use Skill
Func HeroUseSkill($target_agent_id, $skill_number, $hero_number)
    If Not _PrepareAction($CMD_ACTION, $ACTION_HERO_USE_SKILL, 3) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $target_agent_id, 1)
    DllStructSetData($g_tSharedMem, "params", $skill_number, 2)
    DllStructSetData($g_tSharedMem, "params", $hero_number, 3)
    Return _ExecuteAction()
EndFunc

Func UseAnimation($animation_id, $agent_id, $value_id = 20)
    If Not _PrepareAction($CMD_ACTION, $ACTION_USE_ANIMATION, 3) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $animation_id, 1)
    DllStructSetData($g_tSharedMem, "params", $agent_id, 2)
    DllStructSetData($g_tSharedMem, "params", $value_id, 3)
    Return _ExecuteAction()
EndFunc

;only works if the npc with the modelid is in the compass
Func ChangeApparence($agent_id, $model_id, $Size = 100)
    If Not _PrepareAction($CMD_ACTION, $ACTION_CHANGE_APPARENCE, 3) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $agent_id, 1)
    DllStructSetData($g_tSharedMem, "params", $model_id, 2)
    DllStructSetData($g_tSharedMem, "params", $Size, 3)
    Return _ExecuteAction()
EndFunc

Func ShowSpeechBubble($agent_id, $message = "")
    If Not _PrepareAction($CMD_ACTION, $ACTION_SHOW_SPEECH_BUBBLE, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $agent_id, 1)
    DllStructSetData($g_tSharedMem, "str_512_1", $message, 2)
    Return _ExecuteAction()
EndFunc

Func ShowDisplayDialog($agent_id, $name = "", $message = "")
    If Not _PrepareAction($CMD_ACTION, $ACTION_SHOW_DISPLAY_DIALOG, 1) Then Return SetError(@error, 0, False)
    DllStructSetData($g_tSharedMem, "params", $agent_id, 1)
    DllStructSetData($g_tSharedMem, "str_512_1", $name, 2)
    DllStructSetData($g_tSharedMem, "str_512_2", $message, 3)
    Return _ExecuteAction()
EndFunc
