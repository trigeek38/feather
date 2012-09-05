-module(mod_node).
-author("5Nines LLC").

-mod_title("Nodes Model Interface").
-mod_description("Create pivot for nodes.").
-mod_prio(500).


-include_lib("zotonic.hrl").


-export([init/1, do_custom_pivot/2, observe_search_query/2, event/2]).


init(Context) ->
    z_pivot_rsc:define_custom_pivot(?MODULE, [
                                              {department_id, "int"},
                                              {node_type_id, "int"},
                                              {node_sub_type_id, "int"},
                                              {model, "character varying(30)"},
                                              {serial, "character varying(30)"},
                                              {manufacturer_id, "int"},
                                              {node_status_id, "int"},
                                              {attached_to, "int"},
                                              {sends_to, "int"},
                                              {oct1, "int"},
                                              {oct2, "int"},
                                              {oct3, "int"},
                                              {oct4, "int"},
					      {warranty, "timestamp with time zone"}
                                             ], Context),

    z_notifier:observe(custom_pivot, {?MODULE, do_custom_pivot}, Context).


do_custom_pivot({custom_pivot, Id}, Context) ->
   case m_rsc:is_a(Id, Context) of
       [node] ->
           Department = m_rsc:p(Id, department_id, Context),
           NodeTypeId = m_rsc:p(Id, node_type_id, Context),
           NodeSubTypeId = m_rsc:p(Id, node_sub_type_id, Context),
           Model = m_rsc:p(Id, model, Context),
           Serial = m_rsc:p(Id, serial, Context),
           Manufacturer = m_rsc:p(Id, manufacturer_id, Context),
           AttachedTo = m_rsc:p(Id, attached_to, Context),
           SendsTo = m_rsc:p(Id, sends_to, Context),
           Oct1 = m_rsc:p(Id, oct1, Context),
           Oct2 = m_rsc:p(Id, oct2, Context),
           Oct3 = m_rsc:p(Id, oct3, Context),
           Oct4 = m_rsc:p(Id, oct4, Context),
           Status = m_rsc:p(Id, node_status_id, Context),
           Warranty = m_rsc:p(Id, warranty, Context),
           {?MODULE, [
                {department_id, Department},
                {node_type_id, NodeTypeId},
                {node_sub_type_id, NodeSubTypeId},
                {model, Model},
                {serial, Serial},
                {manufacturer_id, Manufacturer},
                {attached_to, AttachedTo},
                {sends_to, SendsTo},
                {oct1, Oct1},
                {oct2, Oct2},
                {oct3, Oct3},
                {oct4, Oct4},
                {node_status_id, Status},
                {warranty, Warranty}
           ]};
    _ -> none
    end.

event({submit, {add_node, []}, _TriggerId, _TargetId}, Context) ->
        Props1 = proc_form(Context),
	case check_name(proplists:get_value(title, Props1), Context) of
	  {error, duplicate} ->
	      z_render:growl_error("Error ! duplicate name", Context);
	  {ok, _Name} ->
              case m_rsc:insert(Props1, Context) of
              {ok, NodeId} ->
                  z_pivot_rsc:pivot_resource(NodeId, Context),
                  z_render:wire({redirect, [{dispatch, "node_detail"}, {id, NodeId}]}, Context);
              {error, Reason}  ->
                  z_render:growl_error("Error !" ++ atom_to_list(Reason), Context)
              end
	end;

event({submit, {quick_add_class, []}, _TriggerId, _TargetId}, Context) ->
        Name = z_context:get_q("class_name", Context),
        Cat = m_rsc:name_to_id_check(node_type, Context),
	Props = [{title, Name}, {category_id, Cat}],
	case check_name(proplists:get_value(title, Props), Context) of
	  {error, duplicate} ->
	      z_render:growl_error("Error ! duplicate name", Context);
	  {ok, _Name} ->
              case m_rsc:insert(Props, Context) of
              {ok, MfgId} ->
                  z_render:growl("Added", Context);
              {error, Reason}  ->
                  z_render:growl_error("Error !" ++ atom_to_list(Reason), Context)
              end
	end;

