params ["_town","_cls",["_standing",0]]; //Standing doesn't effect anything, is only here for consistency
private ["_cost","_baseprice","_stability"];

_price = 0;

/* Parses cost and baseprice */
_cost = cost getVariable _cls;
_baseprice = _cost select 0;

/* Parses stability and population and adjusts them */
_stability = (server getVariable format["stability%1",_town]) / 100;
_population = server getVariable format["population%1",_town];
if(_population > 1000) then {_population = 1000};
_population = (_population / 1000); // 0.1% of population

/* Calculates final price based on stability and population*/
_price = _baseprice + _baseprice * (_stability * _population);

if !(_town in OT_allTowns) then {_price = _price * 0.63};

round(_price);
