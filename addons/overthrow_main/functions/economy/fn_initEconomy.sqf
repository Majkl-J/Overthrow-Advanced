if (!isServer) exitwith {};

/*  Automatically determinine the population of each town/city on the map
    For each city and/or town */
OT_allShops = [];
{
    /* _x is the town name */

    
    /* Sets search radius where
    capitals and the Blue Pearl port get a higher search radius */
    private _mSize = 350;
    if(_x in OT_capitals + OT_sprawling) then {
        _mSize = 1000;
    };


    /* Creates a shit ton of variables to load all the houses and shops into */

    private _pos = server getVariable _x; //Position of the town

    private _info = [_x,_pos];

    private _low = []; //Lowpop houses
    private _med = []; //Mediumpop houses
    private _hi = []; //You get the gist
    private _huge = [];
    //private _shops = []; - not used
    private _allshops = []; //All the shop buildings

    /* Scans for building types in range, 
    appends them to the respective lists */
    {
        _low pushback (getpos _x);
    }foreach(nearestObjects [_pos, OT_lowPopHouses, _mSize]);

    {
        _med pushback (getpos _x);
    }foreach(nearestObjects [_pos, OT_medPopHouses, _mSize]);

    {
        _hi pushback (getpos _x);
    }foreach(nearestObjects [_pos, OT_highPopHouses, _mSize]);

    {
        _huge pushback (getpos _x);
    }foreach(nearestObjects [_pos, OT_hugePopHouses, _mSize]);

    {
        _allshops pushback (getpos _x);
    }foreach(nearestObjects [_pos, OT_shops + OT_offices + OT_warehouses + OT_carShops + OT_portBuildings, _mSize]);

    /* Creates counts of all the population semirandomly depending on the type of house */
    private _lopop = round(count(_low) * (random(2) + 1));
    private _medpop = round(count(_med) * (random(4) + 2));
    private _highpop = round(count(_hi) * (count(_allshops)) * 0.2);
    private _hugepop = round(count(_huge) * (count(_allshops)) * 0.8);

    private _pop = round((_lopop + _medpop + _highpop + _hugepop) * OT_populationMultiplier);

    //Used for stability calculations
    private _base = 60 + count(_allshops);
    if(_base > 80) then {
        _base = 80;
    };

    /* Limits max and min pop
        Generates default first init stability
    */
    if(_pop > 1200) then {_pop = 1050 + round(random 150)};
    if(_pop < 20) then {_pop = 15 + round(random 10)};
    private _stability = round(_base + random(20));

    /* Lowers stability significantly for tiny towns */
    if((_pop < 100) && !(_x in OT_NATO_priority) && !(_x in OT_Capitals) && (_x in OT_spawnTowns)) then {
        _stability = floor(30 + random(10));
    };
    server setVariable [format["stability%1",_x],_stability,true];

    private _popVar=format["population%1",_x];
    server setVariable [_popVar,_pop,true];

    {
        if(_pos inArea _x) exitWith {server setVariable [format["region_%1",_x],_x,true]};
    }foreach(OT_regions);
    sleep 0.1;
}foreach (OT_allTowns);


/* Finally creates the towns and regions */
private _spawn = OT_spawnTowns call BIS_fnc_selectrandom;
diag_log format["Overthrow: Spawn town is %1",_spawn];
server setVariable ["spawntown",_spawn,true];
{
    private _region = _x;

    private _towns = [_x] call OT_fnc_townsInRegion;
    server setVariable [format ["towns_%1",_x],_towns,true];
}foreach(OT_regions);

OT_allShops = nil; //Clean this up we dont need it anymore

/* Pushes back true when finished correctly */
OT_economyInitDone = true;
publicVariable "OT_economyInitDone";
