-module(m_issue).
-author("").

-behaviour(gen_model).

%% interface functions
-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2,
    list_all_pending/2,
    get/2,
    search/3
]).

-include_lib("zotonic.hrl").

%% Cache time for issue listings and issue counts.
-define(MAXAGE_TASK, 0).


%% @doc Fetch the value for the key from a model source
%% @spec m_find_value(Key, Source, Context) -> term()

    % All issues of the resource.
m_find_value(all_pending, #m{value=undefined} = M, _Context) ->
    M#m{value=all_pending};
m_find_value(Type, #m{value=all_pending}, Context) ->
    list_all_pending(Type, Context);

m_find_value(count_pending_work_orders, #m{value=undefined} = M, _Context) ->
    M#m{value=count_pending_work_orders};
m_find_value(Id, #m{value=count_pending_work_orders}, Context) ->
    count_pending_work_orders(Id, Context);

m_find_value(count_pending_projects, #m{value=undefined} = M, _Context) ->
    M#m{value=count_pending_projects};
m_find_value(Id, #m{value=count_pending_projects}, Context) ->
    count_pending_projects(Id, Context);

m_find_value(get, #m{value=undefined} = M, _Context) ->
    M#m{value=get};
m_find_value(IssueId, #m{value=get}, Context) ->
    % Specific issues of the resource.
    get(IssueId, Context);

m_find_value(_Key, #m{value=undefined}, _Context) ->
   undefined.

%% @doc Transform a m_config value to a list, used for template loops
%% @spec m_to_list(Source, Context) -> []
m_to_list(_, _Context) ->
    [].

%% @doc Transform a model value so that it can be formatted or piped through filters
%% @spec m_value(Source, Context) -> term()
m_value(#m{value=undefined}, _Context) ->
    undefined.


%% @doc List all pending issues.
%% @spec list_rsc(Context) -> [ PropList ]
list_all_pending(Type, Context) ->
    TypeId = m_rsc:name_to_id_check(Type, Context),
    F = z_db:assoc_props("select * from pivot_mod_issue where is_complete = false and issue_type_id = $1 order by request_date asc", [TypeId], Context),
    F.

%% @doc Count pending work order issues of the resource.
%% @spec count_rsc(int(), Context) -> [ PropList ]
count_pending_work_orders(RscId, Context) when is_integer(RscId) ->
    IssueTypeId = m_rsc:name_to_id_check(issue_type_work_order, Context), 
    F = z_db:q1("select count(*) from pivot_mod_issue where rsc_id = $1 and is_complete = false and issue_type_id = $2", [RscId, IssueTypeId], Context),
    F.

%% @doc Count pending project issues of the resource.
%% @spec count_rsc(int(), Context) -> [ PropList ]
count_pending_projects(RscId, Context) when is_integer(RscId) ->
    IssueTypeId = m_rsc:name_to_id_check(issue_type_project, Context), 
    F = z_db:q1("select count(*) from pivot_mod_issue where rsc_id = $1 and is_complete = false and issue_type_id = $2", [RscId, IssueTypeId], Context),
    F.

%% @doc Fetch a specific issue from the database.
%% @spec get(int(), Context) -> PropList
get(IssueId, Context) ->
    z_db:assoc_props_row("select * from issue where id = $1", [IssueId], Context).

search({issue_count_by_node_type, [{is_complete, IsComplete}, {issue_type_id, IssueTypeName}]}, _OfffsetLimit, Context) ->
    IssueTypeId = m_rsc:name_to_id_check(IssueTypeName, Context),
    #search_sql{
        select="count(*) as total, r.node_type_id, s.pivot_title",
        from ="pivot_mod_issue n join pivot_mod_node r on n.rsc_id = r.id join rsc s on r.node_type_id = s.id",
        where="is_complete = $1 and issue_type_id = $2 group by r.node_type_id, s.pivot_title",
	order="s.pivot_title asc",
	args = [IsComplete, IssueTypeId],
        assoc=true
    };

search({issue_count_by_node_sub_type, [{is_complete, IsComplete}, {issue_type_id, IssueTypeName}]}, _OfffsetLimit, Context) ->
    IssueTypeId = m_rsc:name_to_id_check(IssueTypeName, Context),
    #search_sql{
        select="count(*) as total, r.node_sub_type_id",
        from ="pivot_mod_issue n join pivot_mod_node r on n.rsc_id = r.id",
        where="is_complete = $1 and issue_type_id = $2 group by r.node_sub_type_id",
	args = [IsComplete, IssueTypeId],
        assoc=true
    };

search({issues, Args}, _OfffsetLimit, _Context) ->
    Sort = proplists:get_value(sort, Args, "request_date"),
    Order = proplists:get_value(order, Args, "asc"),
    Args1 = proplists:delete(sort, Args),
    Args2 = proplists:delete(order, Args1),
    {WhereString, Arguments} = z_query:get_query_string(Args2),
    #search_sql{
        select="n.*",
        from="pivot_mod_issue n",
        where=WhereString,
        order = z_convert:to_list(Sort) ++ " " ++ z_convert:to_list(Order),
        args=Arguments,
        assoc=true
    }.

