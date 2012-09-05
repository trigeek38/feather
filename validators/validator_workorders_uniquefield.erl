-module(validator_workorders_uniquefield).
-include("zotonic.hrl").
-export([render_validator/5, validate/5]).

render_validator(uniquefield, TriggerId, _TargetId, Args, Context)  ->
        JsObject = z_utils:js_object(z_validation:rename_args(Args)),
        Script   = [<<"z_add_validator(\"">>,TriggerId,<<"\", \"uniquefield\", ">>, JsObject, <<");\n">>],
        {[], Script, Context}.


%% @spec validate(Type, TriggerId, Values, Args, Context) -> {ok,AcceptedValue} | {error,Id,Error}
%%          Error = invalid | novalue | {script, Script}
validate(uniquefield, Id, undefined, _Args, Context) ->
    {{error, Id, novalue}, Context};
validate(uniquefield, Id, [], _Args, Context) ->
    {{error, Id, novalue}, Context};
validate(uniquefield, _Id, #upload{} = Value, _Args, Context) ->
    {{ok, Value}, Context};
validate(uniquefield, Id, Value, _Args, Context) ->
    case z_string:trim(Value) of
        [] -> {{error, Id, invalid}, Context};
        Trimmed -> check_name(Trimmed, Context) 
    end.
check_name(Value, Context) ->
    Id = z_db:q1("select id from rsc where pivot_title = " ++ Value ++ ";", Context),
    case Id of
        undefined -> {{ok, Value}, Context};
        _Found -> {{error, Id, invalid}, Context}
    end. 
