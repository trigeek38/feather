{% extends "base.tpl" %}
{% block messages %}
<div class="page-header">
<h1>Issues <small>Work Order, Projects and PMs Home Page</small></span></h1>
    <div class="alert hide alert-success" id="messages"></div>
</div>
{% endblock %}

{% block chapeau %}
  <ul class="breadcrumb">
    <li><a href="{% url issue_home %}"><button class="btn"><i class="icon-home"></i> Home</button></a>
    </li>
    <li><a href="{% url issue_list %}"><button class="btn"><i class="icon-list"></i> List</button></a>
    </li>
    <li><a href="{% url issue_add %}"><button class="btn"><i class="icon-plus"></i> Add</button></a>
    </li>
    </ul>
{% endblock %}

