<div id="tasks">{% include "_tasks.tpl" id=id %}</div>
  {% wire action={connect signal={new_task } action={update target="tasks" template="_tasks.tpl" id=id}}  %}
</div>

