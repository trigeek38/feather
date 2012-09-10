{% with m.acl.user as user_id %}
{% if user_id  %}
{% wire id="tasks-form" type="submit" postback={edit_task id=task.id} delegate="mod_task" action={dialog_close} %}
<form id="tasks-form" class="form-horizontal" method="post" action="postback">
    {% include "_task_form_items.tpl" task=task %}
    {% button class="btn btn-primary" text="Update" %}
</form>
{% else %}
<p id="tasks-logon"><a href="{% url logon back %}">{_ Log on or sign up to comment _}</a>.</p>
{% endif %}
{% endwith %}
{% validate id="task_detail" type={presence} %}
