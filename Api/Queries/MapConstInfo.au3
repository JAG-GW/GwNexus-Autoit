#include-once

; Map Information Types
Global Enum $MAP_INFO_CAMPAIGN = 0, _
$MAP_INFO_CONTINENT = 1, _
$MAP_INFO_REGION = 2, _
$MAP_INFO_REGION_TYPE = 3, _
$MAP_INFO_FLAGS = 4, _
$MAP_INFO_THUMBNAIL_ID = 5, _
$MAP_INFO_PARTY_SIZE = 6, _
$MAP_INFO_PLAYER_SIZE = 7, _
$MAP_INFO_CONTROLLED_OUTPOST_ID = 8, _
$MAP_INFO_FRACTION_MISSION = 9, _
$MAP_INFO_LEVEL = 10, _
$MAP_INFO_NEEDED_PQ = 11, _
$MAP_INFO_MISSION_MAPS_TO = 12, _
$MAP_INFO_XY = 13, _
$MAP_INFO_ICON_START_XY = 14, _
$MAP_INFO_ICON_END_XY = 15, _
$MAP_INFO_ICON_START_XY_DUPE = 16, _
$MAP_INFO_ICON_END_XY_DUPE = 17, _
$MAP_INFO_FILE_ID = 18, _
$MAP_INFO_MISSION_CHRONOLOGY = 19, _
$MAP_INFO_HA_MAP_CHRONOLOGY = 20, _
$MAP_INFO_NAME_ID = 21, _
$MAP_INFO_DESCRIPTION_ID = 22, _
$MAP_INFO_NAME = 23, _
$MAP_INFO_DESCRIPTION = 24, _
$MAP_INFO_ALL_PROPERTIES = 25

; Main function to get map information
Func _Nexus_MapConstInfo($mapID, $infoType)
    If Not _PrepareAction($CMD_QUERY, $QUERY_GET_MAP_INFO, 2) Then Return SetError(1, 0, 0)
    _SetParam(0, $mapID)
    _SetParam(1, $infoType)

    Local $result = _ExecuteAction()
    If Not $result Then Return SetError(2, 0, 0)

    Switch $infoType
        Case $MAP_INFO_CAMPAIGN, $MAP_INFO_CONTINENT, $MAP_INFO_REGION, _
             $MAP_INFO_REGION_TYPE, $MAP_INFO_FLAGS, $MAP_INFO_THUMBNAIL_ID, _
             $MAP_INFO_CONTROLLED_OUTPOST_ID, $MAP_INFO_FRACTION_MISSION, _
             $MAP_INFO_NEEDED_PQ, $MAP_INFO_MISSION_MAPS_TO, _
             $MAP_INFO_FILE_ID, $MAP_INFO_MISSION_CHRONOLOGY, _
             $MAP_INFO_HA_MAP_CHRONOLOGY, $MAP_INFO_NAME_ID, $MAP_INFO_DESCRIPTION_ID
            Local $value = _GetFirstIntValue()
            _CleanupOutput()
            Return $value

        Case $MAP_INFO_PARTY_SIZE, $MAP_INFO_PLAYER_SIZE, $MAP_INFO_LEVEL, _
             $MAP_INFO_XY, $MAP_INFO_ICON_START_XY, $MAP_INFO_ICON_END_XY, _
             $MAP_INFO_ICON_START_XY_DUPE, $MAP_INFO_ICON_END_XY_DUPE
            Local $values = _GetTypedValuesByType($VALUE_TYPE_INT)
            If @error Or UBound($values) < 2 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aResult[2] = [$values[0], $values[1]]
            _CleanupOutput()
            Return $aResult

        Case $MAP_INFO_NAME, $MAP_INFO_DESCRIPTION
            Local $value = _GetFirstStringValue()
            _CleanupOutput()
            Return $value

        Case $MAP_INFO_ALL_PROPERTIES
            Local $intValues = _GetTypedValuesByType($VALUE_TYPE_INT)
            Local $stringValues = _GetTypedValuesByType($VALUE_TYPE_STRING)

            If @error Or UBound($intValues) < 31 Or UBound($stringValues) < 2 Then
                _CleanupOutput()
                Return SetError(3, 0, 0)
            EndIf

            Local $aProperties[33] = [ _
                $intValues[0], _ ;Campaign
                $intValues[1], _ ;Continent
                $intValues[2], _ ;Region
                $intValues[3], _ ;RegionType
                $intValues[4], _ ;Flags
                $intValues[5], _ ;ThumbnailID
                $intValues[6], _ ;MinPartySize
                $intValues[7], _ ;MaxPartySize
                $intValues[8], _ ;MinPlayerSize
                $intValues[9], _ ;MaxPlayerSize
                $intValues[10], _ ;ControlledOutpostID
                $intValues[11], _ ;FractionMission
                $intValues[12], _ ;MinLevel
                $intValues[13], _ ;MaxLevel
                $intValues[14], _ ;NeededPQ
                $intValues[15], _ ;MissionMapsTo
                $intValues[16], _ ;X
                $intValues[17], _ ;Y
                $intValues[18], _ ;IconStartX
                $intValues[19], _ ;IconStartY
                $intValues[20], _ ;IconEndX
                $intValues[21], _ ;IconEndY
                $intValues[22], _ ;IconStartXDupe
                $intValues[23], _ ;IconStartYDupe
                $intValues[24], _ ;IconEndXDupe
                $intValues[25], _ ;IconEndYDupe
                $intValues[26], _ ;FileID
                $intValues[27], _ ;MissionChronology
                $intValues[28], _ ;HAMapChronology
                $intValues[29], _ ;NameID
                $intValues[30], _ ;DescriptionID
                $stringValues[0], _ ;Name
                $stringValues[1]] ;Description

            _CleanupOutput()
            Return $aProperties

        Case Else
            _CleanupOutput()
            Return SetError(4, 0, 0)
    EndSwitch
EndFunc

Func _MapConst_Campaign($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_CAMPAIGN)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_Continent($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_CONTINENT)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_Region($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_REGION)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_RegionType($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_REGION_TYPE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_Flags($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_FLAGS)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_ThumbnailID($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_THUMBNAIL_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_PartySize($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_PARTY_SIZE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_PlayerSize($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_PLAYER_SIZE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_ControlledOutpostID($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_CONTROLLED_OUTPOST_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_FractionMission($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_FRACTION_MISSION)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_Level($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_LEVEL)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_NeededPQ($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_NEEDED_PQ)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_MissionMapsTo($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_MISSION_MAPS_TO)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_XY($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_XY)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_IconStartXY($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_ICON_START_XY)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_IconEndXY($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_ICON_END_XY)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_IconStartXYDupe($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_ICON_START_XY_DUPE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_IconEndXYDupe($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_ICON_END_XY_DUPE)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_FileID($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_FILE_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_MissionChronology($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_MISSION_CHRONOLOGY)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_HAMapChronology($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_HA_MAP_CHRONOLOGY)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_NameID($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_NAME_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_DescriptionID($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_DESCRIPTION_ID)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_Name($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_NAME)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_Description($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_DESCRIPTION)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc

Func _MapConst_AllProperties($mapID)
    Local $result = _Nexus_MapConstInfo($mapID, $MAP_INFO_ALL_PROPERTIES)
	If @error Then Return SetError(1, 0, 0)
    Return $result
EndFunc