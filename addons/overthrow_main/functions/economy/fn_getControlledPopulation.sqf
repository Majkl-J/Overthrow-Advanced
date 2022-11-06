private _totalpop = 0;

/* Parses the population of all abandoned towns. 
This is not used for taxes */
{
    _totalpop = _totalpop + (server getVariable [format["population%1",_x],0]);
} foreach(server getVariable ["NATOabandoned",[]]);


/*
Old code that is probably stupid
{
    if (_x in _abandoned) then {
        _totalpop = _totalpop + (server getVariable [format["population%1",_x],0]);
    };
}foreach(OT_allTowns);
*/
_totalpop