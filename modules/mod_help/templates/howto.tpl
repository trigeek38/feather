{% extends "base.tpl" %}

{% block content %}
{% wire id="add-howto" action={update target="howto-div" template="_add_howto.tpl"} %}
<div class="row">
  <div class="span8">
    <div class="row">
    <h2 class="span8">{{m.rsc.howto.id.title}}</h2>
      <a href="#" id="add-howto" class="pull-right"><i class="icon-plus"></i> Add</a>
      {% sorter id="howto-sorter" tag="howto" delegate="mod_help" %}
    </div>
    <hr>
  </div>
  <div class="span8" id="howto-div"></div>
  <div class="span8">
    <ul class="nav nav-list" id="howto-sorter">
    {% for howto in m.search[{search_howto}] %} 
      <li id="sort-howto-{{howto.id}}"><a href="{% url howto_detail id=howto.id slug=howto.id.slug %}">{{forloop.counter}}. {{howto.id.title}}</a></li>
      {% sortable id=["sort-howto",howto.id]|join:"-" tag=howto.id delegate="mod_help" %}
    {% endfor %}
    </ul>
  </div>
</div>
{% endblock %}
