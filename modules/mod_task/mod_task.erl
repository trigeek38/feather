-module(mod_task).
-author("Jeff Bell [jeff@5nineshq.com]").

-mod_title("Tasks").
-mod_description("Tasks for Resources.").

%% gen_server exports
-export([init/1]).

%% interface functions
-export([
    observe_search_query/2, event/2
]).

-include_lib("zotonic.hrl").

event({postback, {toggle_status,[{id,TaskId},{status, Status}]}, _,_}, Context) ->
    NewStatus = case Status of
       true -> false;
       _ -> true
    end,
    m_task:toggle_status(TaskId, NewStatus, Context),
    mod_signal:emit({new_task,[]}, Context),
    Context;
    

event({sort, Sorted, {dragdrop, _, _, _}}, Context) ->
    TaskIds   = [ TaskId || {dragdrop, TaskId, _, _ElementId} <- Sorted ],
    TaskRanks = update_rank(TaskIds),
    [m_task:update_rank(Id,Rank,Context) || {Id, Rank} <- TaskRanks],
    mod_signal:emit({new_task,[]}, Context),
    Context;


event({submit, {add_task,[{id,RscId}]}, _TriggerId, _TargetId}, Context) ->
        TaskDetail = z_context:get_q_validated("task_detail", Context),
        case m_task:insert(RscId,TaskDetail, Context) of
        {ok, _TaskId} ->
            mod_signal:emit({new_task,[]}, Context),
            Context;
        {error, Reason}  ->
            z_render:growl_error("Error !" ++ atom_to_list(Reason), Context)
        end.



%% @doc Return the list of recent tasks.  Returned values are the complete records.
observe_search_query({search_query, {pending_tasks, []}, OffsetLimit}, Context) ->
    m_task:search({pending_tasks, []}, OffsetLimit, Context);
observe_search_query({search_query, {recent_tasks, []}, OffsetLimit}, Context) ->
    m_task:search({recent_tasks, []}, OffsetLimit, Context);
observe_search_query(_, _Context) ->
    undefined.


%% @doc Check the installation of the comment table. A bit more complicated because 0.1 and 0.2 had a table
%% in the default installer, this module installs a different table.
init(Context) ->
    ok = z_db:transaction(fun install1/1, Context),
    z_depcache:flush(Context),
    ok.
    
install1(Context) ->
    ok = install_task_table(z_db:table_exists(task, Context), Context),
    ok.

install_task_table(true, _Context) ->
    ok;

install_task_table(false, Context) ->
    z_db:q("
        create table task (
            id serial not null,
            is_visible boolean not null default true,
            is_complete boolean not null default false,
            rsc_id int not null,
            user_id int,
	    hours float default 0,
            rank int default 1,
	    task_detail character varying(240) DEFAULT ''::character varying NOT NULL,
            completed_date timestamp with time zone,
            created timestamp with time zone not null default now(),
            
            constraint task_pkey primary key (id),
            constraint fk_task_rsc_id foreign key (rsc_id)
                references rsc(id)
                on delete cascade on update cascade,
            constraint fk_task_user_id foreign key (user_id)
                references rsc(id)
                on delete set null on update cascade
        )
    ", Context),
    Indices = [
        {"fki_task_rsc_id", "rsc_id"},
        {"fki_task_user_id", "user_id"},
        {"task_rsc_created_key", "rsc_id, created"},
        {"task_completed_date_key", "completed_date"},
        {"task_created_key", "created"}
    ],
    [ z_db:q("create index "++Name++" on task ("++Cols++")", Context) || {Name, Cols} <- Indices ],
    ok.

update_rank(L) ->
   update_rank(L,0,[]).

update_rank([],_,Final) ->
   Final;

update_rank([H|T],Starting, Final) ->
   Next = Starting + 1,
   Final2 = [{H,Next}|Final],
   update_rank(T,Next,Final2).