event({submit, {quick_add_mfg, []}, _TriggerId, _TargetId}, Context) ->
        Name = z_context:get_q("mfg_name", Context),
        Cat = m_rsc:name_to_id_check(manufacturer, Context),
	Props = [{title, Name}, {category_id, Cat}],
	case check_name(proplists:get_value(title, Props), Context) of
	  {error, duplicate} ->
	      z_render:growl_error("Error ! duplicate name", Context);
	  {ok, _Name} ->
              case m_rsc:insert(Props, Context) of
              {ok, MfgId} ->
                  z_render:growl("Added", Context);
              {error, Reason}  ->
                  z_render:growl_error("Error !" ++ atom_to_list(Reason), Context)
              end
	end;

event({submit, {quick_add_node, []}, _TriggerId, _TargetId}, Context) ->
        Props = proc_quick_form(Context),
	case check_name(proplists:get_value(title, Props), Context) of
	  {error, duplicate} ->
	      z_render:growl_error("Error ! duplicate name", Context);
	  {ok, _Name} ->
              case m_rsc:insert(Props, Context) of
              {ok, NodeId} ->
                  z_pivot_rsc:pivot_resource(NodeId, Context),
                  z_render:wire({redirect, [{dispatch, "node_detail"}, {id, NodeId}]}, Context);
              {error, Reason}  ->
                  z_render:growl_error("Error !" ++ atom_to_list(Reason), Context)
              end
	end;

event({submit, {edit_node_network, [{id, Node}]}, _Trig, _Targ}, Context) ->
        Props = proc_network_form(Context),
	case check_ip(Node, 
	           [
		    proplists:get_value(oct1, Props), 
	            proplists:get_value(oct2, Props), 
	            proplists:get_value(oct3, Props), 
	            proplists:get_value(oct4, Props) 
		   ], Context) of
	    {error, duplicate} ->
	        z_render:growl_error("Error ! duplicate ip", Context);
            {ok, _Name} ->
                case m_rsc:update(Node, Props, Context) of
                    {ok, NodeId} ->
                         z_pivot_rsc:pivot_resource(NodeId, Context),
                         z_render:wire({redirect, [{dispatch, "node_detail"}, {id, NodeId}]}, Context);
                    {error, Reason}  ->
                         z_render:growl_error("Error !" ++ atom_to_list(Reason), Context)
                end
	end;

event({submit, {attach_node, [{id, Node}]}, _Trig, _Targ}, Context) ->
        AttachedTo = z_context:get_q("attached_to", Context),
	case m_rsc:update(Node, [{attached_to, z_convert:to_integer(AttachedTo)}], Context) of
            {ok, Node} ->
	        z_pivot_rsc:pivot_resource(Node, Context),
		z_render:wire({reload,[]},Context);
	    {error, Reason} ->
	        z_render:growl_error("Error !" ++ atom_to_list(Reason), Context)
        end;



event({submit, {edit_node, [{id, Node}]}, _Trig, _Targ}, Context) ->
        Props = proc_form(Context),
	case check_name(Node, proplists:get_value(title, Props), Context) of
	    {error, duplicate} ->
	        z_render:growl_error("Error ! duplicate name", Context);
            {ok, _Name} ->
                case m_rsc:update(Node, Props, Context) of
                    {ok, NodeId} ->
                         z_pivot_rsc:pivot_resource(NodeId, Context),
                         z_render:wire({redirect, [{dispatch, "node_detail"}, {id, NodeId}]}, Context);
                    {error, Reason}  ->
                         z_render:growl_error("Error !" ++ atom_to_list(Reason), Context)
                end
	end.
        

proc_form(Context) ->
        Title   = z_context:get_q("title", Context),
        Description   = z_context:get_q("summary", Context),
        Department = z_context:get_q("department_id", Context),
        Model = z_context:get_q("model", Context),
        Serial = z_context:get_q("serial", Context),
        Room = z_context:get_q("room", Context),
        Type = z_context:get_q("node_type_id", Context),
        SubType = z_context:get_q("node_sub_type_id", Context),
        Mfg = z_context:get_q("manufacturer_id", Context),
        Status = z_context:get_q("node_status_id", Context),
        Warranty = fn_date:get_date_time_tuple(z_context:get_q("warranty", Context)),
        CatId = m_rsc:name_to_id_check("node", Context),
        Props = [
            {category_id, CatId},
            {title, Title},
            {summary, Description},
            {department_id, list_to_integer(Department)},
            {model, Model},
            {serial, Serial},
            {room, Room},
            {node_type_id, list_to_integer(Type)},
            {node_sub_type_id, list_to_integer(SubType)},
            {manufacturer_id, list_to_integer(Mfg)},
            {node_status_id, list_to_integer(Status)},
            {warranty, Warranty},
            {is_published, true}
        ],
        Props.

