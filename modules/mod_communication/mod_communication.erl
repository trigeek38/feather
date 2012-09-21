%% =========================================================================%%
%% @author Jeff Bell
%% @author Sanket Gawade
%% @copyright 2011-2012 5Nines LLC
%% @date 09-11-2012
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

-module(mod_communication).
-author("Jeff Bell jeff@5nineshq.com").
-author("Sanket Gawade sanket@5nineshq.com").

-behaviour(gen_server).

-mod_title("Communication server").
-mod_author("5Nines LLC").
-mod_description("Implements the SMS, Call and Email Communication Features").
-mod_prio(100).

-export([start_link/0, start_link/1, stop/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("mod_communication.hrl").
-include_lib("zotonic.hrl").

-record(state, {context, twilioNumber, twilioURL}).

%%%================================================================
%%% API
%%%================================================================
start_link() -> 
    start_link([]).

start_link(Args) when is_list(Args) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, Args, []).

stop() ->
    gen_server:call(?MODULE, stop).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init(Args) ->
    process_flag(trap_exit, true),
    {context, Context} = proplists:lookup(context, Args),
    z_notifier:observe(send_sms,self(), Context), 
    z_notifier:observe(send_email,self(), Context), 
    z_notifier:observe(create_call,self(), Context), 
    ensure_started(crypto),
    ensure_started(public_key),
    ensure_started(ssl),
    ensure_started(inets),
    TwilioNumber = m_site:get(twilioNumber, Context),
    TwilioURL = m_site:get(twilioURL, Context),
    {ok, #state{context=z_context:new(Context), twilioNumber=TwilioNumber, twilioURL=TwilioURL}}.

handle_call(stop, _From, State) ->
    {stop, normal, stopped, State}.

handle_cast({{create_call, Phone_List, Message}, _Context}, State) ->
    TwilioNumber = State#state.twilioNumber,
    TwilioURL = State#state.twilioURL,
    create_call(Phone_List, TwilioNumber, TwilioURL ++ ?INVITE_URL ++ Message),
    {noreply, State};

handle_cast({{send_sms, Phone_List, Message_List}, _Context}, State) ->
    TwilioNumber = State#state.twilioNumber,
    send_sms(Phone_List, TwilioNumber, Message_List),
    {noreply, State};

handle_cast({{send_email, Email_List, Template, Vars}, Context}, State) ->
    send_email(Email_List, Template, Vars, Context),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%%======================================================================
%% Other Functions
%%%%======================================================================
ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.

%% Create Conference Call for the List of Phone Numbers
create_call([], _From, _Url) ->
    ok;

create_call([H|T], From, Url) ->
    Msg = ?TwilPath++?CallPath,
    Query = ?QFrom++From++?QTo++H++?QUrl++Url++?QMethod++"GET",
    httpc:request(post, {Msg,[],?TwilContentType,Query},[],[]),
    create_call(T, From, Url).

%% Send SMS to a List of Phone Numbers
send_sms(_Phone_List, _From, []) ->
    ok;

send_sms(Phone_List, From, [Message|Rest]) ->
    send_sms1(Phone_List, From, edoc_lib:escape_uri(binary_to_list(z_html:unescape(Message)))),
    send_sms(Phone_List, From, Rest).
    
send_sms1([], _From, _Message) ->
    ok;

send_sms1([H|T], From, Message) ->
    Msg = ?TwilPath++?SMSPath,
    Query = ?QFrom++From++?QTo++H++?QBody++Message,
    httpc:request(post, {Msg,[],?TwilContentType,Query},[],[]),
    send_sms1(T, From, Message).

%% @ Send Email using the zotonic z_email
send_email([], _Template, _Vars, _Context) ->
    ok;

send_email([Email|T], Template, Vars, Context) -> 
    z_email:send_render(Email, Template, Vars, Context),
    send_email(T, Template, Vars, Context).
