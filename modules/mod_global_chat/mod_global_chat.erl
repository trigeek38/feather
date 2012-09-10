%% =========================================================================%%
%% @author Jeff Bell
%% @author Sanket Gawade
%% @copyright 2012 5Nines LLC
%% @date 09-05-2012
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

-module(mod_global_chat).
-author("Jeff Bell jeff@5nineshq.com").
-author("Sanket Gawade sanket@5nineshq.com").

-mod_title("Global Chat").
-mod_description("Global Chat with no Database Entries").
-mod_prio(600).

-include_lib("zotonic.hrl").

-export([
         event/2
        ]).

%% @doc Event to Handle the Chat Message.
event({submit, {new_message, Args}, _TriggerId, _TargetId}, Context) ->
    UserId = proplists:get_value(userid, Args),
    Message = z_context:get_q("chat_message", Context), 
    mod_signal:emit({insert_new_message, [{msg, Message}, {userid, UserId}]}, Context),
    z_render:wire([
                    {set_value, [{target, "chat_message"}, {value, ""}]},
                    {focus, [{target, "chat_message"}]}
                  ], Context).