proc_quick_form(Context) ->
        Title   = z_context:get_q_validated("title", Context),
        Description   = z_context:get_q_validated("summary", Context),
        Model = z_context:get_q("model", Context),
        Serial = z_context:get_q("serial", Context),
        Room = z_context:get_q("room", Context),
        Type = z_context:get_q_validated("node_type_id", Context),
        SubType = z_context:get_q("node_sub_type_id", Context),
        Mfg = z_context:get_q_validated("manufacturer_id", Context),
        Status = m_rsc:name_to_id_check("node_status_active", Context),
        Department = m_rsc:name_to_id_check("department_radiology", Context),
        CatId = m_rsc:name_to_id_check("node", Context),
        Props = [
            {category_id, CatId},
            {title, Title},
            {summary, Description},
            {department_id, Department},
            {model, Model},
            {room, Serial},
            {room, Room},
            {node_type_id, list_to_integer(Type)},
            {node_sub_type_id, list_to_integer(SubType)},
            {manufacturer_id, list_to_integer(Mfg)},
            {node_status_id, Status},
            {is_published, true}
        ],
        Props.

proc_network_form(Context) ->
        HostName = z_context:get_q("hostname", Context),
        SendsTo = z_context:get_q("sends_to", Context),
        Port = z_context:get_q("port", Context),
        Oct1 = z_context:get_q("oct1", Context),
        Oct2 = z_context:get_q("oct2", Context),
        Oct3 = z_context:get_q("oct3", Context),
        Oct4 = z_context:get_q("oct4", Context),
	Props = [
	    {hostname, HostName},
	    {sends_to, z_convert:to_integer(SendsTo)},
	    {port, z_convert:to_integer(Port)},
	    {oct1, z_convert:to_integer(Oct1)},
	    {oct2, z_convert:to_integer(Oct2)},
	    {oct3, z_convert:to_integer(Oct3)},
	    {oct4, z_convert:to_integer(Oct4)}
	],
	Props.

observe_search_query({search_query, {node_type_server, [{node_type, NodeType}]}, OffsetLimit}, Context) ->
    m_node:search({node_type_server, [{node_type, NodeType}]}, OffsetLimit, Context);

observe_search_query({search_query, {node_status, [{status_id, Status}]}, OffsetLimit}, Context) ->
    m_node:search({node_status, [{status_id, Status}]}, OffsetLimit, Context);

observe_search_query({search_query, {search_nodes, Args}, OffsetLimit}, Context) ->
    m_node:search({search_nodes, Args}, OffsetLimit, Context);

observe_search_query({search_query, {node_count_by_type, Args}, OffsetLimit}, Context) ->
    m_node:search({node_count_by_type, Args}, OffsetLimit, Context);

observe_search_query({search_query, {node_count_by_sub_type, Args}, OffsetLimit}, Context) ->
    m_node:search({node_count_by_sub_type, Args}, OffsetLimit, Context);

observe_search_query(_, _Context) ->
    undefined.

%% Form validations
check_name(Value, Context) ->
    Id = z_db:q1("select id from rsc where pivot_title = '" ++ z_string:to_lower(Value) ++ "';", Context),
    case Id of
        undefined -> {ok, Value};
        _Found -> {error, duplicate} 
    end.

check_name(Id, Value, Context) ->
    Checkit = z_db:q1("select id from rsc where pivot_title = '" ++ z_string:to_lower(Value) ++ "';", Context),
    case Checkit of
       Id -> {ok, Value};
       undefined -> {ok, Value};
       _Found -> {error, duplicate}
    end.

check_ip(Id, IP, Context) ->
    Checkit = z_db:q1("select id from pivot_mod_node where oct1 = $1 and oct2 = $2 and oct3 = $3 and oct4 = $4",IP, Context),
    case Checkit of
       Id -> {ok, IP};
       undefined -> {ok, IP};
       _Found -> {error, duplicate}
    end.
