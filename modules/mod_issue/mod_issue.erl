-module(mod_issue).
-author("Jeff Bell [jeff@5nineshq.com]").

-mod_title("Issues").
-mod_description("Issues for Resources.").

-include_lib("zotonic.hrl").

-export([init/1, do_custom_pivot/2, observe_search_query/2, event/2]).

init(Context) ->
    z_pivot_rsc:define_custom_pivot(?MODULE, [
                                              {rsc_id, "int"},
                                              {issue_type_id, "int"},
					      {issue_detail, "char varying(140)"},
                                              {is_complete, "boolean"},
                                              {assigned_id, "int"},
                                              {request_date, "timestamp with time zone"},
                                              {complete_date, "timestamp with time zone"}
                                             ], Context),

    z_notifier:observe(custom_pivot, {?MODULE, do_custom_pivot}, Context).


do_custom_pivot({custom_pivot, Id}, Context) ->
   case m_rsc:is_a(Id, Context) of
       [issue] ->
           RscId = m_rsc:p(Id, rsc_id, Context),
           IssueTypeId = m_rsc:p(Id, issue_type_id, Context),
	   IssueDetail = m_rsc:p(Id, issue_detail, Context),
           IsComplete = m_rsc:p(Id, is_complete, Context),
           AssignedId = m_rsc:p(Id, assigned_id, Context),
           RequestDate = m_rsc:p(Id, request_date, Context),
           CompleteDate = m_rsc:p(Id, complete_date, Context),
           {?MODULE, [
                {rsc_id, RscId},
                {issue_type_id, IssueTypeId},
		{issue_detail, IssueDetail},
                {is_complete, IsComplete},
                {assigned_id, AssignedId},
                {request_date, RequestDate},
                {complete_date, CompleteDate}
           ]};
    _ -> none
    end.

event({submit, {add_issue, []}, _TriggerId, _TargetId}, Context) ->
        Props1 = proc_form(Context),
            case m_rsc:insert(Props1, Context) of
               {ok, IssueId} ->
                   z_pivot_rsc:pivot_resource(IssueId, Context),
                   z_render:wire({redirect, [{dispatch, "issue_detail"}, {id, IssueId}]}, Context);
               {error, Reason}  ->
                   z_render:growl_error("Error !" ++ atom_to_list(Reason), Context)
	    end;

event({submit, {edit_issue, [{id, Issue}]}, _Trig, _Targ}, Context) ->
        Props = proc_form(Context),
            case m_rsc:update(Issue, Props, Context) of
               {ok, IssueId} ->
                   z_pivot_rsc:pivot_resource(IssueId, Context),
                   z_render:wire({redirect, [{dispatch, "issue_detail"}, {id, IssueId}]}, Context);
               {error, Reason}  ->
                   z_render:growl_error("Error !" ++ atom_to_list(Reason), Context)
	    end;

event({submit, {mark_issue_complete, [{id, Issue}]}, _Trig, _Targ}, Context) ->
        IsComplete = true,
	CompleteDate = z_context:get_q_validated(complete_date2, Context),
	CompleteTime = z_context:get_q_validated(complete_time2, Context),
        CompleteDateTime = fn_date:get_date_time_tuple(CompleteDate, CompleteTime),
	IssueSolution = z_context:get_q_validated(issue_solution2, Context),
        Props = [{is_complete, IsComplete}, {complete_date, CompleteDateTime}, {issue_solution, IssueSolution}],
            case m_rsc:update(Issue, Props, Context) of
               {ok, IssueId} ->
                   z_pivot_rsc:pivot_resource(IssueId, Context),
                   z_render:wire({redirect, [{dispatch, "issue_detail"}, {id, IssueId}]}, Context);
               {error, Reason}  ->
                   z_render:growl_error("Error !" ++ atom_to_list(Reason), Context)
	    end.


observe_search_query({search_query, {issue_count_by_node_type, [{is_complete, IsComplete}, {issue_type_id, IssueType}]}, OffsetLimit}, Context) ->
    m_issue:search({issue_count_by_node_type, [{is_complete, IsComplete}, {issue_type_id, IssueType}]}, OffsetLimit, Context);

observe_search_query({search_query, {issue_count_by_node_sub_type, [{is_complete, IsComplete}, {issue_type_id, IssueType}]}, OffsetLimit}, Context) ->
    m_issue:search({issue_count_by_node_sub_type, [{is_complete, IsComplete}, {issue_type_id, IssueType}]}, OffsetLimit, Context);

observe_search_query({search_query, {issues, Args}, OffsetLimit}, Context) ->
    m_issue:search({issues, Args}, OffsetLimit, Context);

observe_search_query(_, _Context) ->
    undefined.

proc_form(Context) ->
        Title = "Issue",
	IsComplete = z_context:get_q("is_complete", Context, false),
	RscId = z_context:get_q_validated("rsc_id", Context),
        IssueDetail   = z_context:get_q_validated("issue_detail", Context),
        IssueTypeId = z_context:get_q_validated("issue_type_id", Context),
        IssueSolution   = z_context:get_q("issue_solution", Context, ""),
        RequestedBy   = z_context:get_q_validated("requested_by", Context),
        AssignedId = z_context:get_q("assigned_id", Context),
        RequestDate = z_context:get_q_validated("request_date", Context),
        RequestTime = z_context:get_q_validated("request_time", Context),
        CompleteDate = z_context:get_q("complete_date", Context, []),
        CompleteTime = z_context:get_q("complete_time", Context, []),
        RequestDateTime = fn_date:get_date_time_tuple(RequestDate, RequestTime),
        CompleteDateTime = fn_date:get_date_time_tuple(CompleteDate, CompleteTime),
	CategoryId = m_rsc:name_to_id_check(issue, Context),
        Props = [
	    {category_id, CategoryId},
            {title, Title},
	    {is_complete, IsComplete},
	    {rsc_id, z_convert:to_integer(RscId)},
            {issue_type_id, z_convert:to_integer(IssueTypeId)},
            {issue_detail, IssueDetail},
            {issue_solution, IssueSolution},
            {requested_by, RequestedBy},
            {assigned_id, z_convert:to_integer(AssignedId)},
            {request_date, RequestDateTime},
            {complete_date, CompleteDateTime},
            {is_published, true}
        ],
        Props.

