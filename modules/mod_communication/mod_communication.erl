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

-record(state, {context}).

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
    {ok, #state{context=z_context:new(Context)}}.

handle_call(stop, _From, State) ->
    {stop, normal, stopped, State}.

handle_cast({{create_call, Phone_List, Url}, _Context}, State) ->
    create_call(Phone_List, ?URL ++ Url),
    {noreply, State};

handle_cast({{send_sms, Phone_List, Message_List}, _Context}, State) ->
    send_sms(Phone_List, Message_List),
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

%% Create Calls
create_call([H|T], Url) ->
    From = "3525872956",
    Query = "From=+1"++From++"&To=+1"++H++"&Url="++Url++"&Method=GET",
    Msg = ?TwilPath++"/Calls/?",
    httpc:request(post, {Msg,[],"application/x-www-form-urlencoded",Query},[],[]),
    create_call(T, Url);

create_call([], _Url) ->
    ok.

%% Send SMS when we don't have to exclude owner
send_sms(Phone_List, [Message|Rest]) ->
    send_sms1(Phone_List, edoc_lib:escape_uri(binary_to_list(z_html:unescape(Message)))),
    send_sms(Phone_List, Rest);

send_sms(_Phone_List, []) ->
    ok.
    
send_sms1([H|T], Message) ->
    Msg = ?TwilPath++?SMSPath,
    Query = ?TwilNumber++H++?Body++Message,
    httpc:request(post, {Msg,[],"application/x-www-form-urlencoded",Query},[],[]),
    send_sms1(T, Message);

send_sms1([], _Message) ->
    ok.

%% Send Email
send_email([Email|T], Template, Vars, Context) -> 
    z_email:send_render(Email, Template, Vars, Context),
    send_email(T, Template, Vars, Context);

send_email([], _Template, _Vars, _Context) ->
    ok.

%%call_send_sms(Numbers, Message, UserId, Context) ->
%%    Url = "?action=create&token="++ ?Token ++ "&msg=" ++ Message ++ "&numberToDial=",
%%    Url = "?action=create&token="++ ?Token ++ "&eventId=" ++ Event ++ "&userId=" ++ User ++ "&msg=" ++ Msg ++ "&numberToDial=",
%%    send_sms(Numbers, Url, UserId, Context).
%%    send_twil_sms(Numbers, Message, UserId, Context).

%%send_sms([],_Url, _UserId, _Context) ->
%%    ok;

%%send_sms([H|T],Url, UserId, Context) ->
%%    case binary_to_list(m_rsc:p(UserId, phone, Context)) of
%%    H ->
%%        send_sms(T, Url, UserId, Context);
%%    _ ->
%%        Msg = edoc_lib:escape_uri(Url++H),
%%        httpc:request(?Path++Msg),
%%        send_sms(T, Url, UserId, Context)
%%    end.
