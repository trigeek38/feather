-module(m_task).
-author("").

-behaviour(gen_model).

%% interface functions
-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2,
    list_rsc/2,
    list_assigned/2,
    get/2,
    insert/3,
    toggle_status/3,
    update_rank/3,
    delete/2,
    search/3
]).

-include_lib("zotonic.hrl").

%% Cache time for task listings and task counts.
-define(MAXAGE_TASK, 0).


%% @doc Fetch the value for the key from a model source
%% @spec m_find_value(Key, Source, Context) -> term()

    % All tasks of the resource.
m_find_value(all_pending, #m{value=undefined} = M, _Context) ->
    M#m{value=all_pending};
m_find_value(_, #m{value=all_pending}, Context) ->
    list_all_pending(Context);

m_find_value(count_all_pending, #m{value=undefined} = M, _Context) ->
    M#m{value=count_all_pending};
m_find_value(_, #m{value=count_all_pending}, Context) ->
    count_all_pending(Context);

m_find_value(rsc, #m{value=undefined} = M, _Context) ->
    M#m{value=rsc};
m_find_value(Id, #m{value=rsc}, Context) ->
    list_rsc(Id, Context);

    % All completed tasks for a resource.
m_find_value(completed, #m{value=undefined} = M, _Context) ->
    M#m{value=completed};
m_find_value(Id, #m{value=completed}, Context) ->
    list_rsc_completed(Id, Context);

    % All pending tasks for a resource.
m_find_value(pending, #m{value=undefined} = M, _Context) ->
    M#m{value=pending};
m_find_value(Id, #m{value=pending}, Context) ->
    list_rsc_pending(Id, Context);

    % Cound all tasks for a resource.
m_find_value(count, #m{value=undefined} = M, _Context) ->
    M#m{value=count};
m_find_value(Id, #m{value=count}, Context) ->
    count_rsc(Id, Context);

    % Count all pending tasks for a resource.
m_find_value(count_pending, #m{value=undefined} = M, _Context) ->
    M#m{value=count_pending};
m_find_value(Id, #m{value=count_pending}, Context) ->
    count_rsc_pending(Id, Context);

    %All tasks assigned to a person.
m_find_value(assigned, #m{value=undefined} = M, _Context) ->
    M#m{value=assigned};
m_find_value(Id, #m{value=assigned}, Context) ->
    list_assigned(Id, Context);

    % All completed tasks for a person.
m_find_value(assigned_completed, #m{value=undefined} = M, _Context) ->
    M#m{value=assigned_completed};
m_find_value(Id, #m{value=assigned_completed}, Context) ->
    list_assigned_completed(Id, Context);

    % All pending tasks for a person.
m_find_value(assigned_pending, #m{value=undefined} = M, _Context) ->
    M#m{value=assigned_pending};
m_find_value(Id, #m{value=assigned_pending}, Context) ->
    list_assigned_pending(Id, Context);

m_find_value(count_assigned, #m{value=undefined} = M, _Context) ->
    M#m{value=count_assigned};
m_find_value(Id, #m{value=count_assigned}, Context) ->
    count_assigned(Id, Context);

m_find_value(count_assigned_pending, #m{value=undefined} = M, _Context) ->
    M#m{value=count_assigned_pending};
m_find_value(Id, #m{value=count_assigned_pending}, Context) ->
    count_assigned_pending(Id, Context);

m_find_value(get, #m{value=undefined} = M, _Context) ->
    M#m{value=get};
m_find_value(TaskId, #m{value=get}, Context) ->
    % Specific task of the resource.
    get(TaskId, Context);

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



%% @doc List all pending tasks.
%% @spec list_rsc(Context) -> [ PropList ]
list_all_pending(Context) ->
    F = fun() ->
        z_db:assoc_props("select * from task where is_complete = false order by created asc", [], Context)
    end,
    z_depcache:memo(F, {task_list_all_pending}, ?MAXAGE_TASK, Context).

%% @doc Count all pending tasks. 
%% @spec count_rsc(Context) -> [ PropList ]
count_all_pending(Context) ->
    F = fun() ->
        z_db:q1("select count(*) from task where is_complete = false", [], Context)
    end,
    z_depcache:memo(F, {task_count_all_pending}, ?MAXAGE_TASK, [{task_rsc_count}], Context).

%% @doc List all task of the resource.
%% @spec list_rsc(int(), Context) -> [ PropList ]
list_rsc(RscId, Context) when is_integer(RscId) ->
    F = fun() ->
        z_db:assoc_props("select * from task where rsc_id = $1 order by created asc", [RscId], Context)
    end,
    z_depcache:memo(F, {task_rsc, RscId}, ?MAXAGE_TASK, Context).
%% @doc List all completed task of the resource.
%% @spec list_rsc(int(), Context) -> [ PropList ]
list_rsc_completed(RscId, Context) when is_integer(RscId) ->
    F = fun() ->
        z_db:assoc_props("select * from task where rsc_id = $1 and is_complete = true order by completed_date asc", [RscId], Context)
    end,
    z_depcache:memo(F, {task_rsc_completed, RscId}, ?MAXAGE_TASK, Context).
%% @doc List all pending task of the resource.
%% @spec list_rsc(int(), Context) -> [ PropList ]
list_rsc_pending(RscId, Context) when is_integer(RscId) ->
    F = fun() ->
        z_db:assoc_props("select * from task where rsc_id = $1 and is_complete = false order by rank asc, created desc", [RscId], Context)
    end,
    z_depcache:memo(F, {task_rsc_pending, RscId}, ?MAXAGE_TASK, Context).

%% @doc Count tasks of the resource.
%% @spec count_rsc(int(), Context) -> [ PropList ]
count_rsc(RscId, Context) when is_integer(RscId) ->
    F = fun() ->
        z_db:q1("select count(*) from task where rsc_id = $1", [RscId], Context)
    end,
    z_depcache:memo(F, {task_rsc_count, RscId}, ?MAXAGE_TASK, [{task_rsc_count, RscId}], Context).
%% @doc Count pending tasks of the resource.
%% @spec count_rsc(int(), Context) -> [ PropList ]
count_rsc_pending(RscId, Context) when is_integer(RscId) ->
    F = fun() ->
        z_db:q1("select count(*) from task where rsc_id = $1 and is_complete = false", [RscId], Context)
    end,
    z_depcache:memo(F, {task_rsc_count_pending, RscId}, ?MAXAGE_TASK, [{task_rsc_count_pending, RscId}], Context).
%% @doc List all tasks of the assigned.
%% @spec list_rsc(int(), Context) -> [ PropList ]
list_assigned(RscId, Context) when is_integer(RscId) ->
    F = fun() ->
        z_db:assoc_props("select * from task where assigned_id = $1 order by created asc", [RscId], Context)
    end,
    z_depcache:memo(F, {task_assigned, RscId}, ?MAXAGE_TASK, Context).

%% @doc List all tasks of the assigned.
%% @spec list_rsc(int(), Context) -> [ PropList ]
list_assigned_completed(RscId, Context) when is_integer(RscId) ->
    F = fun() ->
        z_db:assoc_props("select * from task where assigned_id = $1 and is_complete = true order by created asc", [RscId], Context)
    end,
    z_depcache:memo(F, {task_assigned_completed, RscId}, ?MAXAGE_TASK, Context).
%% @doc List all tasks of the assigned.
%% @spec list_rsc(int(), Context) -> [ PropList ]
list_assigned_pending(RscId, Context) when is_integer(RscId) ->
    F = fun() ->
        z_db:assoc_props("select * from task where assigned_id = $1 and is_complete = false order by created asc", [RscId], Context)
    end,
    z_depcache:memo(F, {task_assigned_pending, RscId}, ?MAXAGE_TASK, Context).
    
%% @doc Count tasks of the assigned.
%% @spec count_rsc(int(), Context) -> [ PropList ]
count_assigned(RscId, Context) when is_integer(RscId) ->
    F = fun() ->
        z_db:q1("select count(*) from task where assigned_id = $1", [RscId], Context)
    end,
    z_depcache:memo(F, {task_assigned_count, RscId}, ?MAXAGE_TASK, [{task_assigned_count, RscId}], Context).
%% @doc Count pending tasks of the assigned.
%% @spec count_rsc(int(), Context) -> [ PropList ]
count_assigned_pending(RscId, Context) when is_integer(RscId) ->
    F = fun() ->
        z_db:q1("select count(*) from task where assigned_id = $1 and is_complete = false", [RscId], Context)
    end,
    z_depcache:memo(F, {task_assigned_count_pending, RscId}, ?MAXAGE_TASK, [{task_assigned_count_pending, RscId}], Context).

%% @doc Fetch a specific task from the database.
%% @spec get(int(), Context) -> PropList
get(TaskId, Context) ->
    z_db:assoc_props_row("select * from task where id = $1", [TaskId], Context).


%% @doc Insert a new task. Fetches the submitter information from the Context.
%% @spec insert(Id::int(), Name::string(), Email::string(), Message::string(), Context) -> {ok, CommentId} | {error, Reason}
%% @todo Insert external ip address and user agent string
insert(RscId, TaskDetail, Context) ->
    case z_acl:rsc_visible(RscId, Context) 
        and (z_auth:is_auth(Context) 
            orelse z_convert:to_bool(m_config:get_value(mod_task, anonymous, true, Context))) of
        true ->
            TaskDetail1 = z_html:escape_link(z_string:trim(TaskDetail)),
            Props = [
                {rsc_id, z_convert:to_integer(RscId)},
                {is_visible, true},
                {user_id, z_acl:user(Context)},
                {assigned_id, z_acl:user(Context)},
                {task_detail, TaskDetail1}
            ],
            case z_db:insert(task, Props, Context) of
                {ok, TaskId} = Result ->
                    z_depcache:flush({task_rsc, RscId}, Context),
                    z_notifier:notify({task_insert, TaskId, RscId}, Context),
                    Result;
                {error, _} = Error ->
                    Error
            end;
        false ->
            {error, eacces}
    end.

toggle_status(TaskId, Status, Context) ->
            z_db:q("update task set is_complete=$2, completed_date = now() where id = $1", [TaskId, Status], Context),
            ok.

update_rank(TaskId, Rank, Context) ->
            z_db:q("update task set rank=$1 where id = $2", [Rank, TaskId], Context),
            ok.

%% @doc Delete a task.  Only possible if the user has edit permission on the page.
delete(TaskId, Context) ->
    case check_editable(TaskId, Context) of
        {ok, RscId} ->
            z_db:q("delete from task where id = $1", [TaskId], Context),
            z_depcache:flush({task_rsc, RscId}, Context),
            ok;
        {error, _} = Error ->
            Error
    end.


%% @doc Check if an user can edit the task
check_editable(TaskId, Context) ->
    case z_db:q_row("select rsc_id, user_id from task where id = $1", [TaskId], Context) of
        {RscId, UserId} ->
            case (UserId /= undefined andalso z_acl:user(Context) == UserId)
                orelse z_acl:rsc_editable(RscId, Context)
            of
                true -> {ok, RscId};
                false -> {error, eacces}
            end;
        _ ->
            {error, enoent}
    end.


search({pending_tasks, []}, _OfffsetLimit, _Context) ->
    #search_sql{
        select="t.*",
        from="task t",
        where="is_complete = false",
        order = "t.created desc",
        assoc=true
    };

search({recent_tasks, []}, _OfffsetLimit, _Context) ->
    #search_sql{
        select="c.*",
        from="task c",
        order="c.created desc",
        assoc=true
    }.

