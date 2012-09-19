%% =========================================================================%%
%% @author Jeff Bell
%% @author Sanket Gawade
%% @copyright 2011-2012 5Nines LLC
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

-module(resource_reminder).
-author("Jeff Bell jeff@5nineshq.com").
-author("Sanket Gawade sanket@5nineshq.com").

-export([
          event/2
        ]).

-include_lib("zotonic.hrl").

%% @doc Event to Set Reminders
event({submit, {set_reminder, Args}, _TriggerId, _TargetId}, Context) ->
    %% Enter PhoneList and EmailList Logic here.
    PhoneList = ["3522192940"],
    EmailList = ["sanketgawade7@gmail.com"],
    case z_reminder:set_reminder(PhoneList, EmailList, Args, Context) of
    {ok, RemId} -> 
        z_pivot_rsc:pivot_resource(RemId, Context),
        z_render:wire({reload, []}, Context);
    {error, Reason} ->
        z_render:wire({growl, [{text, "Error" ++ Reason}, {stay, true}, {type, error}]}, Context)
    end;

%% @doc Event to Edit Reminders
event({submit, {edit_reminder, Args}, _TriggerId, _TargetId}, Context) ->
    %% Enter PhoneList and EmailList Logic here.
    PhoneList = ["3522192940"],
    EmailList = ["sanketgawade7@gmail.com"],
    case z_reminder:edit_reminder(PhoneList, EmailList, Args, Context) of
    {ok, _RemId} -> 
        z_render:wire({reload, []}, Context);
    {error, Reason} ->
        z_render:wire({growl, [{text, "Error" ++ Reason}, {stay, true}, {type, error}]}, Context)
    end;

%% @doc Event to Delete Reminders
event({postback, {delete_reminder, Args}, _TriggerId, _TargetId}, Context) ->
    RemId = proplists:get_value(remid, Args),
    case z_reminder:delete_reminder(RemId, Context) of
    ok ->
        z_render:wire({reload, []}, Context);
    {error, Reason} ->
        z_render:wire({growl, [{text, "Error" ++ Reason}, {stay, true}, {type, error}]}, Context)
    end.
