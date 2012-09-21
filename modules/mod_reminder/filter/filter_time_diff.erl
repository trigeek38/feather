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

-module(filter_time_diff).
-author("Jeff Bell jeff@5nineshq.com").
-author("Sanket Gawade sanket@5nineshq.com").

-export([time_diff/3]).

time_diff(undefined, _,  _Context) ->
    undefined;

time_diff({Date, Time}, undefined,  _Context) ->
    {Date, Time};

time_diff({Date, Time}, Diff, _Context) when is_integer(Diff) ->
    corrected_date_time({Date, Time}, Diff);

time_diff({Date, Time}, Diff, _Context) ->
    corrected_date_time({Date, Time}, list_to_integer(Diff)).

%% @doc To estimate the time according to the Time Zone Difference.
%% @spec corrected_date_time(DateTime::Tuple, TimeZoneDiff::int) -> DateTime::Tuple
corrected_date_time({{Y, M, D}, {H, Min, S}}, Diff) ->
    NewHrs = H + Diff,
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
