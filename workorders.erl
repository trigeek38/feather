%% @author Jeff
%% @copyright 2012 Jeff
%% Generated on 2012-08-08
%% @doc This site is awsome.

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

-module(workorders).
-author("Jeff Bell jeff@5nineshq.com").
-author("Sanket Gawade sanket@5nineshq.com").

-mod_title("workorders zotonic site").
-mod_description("An empty Zotonic site, to base your site on.").
-mod_prio(10).

-export([event/2]).

%%====================================================================
%% support functions go here
%%====================================================================

event({submit, {update_profile, [{id, User}]}, _Trig, _Targ}, Context) ->
    Props = proc_form(Context),
        case m_rsc:update(User, Props, Context) of
           {ok, UserId} ->
               z_pivot_rsc:pivot_resource(UserId, Context),
               z_render:growl("Saved Profile!", Context);
               %% z_render:wire({redirect, [{dispatch, "profile_detail"}]}, Context);
           {error, Reason}  ->
               z_render:growl_error("Error !" ++ atom_to_list(Reason), Context)
        end.

proc_form(Context) ->
   [Num, Zone] = string:tokens(z_context:get_q(time_zone, Context), ","),
   Email = z_context:get_q(email, Context),
   Phone = z_context:get_q(phone, Context),
   CalendarView = z_context:get_q(calendar_view, Context),
   OpenWo = z_context:get_q(open_wo, Context), 
   ClosedWo = z_context:get_q(closed_wo, Context), 
   OpenProject = z_context:get_q(open_project, Context), 
   OpenPM = z_context:get_q(open_pm, Context), 
   [
       {email, Email},
       {phone, Phone},
       {calendar_view, CalendarView},
       {open_wo, OpenWo},
       {closed_wo, ClosedWo},
       {open_project, OpenProject},
       {open_pm, OpenPM},
       {time_zone, {Num, Zone}}
   ].
