{% extends "base.tpl" %}
{% block messages %}
<div class="page-header"><h1>Inventory <small>Classes and Catagories Home Page</small></h1></div>
    <div class="alert hide alert-success" id="messages"></div>
{% endblock %}

{% block chapeau %}
  <ul class="breadcrumb">
    <li><a href="{% url node_home %}"><button class="btn"><i class="icon-home"></i> Home</button></a>
    </li>
    <li><a href="{% url node_list %}"><button class="btn"><i class="icon-list"></i> List</button></a>
    </li>
    <li>{% button class="btn" text="<i class='icon-plus'></i> Quick Add" action={ dialog_open title="Quick Add" template="_node_quick_add.tpl" node_type=q.node_type node_sub_type=q.node_sub_type } %}
    </li>
    </ul>
{% endblock %}

