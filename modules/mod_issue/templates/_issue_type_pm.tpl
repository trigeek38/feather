    <div class="row">
      <div class="span4">
      <h4>Pending PMs by Class</h4>
         {% with m.search[{issue_count_by_node_type is_complete = 'false' issue_type_id = 'issue_type_pm'}] as issues %}
         {% include "_open_issue_by_node_type.tpl" %}
	 {% endwith %}
      </div>
      <div class="span4">
      <h4>Pending PMs by Class</h4>
         {% include "_open_pm_by_node_sub_type.tpl" %}
      </div>
    </div>
    <hr>
    <div class="row">
        <div class="span8">
	<div class="label label-info"><h4>Pending PMs</h4></div>
                {% with m.issue.all_pending['issue_type_pm'] as issues %}
                  {% include "_issue_nodes_table.tpl" issues=issues %}
                {% endwith %}
        </div>
    </div>

