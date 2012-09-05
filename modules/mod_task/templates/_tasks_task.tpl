<li id="task-{{ task.id }}" style="cursor: pointer;">
	<p class="task-body">
        <input type="checkbox" name="complete" id="task-{{task.id}}-check" {% if task.is_complete %}checked{% endif %}>
        {{ task.task_detail }}
        </p>
</li>
{% sortable id=["task",task.id]|join:"-" tag=task.id %}
{% wire id=["task",task.id,"check"]|join:"-" action={postback postback={toggle_status id=task.id status=task.is_complete} delegate="mod_task"} %}
