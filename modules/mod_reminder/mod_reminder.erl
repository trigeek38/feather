%% =========================================================================%%
%% @author Jeff Bell
%% @author Sanket Gawade
%% @copyright 2012 5Nines LLC
%% @date 09-14-2012
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%% =========================================================================%%

-module(mod_reminder).
-author("Jeff Bell jeff@5nineshq.com").
-author("Sanket Gawade sanket@5nineshq.com").

-behaviour(gen_server).

-mod_title("Reminder Module").
-mod_author("5NinesLLC").
-mod_description("Gen Server to handle the Reminders").
-mod_prio(200).

-export([
          start_link/0, 
          start_link/1, 
          stop/0,
          set_reminder/5,
          call_reminder/3,
          reset_reminders/1,
          do_custom_pivot/2,
          observe_search_query/2
        ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include_lib("zotonic.hrl").

-record(state, {context}).

%%%================================================================
%%% API
%%%================================================================
start_link() ->
    start_link([]).

start_link(Args) when is_list(Args) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, Args, []).

reset_reminders(Context) ->
    gen_server:cast(?MODULE, {reset_reminders, Context}).

set_reminder(RemId, TimeOut, PhoneList, EmailList, Context) ->
    gen_server:cast(?MODULE, {set_reminder, RemId, TimeOut, PhoneList, EmailList, Context}).

call_reminder(RemId, PhoneList, EmailList) ->
    gen_server:cast(?MODULE, {call_reminder, RemId, PhoneList, EmailList}).

stop() ->
    gen_server:call(?MODULE, stop).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init(Args) ->
    process_flag(trap_exit, true),
    {context, Context} = proplists:lookup(context, Args),
    z_datamodel:manage(?MODULE, datamodel(), Context),
    z_pivot_rsc:define_custom_pivot(?MODULE, [
                                              {rscid, "int"}
                                             ], Context),

    z_notifier:observe(custom_pivot, {?MODULE, do_custom_pivot}, Context),
    z_reminder:config_server_time_zone(Context),
    timer:start(),
    timer:apply_after(2000, mod_reminder, reset_reminders, [Context]), 
    {ok, #state{context=z_context:new(Context)}}.

handle_call(stop, _From, State) ->
    {stop, normal, stopped, State}.

handle_cast({reset_reminders, Context}, State) ->
    server_restart(Context),
    {noreply, State};

handle_cast({set_reminder, RemId, TimeOut, PhoneList, EmailList, Context}, State) ->
    case timer:apply_after(TimeOut*1000, mod_reminder, call_reminder, [RemId, PhoneList, EmailList]) of
    {ok, TimerRef} ->
        m_rsc:update(RemId, [{tref, TimerRef}], Context);
    {error, _Reason} ->
        ok
    end,
    {noreply, State#state{context=Context}};

handle_cast({call_reminder, RemId, PhoneList, EmailList}, State) ->
    Context = State#state.context,
    z_reminder:send_notification(RemId, PhoneList, EmailList, Context),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% gen_server other functions
%%%===================================================================
%% @doc Custom Pivot Table update for Departments.
do_custom_pivot({custom_pivot, Id}, Context) ->
    case m_rsc:is_a(Id, Context) of
    [reminder] ->
        RscId = m_rsc:p(Id, rscid, Context),
        {?MODULE, [
                    {rscid, RscId}
                  ]
        };
    _ ->
            none
    end.

%% @doc Datamodel, installed intially when this module is started.
datamodel() ->
    [
      %% Categories
      {categories,
        [
          {reminder,
           undefined,
           [{title, <<"Reminder">>}]}
        ]
      }
    ].

observe_search_query({search_query, {search_reminders, Args}, OffsetLimit}, Context) ->
    z_reminder:search({search_reminders, Args}, OffsetLimit, Context);
observe_search_query(_, _Context) ->
    undefined.

%%Reset all the reminders when ther server is restarted.
server_restart(Context) ->
     RemId_list = element(2, element(4, m_search:search({latest,[{cat, ["reminder"]}]}, Context))),
     reset_reminders(RemId_list, Context).

reset_reminders([], _Context) ->
    ok;

reset_reminders([RemId|T], Context) ->
    DateTime = m_rsc:p(RemId, date_end, Context),
    TRef = m_rsc:p(RemId, tref, Context),
    timer:cancel(TRef),
    {D,{H,M,S}} = calendar:time_difference({erlang:date(), erlang:time()}, DateTime),
    TimeOut = ((D*24*60*60) + ((H-1)*60*60) + (M*60) + S),
    if
    TimeOut > 0 ->
       mod_reminder:set_reminder(RemId, TimeOut, Context);
    true ->
        ok
    end,
    reset_reminders(T, Context).
