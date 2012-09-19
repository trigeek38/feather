<div class="row">
<div class="span9">
{% for remid in m.search[{search_reminders rscid=id}]  %}
  <div class="span4">
    <strong>{{ remid.id.title }} </strong>  <p>At: {{ remid.id.date_end|time_diff:diff|date:"Y-m-d H:i" }}</p>
    <p>{{ remid.id.summary }} </p>
  </div>
  <div>
    <a id="edit-rem-{{remid.id}}" class="btn"> <i class="icon-pencil"></i> Edit </a>
     {% wire id=["edit-rem", remid.id]|join:"-"
             action={dialog_open template="_edit_reminder.tpl" title="Edit Reminder" remid=remid.id diff=diff} %}
    <a id="delete-rem-{{remid.id}}" class="btn btn-danger"> <i class="icon-remove-sign icon-white"></i> Delete </a>
     {% wire id=["delete-rem", remid.id]|join:"-"
             postback={delete_reminder remid=remid.id}
             delegate="resource_reminder" %}
  </div>
{% empty %}
  <p> No Active Reminders </p>
{% endfor %}
</div>
</div>
