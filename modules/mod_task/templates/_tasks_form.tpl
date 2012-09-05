{% with m.acl.user as user_id %}
{% if user_id  %}
{% wire id="tasks-form" type="submit" postback={add_task id=id} delegate="mod_task" %}
<form id="tasks-form" class="well form-inline"  method="post" action="postback">
<label class="control-label" for="task_detail">Task Details</label>
<input class="input-xlarge" id="task_detail" name="task_detail">
<button type="submit" class="btn btn-primary">Create</button>
</form>
{% else %}
<p id="tasks-logon"><a href="{% url logon back %}">{_ Log on or sign up to comment _}</a>.</p>
{% endif %}
{% endwith %}
{% validate id="task_detail" type={presence} %}
