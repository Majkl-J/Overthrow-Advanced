params ["_town","_cls",["_standing",0]]; //This is the consistent format across all price calculations
private ["_trade","_cost","_baseprice","_stability"];
private _price = 0;

/* Parses trade and adjusts the discount by it */
_trade = player getvariable ["OT_trade",1];

/* Parses the item cost */
_cost = cost getVariable [_cls,[10,0,0,0]];
_baseprice = _cost select 0;

/* Parses stability and adjusts it*/
_stability = 1.0 - ((server getVariable [format["stability%1",_town],100]) / 100);

if(_cls isEqualTo "WAGE") then {
	_stability = ((server getVariable [format["stability%1",_town],100]) / 100); 
};

/* Parses population of the town and adjusts it */
_population = server getVariable [format["population%1",_town],1000]; //For some reason it defaults to 1000 if not set
if(_town isEqualTo OT_nation) then {_population = 100}; // Default for shops with no towns assigned (Or fuel)
if(_population > 2000) then {_population = 2000};
_population = 1-(_population / 2000); //0.95% of population

if(_cls == "WAGE" && _town != OT_nation) then {
	_population = (_population / 2000); //0.05% of population
};

/* Limits and adjusts standing
This is sent as a param instead of parsing it from the town; for fuel it's always 100, for wage it's always 0 for some reason (Why)*/
if(_standing < -100) then {_standing = -100};
if(_standing > 100) then {_standing = 100};
_standing = (_standing/500); //0.2% of the standing

/* Calculates price, affected by stability, population, standing, trade level */
_price = (_baseprice + (_baseprice + (_baseprice * _stability * _population) * (1+OT_standardMarkup))) * (1 - ((0.02 * _trade) + _standing));

if(_cls isEqualTo "FUEL") then {
	_price = _price - 9; //If fuel, adjusts price further
};

round(_price);