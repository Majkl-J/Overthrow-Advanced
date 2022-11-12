/*  Returns the town's support, also doubles down as a increase / decrease when supplied with a second arg
    example: [Katkoula, 20] - Increases Katkoula support by 20

    With even more args, it creates a notification and still increases the rep
*/

/* Parses the town name, breaks out when none is present */
private _town = _this select 0;
if(isNil "_town") exitWith {};

/* Parses reputation, and if more args are present, increases/decreases it */
private _rep = (server getVariable [format["rep%1",_town],0]);
if(count _this > 1) then {
    _rep = _rep + (_this select 1);
    server setVariable [format["rep%1",_town],_rep,true];
    _totalrep = (server getVariable ["rep",0])+(_this select 1);
    server setVariable ["rep",_totalrep,true];
};

/* All the random notif shit */
if(count _this > 2) then {
    _pl = "+";
    if((_this select 1) < 0) then {_pl = ""};
    if(count _this > 3) then {
        format["%1 (%4%2 %3)",_this select 2,_this select 1,_town,_pl] remoteExec ["OT_fnc_notifyMinor", _this select 3,false];
    }else{
        format["%1 (%4%2 %3)",_this select 2,_this select 1,_town,_pl] remoteExec ["OT_fnc_notifyMinor", 0,false];
    };
};
_rep;
