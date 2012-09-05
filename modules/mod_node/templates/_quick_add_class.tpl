      {% wire id="class_form" type="submit" postback={quick_add_class} delegate="mod_node"
                                          action={dialog_close} %}
      <form class="form-inline" method="POST" action="postback" id="class_form">
            <input type="text" class="input-small" name="class_name" id="class_name">
            <button type="submit" class="btn btn-primary">Save</button>
      </form>
      <ul>
        {% for title, id in m.search[{all_bytitle cat="node_type"}] %}
	<li>{{ title }}</li>
	{% endfor %}
      </ul>
