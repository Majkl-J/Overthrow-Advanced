private _totalpop = 0;
private _abandoned = server getVariable ["NATOabandoned",[]]; //All towns abandoned by NATO

/* Parses the population of all abandoned towns */
{
    _totalpop = _totalpop + (server getVariable [format["population%1",_x],0]);
} forEach _abandoned;


/*
Old code that is probably stupid
{
    if (_x in _abandoned) then {
        _totalpop = _totalpop + (server getVariable [format["population%1",_x],0]);
    };
}foreach(OT_allTowns);
*/
_totalpop