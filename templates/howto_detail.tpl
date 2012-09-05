{% extends "base.tpl" %}

{% block content %}
{% wire id="edit-howto" action={update target="howto-div" template="_edit_howto.tpl" id=id} %}
{% wire id="delete-howto" action={confirm text="Delete the Question?" postback={delete_howto id=id} delegate="mod_help"} %}
<div class="row" id="howto-div">
  <div class="span8">
    <div class="row">
    <a href="/">home / </a><a href="{% url howto %}">howto</a>
      <a href="#" id="delete-howto" style="margin:5px;" class="pull-right"><i class="icon-remove"></i> Delete</a>
      <a href="#" id="edit-howto" style="margin:5px;" class="pull-right"><i class="icon-edit"></i> Edit</a>
    <h2 class="span8">{{ id.title}}</h2>
    </div>
    <hr>
  </div>
  <div class="span8"> 
    {{ id.body }}
  </div>
  {#
  <div id="tasks">{% include "_tasks.tpl" id=id %}</div>
  {% wire action={connect signal={new_task } action={update target="tasks" template="_tasks.tpl" id=id}}  %}
  #}
</div>
{% endblock %}