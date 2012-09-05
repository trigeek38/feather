{% extends "issue_base.tpl" %}

{% block content %}
<div class="" id="issue_main">
          <ul id="issueTab" class="nav nav-tabs">
            <li class="active"><a href="#issue_type_work_order" data-toggle="tab">Work Orders</a></li>
            <li><a href="#issue_type_project" data-toggle="tab">Projects</a></li>
            <li><a href="#issue_type_pm" data-toggle="tab">PMs</a></li>
          </ul>
          <div id="issueTabContent" class="tab-content">
            <div class="tab-pane fade in active" id="issue_type_work_order">
    {% include "_issue_type_workorders.tpl" %}
            </div>
            <div class="tab-pane fade" id="issue_type_project">
    {% include "_issue_type_project.tpl" %}
            </div>
            <div class="tab-pane fade" id="issue_type_pm">
    {% include "_issue_type_pm.tpl" %}
            </div>
          </div>
</div>
{% endblock %}
