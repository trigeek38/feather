-module(resource_task_json).
-export([init/1, content_types_provided/2, to_json/2, get_query/2]).

-include_lib("webmachine_resource.hrl").
-include_lib("zotonic.hrl").

init(State) -> {ok, State}.

content_types_provided(ReqData, Context) ->
   {[{"application/json",to_json}], ReqData, Context}.

to_json(ReqData, State) ->
    RD = wrq:set_resp_header("Content-Type", "application/json", ReqData),
    Params = [[{<<"data">>, <<"Jeff">>},{<<"name">>, <<"Bell">>}, {<<"age">>, 34}],
              [{<<"data">>, <<"Bell">>},{<<"name">>, <<"Jeff">>}, {<<"age">>, 42}]
             ],
    Content = z_convert:to_json(Params),
    {Content, RD, State}.

get_query(ReqData, State) ->
    R = z_db:assoc_props("select id, created, rsc_id from task;", z:c(workorders)),
    R.
