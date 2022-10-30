params ["_town","_cls",["_standing",0]];
private ["_cost","_baseprice","_stability"];

private _price = 0;


if(_cls in (OT_allWeapons + OT_allMagazines) && (_town in OT_allTowns)) then { //Weapon and ammo selling
	_stock = server getVariable format["gunstock%1",_town];
	{
		if((_x select 0) isEqualTo _cls) exitWith {_price = _x select 1};
	}foreach(_stock);
}else{
	/* Parses cost and price */
	_cost = cost getVariable [_cls,[10,0,0,0]];
	_baseprice = _cost select 0;

	/* Parses stability and population and adjusts them */
	_stability = 1.0 - ((server getVariable [format["stability%1",_town],100]) / 100);
	_population = server getVariable [format["population%1",_town],1000];
	if(_population > 1000) then {_population = 1000};
	_population = 1-(_population / 1000);

	/* This is currently useless, but might be useful later

	if(_standing < -100) then {_standing = -100};
	if(_standing > 100) then {_standing = 100};
	if(_standing isEqualTo 0) then {_standing = 1};
	_standing = (_standing/100)+1;
	*/

	/* Calculates the final price */
	_price = _baseprice + ((_baseprice * 0.55) + (_baseprice * _stability * _population));
};


if(_price < 1) then {_price = 1};

round(_price)
