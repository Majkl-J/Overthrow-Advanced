private ["_buildings","_building","_gotbuilding","_price","_lease","_sell","_totaloccupants"];

/* Initialises variables and looks around for buildings */
private _buildings = _this nearObjects ["Building",30];
private _gotbuilding = false;
private _building = objNULL;

/* Sorts all the buildings in the radius by distance 
	Closest will be first afterwards */
private _sorted = [_buildings,[_this],{_x distance _input0},"ASCEND"] call BIS_fnc_SortBy;

if(!isNil "modeTarget") then {
	_sorted = _sorted - [modeTarget];
};

/* Goes through the buildings and when it bumps into a valid one, breaks out of loop 
	Closest goes first */
{
	if ((typeof _x) in (OT_allBuyableBuildings+OT_allRepairableRuins)) exitWith {
		_building = _x;
		_gotbuilding = true;
	};
}foreach(_sorted);
/* Checks if there is a building and if yes, returns non-false */
_ret = false;
if(_gotbuilding) then {
	_ret = _building call OT_fnc_getRealEstateData;
	_ret = [_building,_ret select 0,_ret select 1,_ret select 2,_ret select 3]; //[Building,Cost,Sellcost,Lease,OccupantCapacity] 
	if((_ret select 1) isEqualTo -1) then {_ret = false};
};

_ret
