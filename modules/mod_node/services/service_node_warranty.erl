-module(service_node_warranty).
-author("Jeff Bell <jeff@5nineshq.com>").

-svc_title("Retrieve the list of all expiring warranties.").
-svc_needauth(false).

-export([process_get/2, add_url/1]).

-include_lib("zotonic.hrl").


process_get(_ReqData, Context) ->
    F = fun() ->
                Ids = z_db:assoc_props("select n.id, n.warranty as start, r.pivot_title as title from pivot_mod_node n join rsc r on n.id = r.id where n.warranty is not null;", Context),
		Ids2 = add_url(Ids),
	     {array, [ {struct, [ {Key, z_convert:to_json(Value)} || {Key, Value} <- L] } || L <- Ids2]}
        end,
    z_depcache:memo(F, {warranties}, 0, [], Context).

add_url(Ids) ->
   add_url(Ids, []).

add_url([], NewIds) ->
   NewIds;

add_url([H|T], NewIds) ->
   Id = proplists:get_value(id, H),
   Url = "/inventory/" ++ z_convert:to_list(Id),
   H2 = [{url, Url}|H],
   add_url(T, [H2|NewIds]).

