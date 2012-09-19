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

-module(z_reminder).
-author("Jeff Bell jeff@5nineshq.com").
-author("Sanket Gawade sanket@5nineshq.com").

-export([
          set_reminder/4,
          edit_reminder/4,
          delete_reminder/2,
          send_notification/4,
          config_server_time_zone/1,
          search/3
       ]).

-include_lib("zotonic.hrl").

%% @doc To set a New Reminder.
%% @spec set_reminder(List, List, Proplists, Context) -> {ok, RemId} | {error, Reason}
set_reminder(PhoneList, EmailList, Args, Context) ->
    case check_timeout(Args, Context) of
    {TimeOut, DateTime} ->
        Id = proplists:get_value(id, Args),
        CatId = m_rsc:name_to_id_check("reminder", Context),
        Props = proc_form(DateTime, Context),
        Props1 = [
                   {category_id, CatId},
                   {is_published, true},
                   {rscid, z_convert:to_integer(Id)}|
                   Props
                 ],
        case m_rsc:insert(Props1, Context) of
        {ok, RemId} -> 
            mod_reminder:set_reminder(RemId, TimeOut, PhoneList, EmailList, Context),
            {ok, RemId};
        {error, Reason} ->
            {error, Reason} 
        end;
    error ->
        {error, "Time has expired. Please enter time in military format"}
    end.

%% @doc To edit a current Reminder.
%% @spec edit_reminder(List, List, Proplists, Context) -> {ok, RemId} | {error, Reason}
edit_reminder(PhoneList, EmailList, Args, Context) ->
    case check_timeout(Args, Context) of
    {TimeOut, DateTime} ->
        RemId = proplists:get_value(remid, Args),
        Props = proc_form(DateTime, Context),
        case m_rsc:update(RemId, Props, Context) of
        {ok, RemId} ->
            OldTRef = m_rsc:p(RemId, tref, Context),
            timer:cancel(OldTRef),
            mod_reminder:set_reminder(RemId, TimeOut, PhoneList, EmailList, Context),
            {ok, RemId};
        {error, Reason} ->
            {error, Reason} 
        end;
    error ->
        {error, "Time has expired. Please enter time in military format"}
    end.

%% @doc To delete a Reminder.
%% @spec delete_reminder(Id, Context) -> ok | {error, Reason}
delete_reminder(RemId, Context) ->
    TRef = m_rsc:p(RemId, tref, Context),
    case m_rsc:delete(RemId, Context) of
    ok ->
        timer:cancel(TRef),
        ok;
    {error, Reason} ->
        {error, Reason} 
    end.

send_notification(RemId, PhoneList, EmailList, Context) ->
    Id = m_rsc:p(RemId, rscid, Context),
    Vars = [{id, Id}, {remid, RemId}],
    case z_module_manager:active(mod_communication, Context) of
    true ->
        RscTitle = z_convert:to_list(m_rsc:p(Id, title, Context)),
        Message = RscTitle ++ " Reminder: " ++ z_convert:to_list(m_rsc:p(RemId, title, Context)) ++ " - " ++ z_convert:to_list(m_rsc:p(RemId, summary, Context)),
        z_communication:send_sms(PhoneList, Message, Context),
        z_communication:send_email(EmailList, "_reminder_email.tpl", Vars, Context);
    false ->
        send_email(EmailList, "_reminder_email.tpl", Vars, Context)
    end.

config_server_time_zone(Context) ->
    case m_site:get(server_time_zone, Context) of
    undefined ->
        ok;
    "EST" ->
        make_time_zone_template(0, Context);
    "CST" ->
        make_time_zone_template(1, Context);
    "MST" ->
        make_time_zone_template(2, Context);
    "PST" ->
        make_time_zone_template(3, Context);
    _ ->
        ok
    end.

%% @doc To to process Reminder Form.
%% @spec proc_form(DateTime, Context) -> Proplists
proc_form({{Year,Month,Day}, {Hour,Min, _Sec}}, Context) ->
    Date = integer_to_list(Year) ++ "-" ++ integer_to_list(Month) ++ "-" ++ integer_to_list(Day),
    Time = integer_to_list(Hour) ++ ":" ++ integer_to_list(Min),
    Title = z_context:get_q("reminder_title", Context),
    Message = z_context:get_q("reminder_message", Context),
    [
      {title, Title},
      {summary, Message},
      {"dt:hi:1:date_end", Time},
      {"dt:ymd:1:date_end", Date}
    ].

