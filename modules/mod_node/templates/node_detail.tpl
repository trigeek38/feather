{% extends "node_base.tpl" %}
{% block chapeau %}
  <ul class="breadcrumb">
    <li><a href="{% url node_home%}"><button class="btn"><i class="icon-home"></i> Home</button></a>
    </li>
    <li><a href="{% url node_list %}"><button class="btn"><i class="icon-list"></i> List</button></a>
    </li>
    <li>{% button class="btn" text="<i class='icon-plus'></i> Quick Add" action={ dialog_open title="Quick Add" template="_node_quick_add.tpl"} %}
    </li>

<li><a href="{% url node_edit id=id%}"><button class="btn"><i class="icon-pencil"></i> Edit</button></a>
    </li>
    <li><a href="{% url node_add id=id %}"><button class="btn"><i class="icon-file"></i> Duplicate</button></a>
    </li>
    <li>{% button class="btn" text="<i class='icon-random'></i> Attached To" action={ dialog_open title="Attached To" template="_node_edit_attached.tpl" id=id} %}
    </li>
    <li>{% button class="btn" text="<i class='icon-random'></i> Network" action={ dialog_open title="Network Info" template="_node_edit_network.tpl" id=id} %}
    </li>
    </ul>
{% endblock %}
{% block content %}
<div class="header"><h1>{{ id.title }}</h1>
             <h4 class="alert alert-info">{{ id.summary }}</h4>
	     </div>

