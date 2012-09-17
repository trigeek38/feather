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

-module(resource_communication).
-author("Jeff Bell jeff@5nineshq.com").
-author("Sanket Gawade sanket@5nineshq.com").

-export([
    html/1
]).

-include_lib("resource_html.hrl").

%% @doc Show the page.  Add a noindex header when requested by the editor.
html(Context) ->
	RenderArgs = [z_context:get_q_all(Context)],
        case z_context:get_q("From", Context) of       %% Get From and strip leading +1 encoded string off front 
            undefined -> RenderArgs1 = RenderArgs;
            From -> 
                From1 = string:sub_string(From, 3),
                RenderArgs1 = RenderArgs ++ [{from, From1}]
        end,
	RenderFunc = fun() ->
	       Template = z_context:get(template, Context, "sms.tpl"),
	       z_template:render(Template, RenderArgs1, Context)
	    end,
	Html = RenderFunc(),
	z_context:output(Html, Context).

