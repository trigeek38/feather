<div class="row">
    <div class="span8">
    <a class="toggle-link" id="show_task_form" href="#new-task"><i class="icon-plus"></i> New Task</a>
       <div id="task-form" style="display: none;">
         {% include "_tasks_form.tpl" %}
       </div>
    </div>
  <div class="span8">
    {% with m.task.pending[id] as tasks %}
    <h3>Pending</h3>
    <ul id="pending-task-list" class="well unstyled">
    {% if tasks %}
       {% for task in tasks %}
         {% include "_tasks_task.tpl" %}
       {% endfor %}
    {% else %}
      <li>No pending tasks.</li>
    {% endif %}
    </ul>
    {% endwith %}
  </div>
  <div class="span8">
    {% with m.task.completed[id] as completed_tasks %}
    <h3>Completed</h3>
    <ul id="completed-task-list" class="well unstyled">
    {% if completed_tasks %}
      {% for task in completed_tasks %}
        {% include "_tasks_task.tpl" %}
      {% endfor %}
    {% else %}
      <li>No completed task</li>
    </ul>
    {% endif %}
    {% endwith %}
  </div>
</div>
{% sorter id="pending-task-list" tag="task_sorter" delegate="mod_task" %}
{% wire id="show_task_form" action={ toggle target="task-form" } %}
