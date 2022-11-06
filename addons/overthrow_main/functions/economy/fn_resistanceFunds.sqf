private _funds = player getVariable ["money",0];
/* Parses the funds of all players 
also doubles down as adding/subtracting funds when supplied with an argument

this has some old singleplayer case code for some reason but I am not willing to remove it out of fear
*/

if(isMultiplayer) then {
    _funds = server getVariable ["money",0];
};
if(count _this > 0) then {
    _funds = _funds + (_this select 0);
    if(isMultiplayer) then {
        server setVariable ["money",_funds,true];
    }else{
        player setVariable ["money",_funds,true];
    }
};
_funds;
