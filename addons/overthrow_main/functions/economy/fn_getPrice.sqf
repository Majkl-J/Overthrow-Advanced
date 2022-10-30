params ["_town","_cls",["_standing",0]];
private _price = 0;

/* Parses trade and adjusts the discount by it */
private _trade = player getvariable ["OT_trade",1];
private _discount = 0;
_discount = 0.02 * _trade;

/* Parses the item cost */
private _cost = cost getVariable [_cls,[10,0,0,0]];
private _baseprice = _cost select 0;

/* Parses stability and adjusts it*/
private _stability = 1.0 - ((server getVariable [format["stability%1",_town],100]) / 100);

if(_cls isEqualTo "WAGE") then {
	_stability = ((server getVariable [format["stability%1",_town],100]) / 100);
};

/* Parses population of the town and adjusts it */
_population = server getVariable [format["population%1",_town],1000];
if(_town isEqualTo OT_nation) then {_population = 100}; // Default for shops with no towns assigned (Or fuel)
if(_population > 2000) then {_population = 2000};
_population = 1-(_population / 2000);

if(_cls == "WAGE" && _town != OT_nation) then {
	_population = (_population / 2000);
};

/* Limits standing and adjusts discount by it
This is sent as a param instead of parsing it from the town; for fuel it's always 100, for wage it's always 0 for some reason (Why)*/
if(_standing < -100) then {_standing = -100};
if(_standing > 100) then {_standing = 100};
_standing = (_standing/500); //0.2% of the standing
_discount = _discount + _standing;

/* Calculates price, affected by stability, population, standing, trade level */
_price = (_baseprice + (_baseprice + (_baseprice * _stability * _population) * (1+OT_standardMarkup))) * (1 - _discount);

if(_cls isEqualTo "FUEL") then {
	_price = _price - 9; //If fuel, adjusts price
};

round(_price)