{% extends "base.tpl" %}
{% block chapeau %}
{% endblock %}
{% block content %}
    <div class="well">
       <h1>{{ id.issue_type_id.title}} # {{ id.id }}</h1>
       <h2><a href="{% url node_detail id=id.rsc_id %}">{{ id.rsc_id.title }}</a></h2>
       <div class="alert {% if id.is_complete %} alert-success {% else %} alert-error {% endif %}"><h4>{{ id.issue_detail }}</h4> <small> {{ id.request_date|timesince }}</small></div>
       {% if id.is_complete %} <div class="alert alert-info"><h4>{{ id.issue_solution }}</h4> <small>{{ id.complete_date|timesince }}</small></div>{% endif %}
    <div>
    {% button class="btn btn-primary" text="Edit Issue" action={dialog_open title="Edit Issue" template="edit_issue.tpl" id=id} %}
    {% if not id.is_complete %}
    {% button class="btn btn-primary" text="Mark Complete"  action={dialog_open title="Mark Complete" template="_issue_mark_complete.tpl" id=id} %}
    {% endif %}
    </div>
    </div>
    <div class="well">
    <table id="issue-table" class="table table-striped">
    <tbody>
    <tr>
    <td width="20%">Requested By:</td><td> {{ id.requested_by }}</td>
    </tr>
    <tr>
    <td>Date:</td><td> {{ id.request_date|date:"Y-m-d" }}
    {{ id.request_date|date:"H:i" }}
    </td>
    </tr>
    <tr>
    <td>Assigned To:</td><td> {{ id.assigned_id.title }}</td>
    </tr>
    <tr>
    <td>Complete Date:</td><td> {{ id.complete_date|date:"Y-m-d" }}
    {{ id.complete_date|date:"H:i" }}
    </td>
    </tr>
    </tbody>
    </table>
    </div>
    <hr>
    <div id="tasks">{% include "_tasks_table.tpl" id=id %}</div>
      {% wire action={connect signal={new_task} action={update target="tasks" template="_tasks_table.tpl" id=id}}  %}

{% endblock %}