%% @doc To check if the date and time provided is in future and not in past.
%% @spec check_timeout(Proplists, Context) -> {Integer, DateTime} | error 
check_timeout(Args, Context) ->
    Diff = get_diff(Args),
    [Year, Month, Day] = string:tokens(z_context:get_q("dt:ymd:1:date", Context), "-"),
    [Hours, Minutes] = string:tokens(z_context:get_q("dt:hi:1:date", Context), ":"),
    DateTime = corrected_date_time({{list_to_integer(Year), list_to_integer(Month),list_to_integer(Day)},
                                                         {list_to_integer(Hours),list_to_integer(Minutes), 00}}, Diff),
    {D,{H,M,S}} = calendar:time_difference({erlang:date(), erlang:time()}, DateTime),
    TimeOut = ((D*24*60*60) + (H*60*60) + (M*60) + S),
    case TimeOut > 0 of
    true ->
        {TimeOut, DateTime};
    _ ->
        error
    end.

%% @doc To estimate the time according to the Time Zone Difference.
%% @spec corrected_date_time(DateTime, TimeZoneDiff) -> DateTime
corrected_date_time({{Y, M, D}, {H, Min, S}}, Diff) ->
    NewHrs = H - Diff,
    case  NewHrs >= 0 andalso NewHrs < 24 of
    true ->
        {{Y, M, D}, {NewHrs, Min, S}};
    false ->
        case NewHrs < 0 of
        true ->
            case (D - 1) > 0 of
            true ->
                {{Y, M, (D - 1)}, {(24 + NewHrs), Min, S}};
            false ->
                case (M - 1) > 0 of
                true ->
                    {{Y, (M - 1), calendar:last_day_of_the_month(Y, (M - 1))}, {(24 + NewHrs), Min, S}};
                false ->
                    {{(Y - 1), 12, 31}, {(24 + NewHrs), Min, S}}
                end
            end;
        false ->
            case (D + 1) =< calendar:last_day_of_the_month(Y, M) of
            true ->
                {{Y, M, (D + 1)}, {(NewHrs - 24), Min, S}};
            false ->
                case (M + 1) =< 12 of
                true ->
                    {{Y, (M + 1), 01}, {(NewHrs - 24), Min, S}};
                false ->
                    {{(Y + 1), 01, 01}, {(NewHrs - 24), Min, S}}
                end
            end
        end
    end.

%% @doc To fet the TimeZoneDiff Value form Args
%% @spec get_diff(Proplists) -> 0 | Integer
get_diff(Args) ->
    case proplists:get_value(diff, Args) of
    undefined ->
        0;
    Value when is_list(Value) ->
        list_to_integer(Value);
    Value when is_integer(Value) ->
        Value;
    _ ->
        0
    end.

search({search_reminders, Args}, _OfffsetLimit, _Context) ->
    WhereString = get_query_string(Args),
    #search_sql{
        select="n.*",
        from="pivot_mod_reminder n join rsc r on n.id = r.id",
        where=WhereString,
        order="r.pivot_title",
        assoc=true
    }.

%% @doc To get the where string for the Database query depending on the arguments passed to search
%% @spec get_query_string(PropsList) -> String
get_query_string(Args) ->
    get_query_string(Args, "").

get_query_string([], WhereString) ->
    WhereString;

get_query_string([{Key, Value}|T], WhereString) ->
    W = WhereString ++ z_convert:to_list(Key) ++ "=" ++ z_convert:to_list(Value),
    case T of
        [] ->
            WhereString1 = W;
        _ ->
            WhereString1 = W ++ " and "
        end,
    get_query_string(T, WhereString1).

make_time_zone_template(N, Context) ->
    EST = z_convert:to_list(0 + N),
    CST = z_convert:to_list(-1 + N),
    MST = z_convert:to_list(-2 + N),
    PST = z_convert:to_list(-3 + N),
    Template = "<div class=\"control-group\"> 
      <label class=\"control-label\" for=\"time_zone\">{_ Time Zone _}</label> 
        <div class=\"controls\"> 
        <select name=\"time_zone\"> 
          <option value=\"" ++ EST ++ ",Eastern Standard Time\"> Eastern Standard Time(EST) </option> 
          <option value=\"" ++ CST ++ ",Central Standard Time\" {% ifequal \"" ++ CST ++ "\" m.acl.user.time_zone|element:1 %} selected {% endifequal %}> Central Standard Time(CST) </option> 
          <option value=\"" ++ MST ++ ",Mountain Standard Time\" {% ifequal \"" ++ MST ++ "\" m.acl.user.time_zone|element:1 %} selected {% endifequal %}> Mountain Standard Time(MST) </option> 
          <option value=\"" ++ PST ++ ",Pacific Standard Time\" {% ifequal \"" ++ PST ++ "\" m.acl.user.time_zone|element:1 %} selected {% endifequal %}> Pacific Standard Time(PST) </option> 
        </select> 
        <p class=\"help-block\">Select your Time Zone. Defaults to EST</p> 
      </div> 
    </div>",
    file:write_file(z_path:site_dir(Context) ++ "/modules/mod_reminder/templates/_time_zone_select.tpl", Template).

%% Send Email
send_email([], _Template, _Vars, _Context) ->
    ok;

send_email([Email|T], Template, Vars, Context) ->
    z_email:send_render(Email, Template, Vars, Context),
    send_email(T, Template, Vars, Context).
