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

-module(z_communication).
-author("Jeff Bell jeff@5nineshq.com").
-author("Sanket Gawade sanket@5nineshq.com").

-export([
         create_call/3, 
         send_sms/3, 
         send_email/4
       ]).

-include_lib("zotonic.hrl").
-define(CONF_MESSAGE, "You have been invited to a conference call by five nines").

%% @doc To create a conference call for the List of Phone Numbers provided.
%% @spec create_call(List, String, Context) -> ok
create_call(Phone_List, [], Context) ->
    z_notifier:notify({create_call, Phone_List, create_query_message(?CONF_MESSAGE)}, Context);

create_call(Phone_List, Message, Context) ->
    z_notifier:notify({create_call, Phone_List, create_query_message(Message)}, Context).

%% @doc To send SMS to a list of Phone Numbers provided.
%% @spec sned_sms(List, String, Context) -> ok
send_sms(Phone_List, Message, Context) ->  
    Message_List = check_sms_size(Message),
    z_notifier:notify({send_sms, Phone_List, Message_List}, Context).

%% @doc to send a Email to the list of Email Addresses provided.
%% @spec send_email(List, Template, Proplists, Context) -> ok
send_email(Email_List, Template, Vars, Context) -> 
    z_notifier:notify({send_email, Email_List, Template, Vars}, Context).

%% @doc To divide the sms message into 160 chracters each if its too large.
%% @spec check_sms_size(String) -> List
check_sms_size(Message) ->
    case string:len(Message) =< 160 of
    true ->
        [Message];
    false ->
        divide_string(Message, [])
    end. 
    
divide_string([], List) ->
    List;

divide_string(Message, List) ->
    String = string:substr(Message, 1, 160),
    try string:substr(Message, 161) of
    NewMessage  ->
        divide_string(NewMessage, List ++ [String])
    catch
    _:_ ->
        divide_string([], List ++ [String])
    end.

%% @doc To replace space with %2B(+) in the message 
%% @spec create_query_message(List) -> List
create_query_message(Message) ->
    re:replace(string:strip(Message), " ", "%2B", [global, {return, list}]).
