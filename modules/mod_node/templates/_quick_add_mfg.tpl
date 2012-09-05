      {% wire id="mfg_form" type="submit" postback={quick_add_mfg} delegate="mod_node"
                                          action={dialog_close} %}
      <form class="form-inline" method="POST" action="postback" id="mfg_form">
            <input type="text" class="input-small" name="mfg_name" id="mfg_name">
            <button type="submit" class="btn btn-primary">Save</button>
      </form>
      <ul>
        {% for title, id in m.search[{all_bytitle cat="manufacturer"}] %}
	<li>{{ title }}</li>
	{% endfor %}
      </ul>
