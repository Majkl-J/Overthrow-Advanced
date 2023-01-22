private _total = 0;
private _inf = 0;
/* 
Runs through all the towns NATO abandoned to calculate taxes 
This is different from OT_fnc_getControlledPopulation, which only checks for population
, use that for other cases that might need pop.

Even towns in anarchy are counted towards the tax total
*/
{
    private _town = _x;
    _total = _total + 250;
    /* If the town is an airfield and not a town 
        This is called tourism income
    */
    if(_town in OT_allAirports) then {
        _total = _total + ((server getVariable [format["stability%1",OT_nation],100]) * 3);
    };
    _inf = _inf + 1; //Increases influence

    /* If the town is a town and not an airfield */
    if(_town in OT_allTowns) then {
        private _population = server getVariable format["population%1",_town];
        private _stability = server getVariable format["stability%1",_town];
        private _garrison = server getVariable [format['police%1',_town],0];
        private _add = round(_population * 4 * (_stability/100));
        if(_stability > 49) then {
            _add = round(_add * 4); // Quadruples when town is in resistance control
        };
        _total = _total + _add;
    };
}foreach(server getVariable ["NATOabandoned",[]]);

/* Total is Tax money, inf is influence gained (1 per controlled town/airport)*/
[_total,_inf];