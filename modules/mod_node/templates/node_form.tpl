  <div class="row">
    <div class="span8">
      {% wire id="node_form" type="submit" postback={add_node} delegate="mod_node" %}
      <form class="form-horizontal" method="POST" action="postback" id="node_form">
        <fieldset>
          <legend>Add New Item</legend>
	  {% with m.rsc[q.id] as id %}
	  {% include "_node_form_fields.tpl" id=id %}
	  {% endwith %}
          <div class="form-actions">
            <button type="submit" class="btn btn-primary">Save changes</button>
          </div>
        </fieldset>
      </form>
    </div>
  </div>
