-module(service_issue_pm).
-author("Jeff Bell <jeff@5nineshq.com>").

-svc_title("Retrieve the list of open objects from issues.").
-svc_needauth(false).

-export([process_get/2, get_select_statement/2, add_stuff/1, add_now/1]).

-include_lib("zotonic.hrl").


process_get(_ReqData, Context) ->
    case z_context:get_q("status",Context) of
        undefined ->
            {error, missing_arg, "status"};
        [] ->
            {error, missing_arg, "status"};
        Id ->
                 %% setup fun to unescape json
                 F2 = fun(Value) -> 
		     case is_binary(Value) of true -> 
		         z_html:unescape(Value); false -> Value 
	             end 
		 end,
    SelectStatement = get_select_statement(Id, Context),
    Ids = z_db:assoc_props(SelectStatement, Context),
    Ids2 = add_stuff(Ids),
    {array, [ {struct, [ {Key, F2(z_convert:to_json(Value))} || {Key, Value} <- L] } || L <- Ids2]}
    end.

get_select_statement(Id, Context) ->
    IssueTypeId = m_rsc:name_to_id_check(issue_type_pm, Context),
    Action = "select",
    Fields = string:join(["i.id as id",
              "i.rsc_id as rsc_id",
	      "initcap(r.pivot_title) as rsc_title",
	      "left(i.issue_detail, 50) as issue_detail",
	      "i.request_date as start",
	      "i.complete_date as end"
	     ]," ,"),
    From = "from pivot_mod_issue i join rsc r on i.rsc_id = r.id",
    Where = "where i.is_complete = " ++ Id ++ " and i.issue_type_id = " ++ z_convert:to_list(IssueTypeId) ++ ";",
    Statement = string:join([Action, Fields, From, Where], " "),
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
   H5 = add_now(H4),
   add_stuff(T, [H5|NewIds]).

add_now(H) ->
   case proplists:get_value('end',H) of
      undefined ->
           H1 = proplists:delete('end',H),
	   {Y,M,D} = erlang:date(),
	   {Hour,Min,Sec} = erlang:time(),
	   [{'end', {{Y,M,D},{Hour,Min,Sec}}}|H1];
       _ -> H
   end.

