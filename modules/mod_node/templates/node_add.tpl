{% extends "node_base.tpl" %}
{% block chapeau %}
  <ul class="breadcrumb">
      <li><a href="{% url node_home %}"><button class="btn"><i class="icon-home"></i> Home</button></a>
      </li>
    <li>{% button title="Save" text="<i class='icon-ok icon-white'></i> Save" action={ submit target="node_form"} class="btn btn-primary" %}
    </li>
    <li><a href="#" id="back"><button class="btn"><i class="icon-remove"></i> Cancel</button></a>
    </li>
    </ul>
    {% wire id="back" action={redirect back} %}

{% endblock %}
{% block content %}
    {% include "node_form.tpl" %}
{% endblock %}
