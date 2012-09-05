      {% wire id="class_form" type="submit" postback={quick_add_class} delegate="mod_node"
                                          action={dialog_close} %}
      <form class="form-inline" method="POST" action="postback" id="class_form">
            <select class="input-medium" name="class_name" id="class_name">
	    {% for title, id in m.search[{all_bytitle cat="node_type"}] %}
	       <option value={{ id }}>{{ title }}</option>
	    {% endfor %}
	    <input type="text" id="category" name="category" class="input-medium">
            <button type="submit" class="btn btn-primary">Save</button>
      </form>
