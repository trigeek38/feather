<tr id="task-{{ task.id }}" style="cursor: pointer;">
	<td class="task-body">
	{% if task.is_complete %}
            <button class="btn btn-mini btn-warning" name="complete" id="task-{{task.id}}-check">re-open</button>
	{% else %}
            <button class="btn btn-mini btn-success" name="complete" id="task-{{task.id}}-check">close</button>
	{% endif %}
	</td>
	<td>
        {{ task.task_detail }}
        </td>
	<td>{{ task.user_id.title }}</td>
	<td>{{ task.completed_date|date:"Y-m-d H:i" }}</td>
	<td>{{ task.hours }}</td>
	<td>{% button id=["delete-task", task.id]|join:"-" class="btn btn-mini btn-danger" text="X" %}</td>
</tr>
{% wire id=["delete-task", task.id]|join:"-" action={alert title="Delete" text=["Delete task", task.id]|join:" " } %}
{% wire id=["task",task.id]|join:"-" action={dialog_open title="Update" template="edit_task.tpl" task=task } %}
{% wire id=["task",task.id,"check"]|join:"-" action={postback postback={toggle_status id=task.id status=task.is_complete} delegate="mod_task"} %}
