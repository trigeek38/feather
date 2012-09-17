{% extends "base.tpl" %}

{% block content %}
{% wire id="edit-howto" action={update target="howto-div" template="_edit_howto.tpl" id=id} %}
{% wire id="delete-howto" action={confirm text="Delete the Question?" postback={delete_howto id=id} delegate="mod_help"} %}
<div class="row" id="howto-div">
  <div class="span9">
    <div class="row">
    <a href="/">home / </a><a href="{% url howto %}">howto</a>
      <a href="#" id="delete-howto" style="margin:5px;" class="pull-right"><i class="icon-remove"></i> Delete</a>
      <a href="#" id="edit-howto" style="margin:5px;" class="pull-right"><i class="icon-edit"></i> Edit</a>
    <h2 class="span9">{{ id.title}}</h2>
    </div>
    <hr>
  </div>
  <div class="span9"> 
{% button class="btn" postback={convert_to_pdf id=id template="howto_detail.tpl" id=id.id} delegate="mod_pdf" %}
    {{ id.body }}
  </div>
</div>
{% endblock %}
