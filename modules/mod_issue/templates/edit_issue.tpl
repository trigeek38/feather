{% with m.acl.user as user_id %}
{% if user_id  %}
{% wire id="issue-form" type="submit" postback={edit_issue id=id} delegate="mod_issue" %}
<form id="issue-form" class="form-horizontal"  method="post" action="postback">
    {% include "_issue_form_fields.tpl" id=id %}
<button type="submit" class="btn btn-primary">Update</button>
</form>
{% else %}
<p id="tasks-logon"><a href="{% url logon back %}">{_ Log on or sign up to comment _}</a>.</p>
{% endif %}
{% endwith %}
