-module(service_task_all).
-author("Jeff Bell <jeff@5nineshq.com>").

-svc_title("Retrieve the list of all objects from tasks.").
-svc_needauth(false).

-export([process_get/2, add_url/1]).

-include_lib("zotonic.hrl").


process_get(_ReqData, Context) ->
    F = fun() ->
                F2 = fun(Value) -> case is_binary(Value) of true -> z_html:unescape(Value); false -> Value end end,
                Ids = z_db:assoc_props("select t.rsc_id as id, t.task_detail as title, t.created as start from task t;", Context),
		Ids2 = add_url(Ids),
	     {array, [ {struct, [ {Key, F2(z_convert:to_json(Value))} || {Key, Value} <- L] } || L <- Ids2]}
        end,
    z_depcache:memo(F, {tasks}, 0, [], Context).

add_url(Ids) ->
   add_url(Ids, []).

add_url([], NewIds) ->
   NewIds;

add_url([H|T], NewIds) ->
   Id = proplists:get_value(id, H),
   Url = "/howto/" ++ z_convert:to_list(Id) ++ "/howto",
   H2 = [{url, Url}|H],
   add_url(T, [H2|NewIds]).

