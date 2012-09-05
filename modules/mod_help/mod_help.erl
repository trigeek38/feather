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

-module(mod_help).
-author("Jeff Bell jeff@5nineshq.com").
-author("Sanket Gawade sanket@5nineshq.com").

-mod_title("Simple FAQ Help Module").
-mod_description("Manage the FAQs and Howto").
-mod_prio(550).

-include_lib("zotonic.hrl").

-export([
         init/1,
         do_custom_pivot/2, 
         observe_search_query/2, 
         search/3,
         event/2
        ]).

init(Context) ->
    z_datamodel:manage(?MODULE, datamodel(), Context),

    z_pivot_rsc:define_custom_pivot(mod_faq, [
                                              {faq_rank, "int"}
                                             ], Context),

    z_pivot_rsc:define_custom_pivot(mod_howto, [
                                              {howto_rank, "int"}
                                             ], Context),

    z_notifier:observe(custom_pivot, {?MODULE, do_custom_pivot}, Context).

do_custom_pivot({custom_pivot, Id}, Context) ->
    case m_rsc:is_a(Id, Context) of
        [faq] ->
            Rank = m_rsc:p(Id, faq_rank, Context),
            {mod_faq, [
                       {faq_rank, Rank}
                      ]
            };
        [howto] ->
            Rank = m_rsc:p(Id, howto_rank, Context),
            {mod_howto, [
                       {howto_rank, Rank}
                      ]
            };
        _ -> 
            none
    end.

observe_search_query({search_query, {search_faq, Args}, OffsetLimit}, Context) ->
    search({search_faq, Args}, OffsetLimit, Context);
observe_search_query({search_query, {search_howto, Args}, OffsetLimit}, Context) ->
    search({search_howto, Args}, OffsetLimit, Context);
observe_search_query(_, _Context) ->
    undefined.

event({submit, {add_faq, _Args}, _TriggerId, _TargetId}, Context) ->
    CatId = m_rsc:name_to_id_check("faq", Context),
    Props = proc_form(Context),
    Props1 = [
              {category_id, CatId},
              {is_published, true}|
              Props],
    case m_rsc:insert(Props1, Context) of
        {ok, Id} ->
            FAQs = z_db:assoc_props("select id from pivot_mod_faq order by faq_rank", [], Context),
            List = [Id] ++ [proplists:get_value(id, X) || X <- FAQs],  
            update_ranks(faq_rank, List, Context),
            z_render:wire({redirect, [{dispatch, faq}]},Context);
        {error, Reason}  ->
            z_render:growl_error("Error !" ++ z_convert:to_list(Reason), Context)
    end;

event({submit, {edit_faq, Args}, _TriggerId, _TargetId}, Context) ->
    Id = proplists:get_value(id, Args),
    Props = proc_form(Context),
    case m_rsc:update(Id, Props, Context) of
        {ok, Id} ->
            z_render:wire({redirect, [{dispatch, faq}]},Context);
        {error, Reason}  ->
            z_render:growl_error("Error !" ++ z_convert:to_list(Reason), Context)
    end;

event({postback, {delete_faq, Args}, _TriggerId, _TargetId}, Context) ->
    Id = proplists:get_value(id, Args),
    case m_rsc:delete(Id, Context) of
        ok ->
            z_render:wire({redirect, [{dispatch, faq}]},Context);
        {error, Reason}  ->
            z_render:growl_error("Error !" ++ z_convert:to_list(Reason), Context)
    end;

event({submit, {add_howto, _Args}, _TriggerId, _TargetId}, Context) ->
    CatId = m_rsc:name_to_id_check("howto", Context),
    Props = proc_form(Context),
    Props1 = [
              {category_id, CatId},
              {is_published, true}|
              Props],
    case m_rsc:insert(Props1, Context) of
        {ok, Id} ->
            HowTo = z_db:assoc_props("select id from pivot_mod_howto order by howto_rank", [], Context),
            List = [Id] ++ [proplists:get_value(id, X) || X <- HowTo],
            update_ranks(howto_rank, List, Context),
            z_render:wire({redirect, [{location, "/howto/" ++ z_convert:to_list(Id) ++ "/" ++ z_convert:to_list(m_rsc:p(Id, slug, Context))}]},Context);
        {error, Reason}  ->
            z_render:growl_error("Error !" ++ z_convert:to_list(Reason), Context)
    end;

event({submit, {edit_howto, Args}, _TriggerId, _TargetId}, Context) ->
    Id = proplists:get_value(id, Args),
    Props = proc_form(Context),
    case m_rsc:update(Id, Props, Context) of
        {ok, Id} ->
            z_render:wire({redirect, [{location, "/howto/" ++ z_convert:to_list(Id) ++ "/" ++ z_convert:to_list(m_rsc:p(Id, slug, Context))}]},Context);
        {error, Reason}  ->
            z_render:growl_error("Error !" ++ z_convert:to_list(Reason), Context)
    end;

event({postback, {delete_howto, Args}, _TriggerId, _TargetId}, Context) ->
    Id = proplists:get_value(id, Args),
    case m_rsc:delete(Id, Context) of
        ok ->
            z_render:wire({redirect, [{dispatch, howto}]},Context);
        {error, Reason}  ->
            z_render:growl_error("Error !" ++ z_convert:to_list(Reason), Context)
    end;

event({sort, SortList, {dragdrop, Tag, mod_help, _TargetId}}, Context) ->
    SortList1 = [element(2,X) || X <- SortList],
    case update_ranks(z_convert:to_atom(Tag ++ "_rank"), SortList1, Context) of
        ok ->
            z_render:wire({redirect, [{dispatch, z_convert:to_atom(Tag)}]},Context);
        {error, Reason} ->
            z_render:growl_error("Error !" ++ z_convert:to_list(Reason), Context)
    end.

proc_form(Context) ->
    Title = z_context:get_q("title", Context),
    Body = z_context:get_q("html_body", Context),
    [
      {title, Title},
      {body, Body}
    ].

update_ranks(Field, SortList, Context) ->
    update_ranks(Field, SortList, 1, ok, Context).

update_ranks(_Field, [], _Rank, Result, _Context) ->
    Result;

update_ranks(Field, [H|T], Rank, Result, Context) ->
    case m_rsc:update(H, [{Field, Rank}], Context) of
    {ok, RscId} ->
        z_pivot_rsc:pivot_resource(RscId, Context), 
        update_ranks(Field, T, Rank+1, Result, Context);
    {error, Reason} ->
        update_ranks(Field, [], Rank, {error, Reason}, Context)
    end.

search({search_faq, _Args}, _OfffsetLimit, _Context) ->
    #search_sql{
        select="n.*",
        from="pivot_mod_faq n",
        order = "n.faq_rank asc",
        assoc=true
    };

search({search_howto, _Args}, _OfffsetLimit, _Context) ->
    #search_sql{
        select="n.*",
        from="pivot_mod_howto n",
        order = "n.howto_rank asc",
        assoc=true
    }.

datamodel() ->
    [
      %% Categories
      {categories,
        [
          {faq,
           undefined,
           [{title, <<"Lookup Values">>}]},
          {howto,
           undefined,
           [{title, <<"How To">>}]}
        ]}
    ].

