{% extends "node_base.tpl" %}
{% block content %}

  <div>
   <form id="{{ #form }}" method="GET" action="" class="navbar-form pull-left form-inline">
   <input type="hidden" name="qsort" value="title" />
    <p>
            <label class="control-label" for="node_type_id">Type:</label>
              <select id="node_type" name="node_type" class="span2">
                  <option value="disabled">--Select a node type--</option>
                {% for title, id in m.search[{all_bytitle cat="node_type"}] %}
                  <option value={{id}}{% ifequal id q.node_type %} selected {% endifequal %}>{{ title }}</option>
                {% endfor %}
              </select>
          {% if q.node_type %}
            <label class="control-label" for="node_type_id">Sub Type:</label>
              <select id="node_sub_type" name="node_sub_type" class="span2">
                  <option value="disabled">--Select a node type--</option>
                {% for id in m.search[{query hassubject=[q.node_type,'children'] sort='pivot_title'}] %}
                  <option value={{id}}{% ifequal id q.node_sub_type %} selected {% endifequal %}>{{ id.title }}</option>
                {% endfor %}
              </select>
          {% endif %}
  </p>
   {% wire type="change" id="node_type" action={set_value target="node_sub_type" value=""} %}
   {% wire type="change" id="node_type" action={submit} %}
   {% wire type="change" id="node_sub_type" action={submit} %}
   </form>
   </div>

   <div>
<table class="table table-bordered table-striped">
  <thead>
    <tr>
      <th>{% include "_node_table_header.tpl" label="Name" field='title' %}</th>
      <th width="8%">{% include "_node_table_header.tpl" label="Type" field='node_type' %}</th>
      <th width="15%">{% include "_node_table_header.tpl" label="Sub Type" field='sub_type' %}</th>
      <th width="20%">Location</th>
      <th width="20%">Attached to</th>
      <th width="2%">Status</th>
      <th width="2%">W</th>
      <th width="2%">P</th>
    </tr>
  </thead>
  <tbody>
    {% if q.node_sub_type and q.node_type %}
        {% for id in m.search[{search_nodes node_type_id=q.node_type node_sub_type_id=q.node_sub_type sort=q.qsort|default:"title" order=q.qorder|default:"asc" }] %}
            {% include "_node_item.tpl" id=id%}
        {% endfor %}
    {% else %}
        {% if q.node_type and not q.node_sub_type %}
            {% for id in m.search[{search_nodes node_type_id=q.node_type sort=q.qsort|default:"title" order=q.qorder|default:"asc"}] %}
                {% include "_node_item.tpl" id=id%}
            {% endfor %}
        {% else %}
            {% for id in m.search[{search_nodes sort=q.qsort|default:"title" order=q.qorder|default:"asc"}] %}
                {% include "_node_item.tpl" id=id%}
            {% endfor %}
        {% endif %}
    {% endif %}
  </tbody>
</table>
</div>
{% endblock %}
