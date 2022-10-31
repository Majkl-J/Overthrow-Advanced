/* Gets business data for businesses from economy.sqf
This is in near-linear time.
*/

params ["_name"];
if(_name isEqualTo "Factory") exitWith {[OT_factoryPos,"Factory"]};
_data = [];
{
    if((_x select 1) isEqualTo _name) exitWith {_data = _x};
}foreach(OT_economicData); //Runs through economy.sqf and selects the correct business

_data;
