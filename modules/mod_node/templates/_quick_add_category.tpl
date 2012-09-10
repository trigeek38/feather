      {% wire id="category_form" type="submit" postback={quick_add_category} delegate="mod_node"
                                          action={dialog_close} %}
      <form class="form-inline" method="POST" action="postback" id="category_form">
            <select class="input-medium" name="node_type_id" id="node_type_id">
	    {% for title, id in m.search[{all_bytitle cat="node_type"}] %}
	       <option value={{ id }}>{{ title }}</option>
	    {% endfor %}
	    <input type="text" id="category_name" name="category_name" class="input-medium">
            <button type="submit" class="btn btn-primary">Save</button>
      </form>
