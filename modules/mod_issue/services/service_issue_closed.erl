-module(service_issue_closed).
-author("Jeff Bell <jeff@5nineshq.com>").

-svc_title("Retrieve the list of open objects from issues.").
-svc_needauth(false).

-export([process_get/2, get_select_statement/1, add_stuff/1]).

-include_lib("zotonic.hrl").


process_get(_ReqData, Context) ->
    F = fun() ->
                 %% setup fun to unescape json
                 F2 = fun(Value) -> 
		     case is_binary(Value) of true -> 
		         z_html:unescape(Value); false -> Value 
	             end 
		 end,
    SelectStatement = get_select_statement(Context),
    Ids = z_db:assoc_props(SelectStatement, Context),
    Ids2 = add_stuff(Ids),
    {array, [ {struct, [ {Key, F2(z_convert:to_json(Value))} || {Key, Value} <- L] } || L <- Ids2]}
    end,
    z_depcache:memo(F, {open_issues}, 0, [], Context).

get_select_statement(Context) ->
    IssueTypeId = m_rsc:name_to_id_check(issue_work_order, Context),
    Select = "select i.id as id, i.rsc_id as rsc_id, initcap(r.pivot_title) as rsc_title, i.issue_detail as issue_detail, i.created as start",
    From = "from issue i join rsc r on i.rsc_id = r.id",
    Where = "where i.is_complete = true and issue_type_id = " ++ z_convert:to_list(IssueTypeId) ++ ";",
    Statement = string:join([Select, From, Where], " "),
    Statement.

add_stuff(Ids) ->
   add_stuff(Ids, []).

add_stuff([], NewIds) ->
   NewIds;

add_stuff([H|T], NewIds) ->
   Id = proplists:get_value(id, H),
   Url = "/issue/" ++ z_convert:to_list(Id),
   RscTitle = z_convert:to_list(proplists:get_value(rsc_title, H)),
   IssueDetail = z_convert:to_list(proplists:get_value(issue_detail,H)),
   Title = z_convert:to_binary(string:join([RscTitle, " - ", IssueDetail, "..."], " ")),
   H2 = [{url, Url}|H],
   H3 = [{allDay, false}|H2],
   H4 = [{title, Title}|H3],
   add_stuff(T, [H4|NewIds]).

