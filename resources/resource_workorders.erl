-module(resource_workorders).
-author("Jeff Bell <jeff.5nines@gmail.com>").

-export([
    is_authorized/2
]).

-include_lib("resource_html.hrl").

is_authorized(ReqData, Context) ->
    z_acl:wm_is_authorized(use, workorders, ReqData, Context).


html(Context) ->
    Template = z_context:get(template, Context, "home.tpl"),
    Html = z_template:render(Template, [], Context),
    z_context:output(Html, Context).

