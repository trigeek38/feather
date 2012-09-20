%% =========================================================================%%
%% @author Jeff Bell
%% @author Sanket Gawade
%% @copyright 2012 5Nines LLC
%% @date 05-29-2012
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

-module(mod_pdf).
-author("Jeff Bell jeff@5nineshq.com").
-author("Sanket Gawade sanket@5nineshq.com").

-mod_title("PDF Conversion Module").
-mod_description("Convert a html template to pdf format.").
-mod_prio(550).

-define(TmpHTML, "/lib/bin/").
-define(TmpPDF, "/lib/downloads/").
-define(PDFConvert, "/lib/bin/wkhtmltopdf").

-include_lib("zotonic.hrl").

-export([
         event/2, make_pdf/2
        ]).

%% @doc Event to Convert the Template to Pdf using wkhtmltopdf.
event({postback, {convert_to_pdf, Args}, _TriggerId, _TargetId}, Context) ->
    PDFfilename = make_pdf(Args, Context),
    z_render:wire({update, [{target, "make-link"}, {template, "_make_link.tpl"}, {link, PDFfilename}]}, Context).

%% @doc Creates a PDF file in /lib/downloads Directory and returns the name of that file.
%% @doc This function is exported so it can be called from outside to include form submitted Arguments.
%% @spec make_pdf(Proplists, Context) -> PDFfilename
make_pdf(Args, Context) ->
    Template = proplists:get_value(template, Args, "_pdf_default.tpl"),
    Html = z_template:render(Template, Args, Context),
    create_pdf(Html, Args, Context).

%% @doc Creates a PDF file in /lib/downloads Directory and returns the name of that file.
%% @spec create_pdf(Proplists, Context) -> PDFfilename
create_pdf(Html, Args, Context) ->
    SiteDir = z_path:site_dir(Context),
    check_download_dir(SiteDir),
    Orientation = proplists:get_value(orientation, Args, "Portrait"),
    TmpHtml = SiteDir ++ ?TmpHTML ++ get_datetime() ++ ".html",
    PDFfilename = get_datetime() ++ ".pdf",
    TmpPdf = SiteDir ++ ?TmpPDF ++ PDFfilename,
    file:write_file(TmpHtml, Html),
    Cmd = SiteDir ++ ?PDFConvert ++ " -O " ++ Orientation ++ " " ++ TmpHtml ++ " " ++ TmpPdf,
    os:cmd(Cmd),
    z_module_indexer:reindex(Context),
    file:delete(TmpHtml),
    PDFfilename.

%% @doc To get DateTime stamp
%% @spec get_datetime() -> String
get_datetime() ->
    lists:concat(tuple_to_list(date())) ++ "-" ++ lists:concat(tuple_to_list(time())).

%% @doc To create the /lib/downloads directory if its not present.
%% @spec check_download_dir(SiteDirPath) -> ok
check_download_dir(SiteDir) ->
    case file:list_dir(SiteDir ++ "/lib/downloads") of
    {error,enoent} ->
        file:make_dir(SiteDir ++ "/lib/downloads");
    _ ->
        ok
    end.
