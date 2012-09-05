-module(m_node).
-author("Jeff Bell").

-behaviour(gen_model).

%% interface functions
-export([
         m_find_value/3,
         m_to_list/2,
         m_value/2,
         search/3
        ]).

-include_lib("zotonic.hrl").

-define(MAXAGE_NODE, 0).

m_find_value(all_senders, #m{value=undefined} = M, _Context) ->
    M#m{value=all_senders};
m_find_value(Id, #m{value=all_senders}, Context) ->
    list_all_senders(Id, Context);

m_find_value(attached, #m{value=undefined} = M, _Context) ->
    M#m{value=attached};
m_find_value(Id, #m{value=attached}, Context) ->
    list_all_attached(Id, Context);

m_find_value(_Key, #m{value=undefined}, _Context) ->
   undefined.

m_to_list(_, _Context) ->
    [].

m_value(#m{value=undefined}, _Context) ->
    undefined.

list_all_senders(Id, Context) ->
    F = z_db:q("select id from pivot_mod_node where sends_to = $1", [Id], Context),
    F.

list_all_attached(Id, Context) ->
    F = z_db:q("select id from pivot_mod_node where attached_to = $1", [Id], Context),
    F.

search({node_type_server,[{node_type, NodeType}]}, _OffsetLimit, Context) ->
    ServerId = m_rsc:name_to_id_check(NodeType, Context),
    #search_sql{
        select="n.id",
	from ="pivot_mod_node n join rsc r on n.id = r.id",
	where = "n.node_type_id = $1",
	order ="r.pivot_title asc",
	args = [ServerId],
	assoc=false
    };

search({node_count_by_type, []}, _OffsetLimit, _Context) ->
    #search_sql{
        select="count(*) as total, n.node_type_id, r.pivot_title",
	from ="pivot_mod_node n join rsc r on n.node_type_id = r.id group by n.node_type_id, r.pivot_title",
	order ="r.pivot_title asc",
	assoc=true
    };

search({node_count_by_sub_type, []}, _OffsetLimit, _Context) ->
    #search_sql{
        select="count(*) as total, n.node_type_id, n.node_sub_type_id, r.pivot_title",
	from ="pivot_mod_node n join rsc r on n.node_sub_type_id = r.id group by n.node_type_id, n.node_sub_type_id, r.pivot_title",
	order ="r.pivot_title asc",
	assoc=true
    };

search({node_status, [{status_id, Status}]}, _OfffsetLimit, _Context) ->
    #search_sql{
        select="n.*",
        from="pivot_mod_node n",
        where="status_id = $1",
        args=[Status],
        assoc=true
    };

search({search_nodes, Args}, _OfffsetLimit, _Context) ->
    Sort = proplists:get_value(sort, Args, "title"),
    Order = proplists:get_value(order, Args, "asc"),
    Args1 = proplists:delete(sort, Args),
    Args2 = proplists:delete(order, Args1),
    {WhereString, Arguments} = z_query:get_query_string(Args2),
    #search_sql{
        select="n.*, r.pivot_title as title, s.pivot_title as node_type, t.pivot_title as sub_type",
        from="pivot_mod_node n join rsc r on n.id = r.id join rsc s on n.node_type_id = s.id join rsc t on n.node_sub_type_id = t.id",
        where=WhereString,
        order = z_convert:to_list(Sort) ++ " " ++ z_convert:to_list(Order) ++ ", title asc",
        args=Arguments,
        assoc=true
    }.


