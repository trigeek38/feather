{% extends "base.tpl" %}

{% block chapeau %}
  <h2>Workorder Home</h2>
{% endblock %}
{% block content %}
<div class="" id="workorder_main">
    <h3>List of items on this page</h3>
    <ul>
        <li>Count of open workoders</li>
        <li>Show stats for last 7 and 30 days - #call, #hours</li>
	<li>Show inventory with most work orders</li>
        <li>Completed work orders for today</li>
        <li>Summary list of last 5 completed work workorders</li>
        <li>Open work orders by engineer</li>
    </ul>
        <select id="assigned_to" name="assigned_to">
	<option value="">--Select Assignee--</option>
        {% for id in m.rsc.servicers_inhouse.s.relation %}
	    <option value="{{id.id}}">{{ id.title }}</option>
	{% endfor %}
	<option value="">--3rd Party--</option>
        {% for id in m.rsc.servicers_3rd_party.s.relation %}
	    <option value="{{id}}">{{ id.title }}</option>
	{% endfor %}
	</select>

</div>

{% endblock %}
