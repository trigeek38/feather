{% extends "node_base.tpl" %}
{% block chapeau %}
  <ul class="breadcrumb">
    <li><a href="{% url node_home %}"><button class="btn"><i class="icon-home"></i> Home</button></a>
    </li>
    <li>{% button title="Save" action={submit target="node_form"} text="<i class='icon-ok icon-white'></i> Save" class="btn btn-primary" %}</a>
    </li>
    <li><a href="#" id="back"><button class="btn"><i class="icon-remove"></i> Cancel</button></a>
    </li>
    </ul>
    {% wire id="back" action={redirect back} %}

{% endblock %}
{% block content %}
  <div class="row">
    <div class="span8">
      {% wire id="node_form" type="submit" postback={edit_node id=id} delegate="mod_node" %}
      <form class="form-horizontal" method="POST" action="postback" id="node_form">
        <fieldset>
          <legend>Editing {{id.title}} </legend>
	  {% include "_node_form_fields.tpl" id=id%}
          <div class="form-actions">
            <button type="submit" class="btn btn-primary">Save changes</button>
          </div>
        </fieldset>
      </form>
    </div>
  </div>
{% endblock %}
