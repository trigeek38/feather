{% with m.acl.user as user_id %}
{% if user_id  %}
{% wire id="issue-form" type="submit" postback={add_issue} delegate="mod_issue" %}
<form id="issue-form" class="well form-horizontal"  method="post" action="postback">
    {% include "_issue_form_fields.tpl" %}
<button type="submit" class="btn btn-primary">Create</button>
</form>
{% else %}
<p id="tasks-logon"><a href="{% url logon back %}">{_ Log on or sign up to comment _}</a>.</p>
{% endif %}
{% endwith %}
