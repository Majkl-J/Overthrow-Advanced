/*  Returns the town's stability, also doubles down as a increase / decrease when supplied with a second arg
*/

/* Parses the town name, breaks out when none of that name exists */
_town = _this select 0;
if !(_town in OT_allTowns) exitWith{};

/* Initialises some variables and updates the stability incase there is a second arg*/
_townmrk = format["%1-abandon",_town];
_stability = (server getVariable [format["stability%1",_town],0])+(_this select 1);
if(_stability < 0) then {_stability = 0};
if(_stability > 100) then {_stability = 100};
server setVariable [format["stability%1",_town],_stability,true];

private _pos = getMarkerPos _townmrk;
if((_pos call OT_fnc_inSpawnDistance) && _stability < 50 && _stability > 0) then {
    private _a = "+";
    if((_this select 1) < 0) then {_a = ""};
    format["[%1] Stability %5%2%4 = %3%4",_town,(_this select 1),_stability,"%",_a] remoteExec ["OT_fnc_notifySilent", 0,false];
};

/*  Updates the markers, they are always there, this just makes them not visible under several conditions
    If the town is not abandoned it wont have a marker.
    Otherwise, it relies on stability 
            (<50 - Anarchy)
            (>50 - Police)
 */
_abandoned = server getVariable "NATOabandoned";
if(_town in _abandoned) then {
    _townmrk setMarkerAlpha 1;
}else{
    _townmrk setMarkerAlpha 0;
};

_garrison = server getVariable [format['police%1',_town],0];
if(_stability < 50) then {
    if(_garrison > 0) then {
        _townmrk setMarkerType "OT_Police";
    }else{
        _townmrk setMarkerType "OT_Anarchy";
    };
}else{
    _townmrk setMarkerType "Empty";
};

/* Updates the colour circle around the town according to who controls it */
if(_stability < 50) then {
    if(_town in _abandoned) then {
        _town setMarkerColor "ColorRed";
    }else{
        _town setMarkerColor "ColorYellow";
    };
    _town setMarkerAlpha 1.0 - (_stability / 50);
    _townmrk setMarkerColor "ColorOPFOR";
}else{
    _townmrk setMarkerColor "ColorGUER";
    if(_town in _abandoned) then {
        _town setMarkerAlpha ((_stability - 50) / 100);
        _town setMarkerColor "ColorGUER";
    }else{
        _town setMarkerAlpha 0;
    };
};
if(_town isEqualTo (server getVariable ["NATOattacking",""])) then {
    _town setMarkerAlpha 0;
};
if !(_town in _abandoned) then {
    _townmrk setMarkerAlpha 0;
    _townmrk setMarkerAlphaLocal 0;
};
