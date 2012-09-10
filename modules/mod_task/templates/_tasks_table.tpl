<div class="row">
    <div class="span9">
    {% button id="new_task" class="btn btn-primary" text="New Task" %}
    </div>
  <div class="span9">
    {% with m.task.pending[id] as tasks %}
    <h5 class="label alert-info">Pending</h5>
    {% if tasks %}
    <table id="pending-task-list" class="table table-condensed table-bordered table-striped">
    <thead>
        <tr>
	    <th width="8%"></th>
	    <th width="50%">Details</th>
	    <th width="15%">Assigned to</th>
	    <th width="15%">Date</th>
	    <th width="10%">Hours</th>
	    <th width="5%"></th>
	</tr>
    </thead>
    <tbody>
       {% for task in tasks %}
         {% include "_tasks_table_task.tpl" %}
       {% endfor %}
    </tbody>
    </table>
    {% else %}
      <h5 class="alert alert-notice">No pending tasks.</h5>
    {% endif %}
    {% endwith %}
  </div>
  <div class="span9">
    {% with m.task.completed[id] as completed_tasks %}
    <h5 class="label alert-success">Completed</h5>
    {% if completed_tasks %}
    <table id="completed-task-list" class="table table-condensed table-bordered table-striped">
    <thead>
        <tr>
	    <th width="8%"></th>
	    <th width="50%">Details</th>
	    <th width="15%">Assigned to</th>
	    <th width="15%">Date</th>
	    <th width="10%">Hours</th>
	    <th width="5%"></th>
	</tr>
    </thead>
    <tbody>
      {% for task in completed_tasks %}
        {% include "_tasks_table_task.tpl" %}
      {% endfor %}
    </tbody>
    </table>
    {% else %}
      <h5 class="alert alert-notice">No completed tasks.</h5>
    {% endif %}
    {% endwith %}
  </div>
</div>
{% wire id="show_task_form" action={ toggle target="task-form" } %}
{% wire id="new_task" action={ dialog_open title="New Task" template="add_task.tpl" id=id } %}
