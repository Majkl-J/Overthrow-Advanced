private _data = _this call OT_fnc_getBusinessData; //Gets business data
private _baseprice = 100000; //Baseprice for business
private _stability = 1.0 - ((server getVariable [format["stability%1",OT_nation],100]) / 100); //Parses stability and adjusts it

/* Adjust the price depending on the amount of array values (= business type)
    2 - Produces solely money
    3 - Converts resource into money
    4 - Either converts resource into another resource or solely produces resource
*/
if(count _data isEqualTo 2) then {
    _baseprice = round(_baseprice * 1.5);
};
if(count _data isEqualTo 3) then {
    _baseprice = round(_baseprice * 1.3);
};
if(count _data isEqualTo 4) then {
    /* This checks whether to convert or generate resources depending on whether 3rd array value is defined */
    if!((_data select 2) isEqualTo "" || (_data select 3) isEqualTo "") then { //Converts resources
        _baseprice = round(_baseprice * 1.2);
    };
    if((_data select 2) isEqualTo "" && !((_data select 3) isEqualTo "")) then { //Generates resources
        if((_data select 3) == "OT_Steel") then {
            _baseprice = round(_baseprice * 2.4);
        };
        if((_data select 3) == "OT_Sugarcane") then {
            _baseprice = round(_baseprice * 0.4);
        };
    };
};

/* Adjust business price to increase with stability */
_baseprice + (_baseprice * _stability)