<div class="" id="node_main">
    <ul id="nodeTab" class="nav nav-tabs">
       <li class="active"><a href="#node_info" data-toggle="tab">Info</a></li>
       <li><a href="#node_work_orders" data-toggle="tab">Work Orders</a></li>
       <li><a href="#node_projects" data-toggle="tab">Projects</a></li>
       <li><a href="#node_pms" data-toggle="tab">PMs</a></li>
    </ul>
    <div id="nodeTabContent" class="tab-content">
       <div class="tab-pane fade in active" id="node_info">
          <div class="row well">
	    <div class="span4">
          {% with m.rsc[q.id] as id%}
	     <table class="table table-striped table-condensed table-bordered">
	     <tr>
             <td width='20%'>Class:</td><td>{{ id.node_type_id.title }}</td>
	     </tr>
	     <tr>
             <td>Category:</td><td>{{ id.node_sub_type_id.title }}</td>
	     </tr>
	     <tr>
             <td>Manufacturer:</td><td>{{ id.manufacturer_id.title }}</td>
	     </tr>
	     <tr>
             <td>Model:</td><td>{{ id.model }}</td>
	     </tr>
	     <tr>
             <td>Serial:</td><td>{{ id.serial }}</td>
	     </tr>
	     <tr>
             <td>Warranty:</td><td>{{ id.warranty|date:"Y-m-d" }}</td>
	     </tr>
	     <tr>
             <td>Location:</td><td>{{ id.room }}</td>
	     </tr>
	     <tr>
             <td>Phone: <i id="id_phone"><i class="icon-user"></i></td><td><div id="phone_form">{{ id.phone }}</div></td>
	     {% wire id="id_phone" action={update target="phone_form" template="_quick_edit_phone.tpl" id=id.id} %}
	     </tr>
	     </table>
          {% endwith %}
	    </div>
	    <div class="span4">
	     <h4>Attached to:<a href="{% url node_detail id=id.attached_to %}"> {{ id.attached_to.title }} </a></h4>
	     <h4>Attached items:</h4>
	       <ul>{% for attached in m.node.attached[id.id] %}
	           <li><a href="{% url node_detail id=attached.id %}">
		   {{ m.rsc[attached.id].title }} {{ m.rsc[attached.id].node_sub_type_id.title}}</a></li>
                      <ul>
                      {% for sub_attached in m.node.attached[attached.id] %}
	                 <li><a href="{% url node_detail id=sub_attached.id %}">
		         {{ m.rsc[sub_attached.id].title }} {{ m.rsc[sub_attached.id].node_sub_type_id.title}}</a></li>
                      {% endfor %}
                      </ul>
		   {% endfor %}
	       </ul>
	     <hr>
	     <h4>Network Settings</h4>
	     <p><b>Hostname: </b>{{id.hostname}}</p>
	     <p><b>IP: </b>{{id.oct1}}.{{id.oct2}}.{{id.oct3}}.{{id.oct4}}</p>
	     <hr>
	     <h4>Sends to:<a href="{% url node_detail id=id.sends_to %}"> {{ id.sends_to.title }} </a></h4>
	     <p><b>Port: </b> {{ m.rsc[id].port}}</p>
	     <hr>
	     <h4>Receives from:</h4>
	       <ul>{% for sender in m.node.all_senders[id.id] %}
	           <li><a href="{% url node_detail id=sender.id %}">{{ m.rsc[sender.id].title }} {{m.rsc[sender.id].port}}</a></li>
		   {% endfor %}
	       </ul>
	    </div>
       </div>
    </div>
    <div class="tab-pane fade" id="node_work_orders">
    <a href="#"><button class="btn" id="add_wo"><i class="icon-wrench"></i> Open Work Order</button></a>
       <hr>
       <h4 class="label label-info">Pending Work Orders</h4>
       {% with m.search[{issues issue_type_id=m.rsc.issue_type_work_order.id rsc_id=id.id is_complete=0 }] as issues %}
           {% if issues %}
           {% include "_issue_table.tpl" issues=issues %}
	   {% else %}
	      <div class="alert alert-notice">None Pending</div>
	   {% endif %}
       {% endwith %}
       <h4 class="label label-info">Closed Work Orders</h4>
       {% with m.search[{issues issue_type_id=m.rsc.issue_type_work_order.id rsc_id=id.id is_complete=1 }] as issues %}
           {% if issues %}
           {% include "_issue_table.tpl" issues=issues %}
	   {% else %}
	      <div class="alert alert-notice">None Complete</div>
	   {% endif %}
       {% endwith %}
    </div>
    <div class="tab-pane fade" id="node_projects">
    <a href="#"><button class="btn" id="add_project"><i class="icon-wrench"></i> Open Project</button></a>
       <hr>
       <h4 class="label label-info">Pending Projects</h4>
       {% with m.search[{issues issue_type_id=m.rsc.issue_type_project.id rsc_id=id.id is_complete=0 }] as issues %}
           {% if issues %}
           {% include "_issue_table.tpl" issues=issues %}
	   {% else %}
	      <div class="alert alert-notice">None Pending</div>
	   {% endif %}
       {% endwith %}
       <h4 class="label label-info">Closed Projects</h4>
       {% with m.search[{issues issue_type_id=m.rsc.issue_type_project.id rsc_id=id.id is_complete=1 }] as issues %}
           {% if issues %}
           {% include "_issue_table.tpl" issues=issues %}
	   {% else %}
	      <div class="alert alert-notice">None Complete</div>
	   {% endif %}
       {% endwith %}
    </div>
    <div class="tab-pane fade" id="node_pms">
    <a href="#"><button class="btn" id="add_pm"><i class="icon-wrench"></i> Open PM</button></a>
       <hr>
       <h4 class="label label-info">Pending PMs</h4>
       {% with m.search[{issues issue_type_id=m.rsc.issue_type_pm.id rsc_id=id.id is_complete=0 }] as issues %}
           {% if issues %}
           {% include "_issue_table.tpl" issues=issues %}
	   {% else %}
	      <div class="alert alert-notice">None Pending</div>
	   {% endif %}
       {% endwith %}
       <h4 class="label label-info">Closed PMs</h4>
       {% with m.search[{issues issue_type_id=m.rsc.issue_type_pm.id rsc_id=id.id is_complete=1 }] as issues %}
           {% if issues %}
           {% include "_issue_table.tpl" issues=issues %}
	   {% else %}
	      <div class="alert alert-notice">None Complete</div>
	   {% endif %}
       {% endwith %}
    </div>
    </div>
</div>

{% wire id="add_wo" action={dialog_open title=[id.title,"<div class='alert alert-error'>Add Work Order</div>"]|join:" "
                                        template="node_add_issue.tpl" 
					issue_type_id = m.rsc.issue_type_work_order.id
					id = id.id } %}
{% wire id="add_project" action={dialog_open title=[id.title,"<div class='alert alert-warning'>Add Project</div>"]|join:" " 
                                        template="node_add_issue.tpl" 
					issue_type_id = m.rsc.issue_type_project.id
					id = id.id } %}
{% wire id="add_pm" action={dialog_open title=[id.title,"<div class='alert alert-info'>Add PM</div>"]|join:" " 
                                        template="node_add_issue.tpl" 
					issue_type_id = m.rsc.issue_type_pm.id
					id = id.id } %}
{% endblock %}
