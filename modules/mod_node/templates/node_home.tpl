{% extends "node_base.tpl" %}

{% block content %}
<div class="" id="inventory_main">
          <ul id="myTab" class="nav nav-tabs">
            <li class="active"><a href="#node_type" data-toggle="tab">Class</a></li>
            <li><a href="#node_sub_type" data-toggle="tab">Category</a></li>
          </ul>
          <div id="myTabContent" class="tab-content">
            <div class="tab-pane fade in active" id="node_type">
    {% include "_node_list_type.tpl" %}
            </div>
            <div class="tab-pane fade" id="node_sub_type">
    {% include "_node_list_sub_type.tpl" %}
            </div>
          </div>
</div>
{% endblock %}
