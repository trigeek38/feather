      {% wire id="node-attached-form" type="submit" postback={attach_node id=id} delegate="mod_node" %}
      <form class="form-horizontal" method="POST" action="postback" id="node-attached-form">
      <div class="well">
          <div class="control-group">
            <label class="control-label" for="sends_to">Attached to:</label>
            <div class="controls">
	      <select id="attached_to" name="attached_to">
	      <option value="">--Select a destination--</option>
	      {% for server in m.search[{query cat="node_type" sort='pivot_title'}] %}
	         <option value="">{{server.title}}</option>
	         {% for id in m.search[{search_nodes node_type_id=server.id sort='title' order='asc' }] %}
	          <option value={{ id.id }}>----{{m.rsc[id.id].node_sub_type_id.title}} - {{ m.rsc[id.id].title }}</option>
		 {% endfor %}
	      {% endfor %}
	      </select>
            </div>
          </div>
          <div class="control-group">
            <button type="submit" class="btn btn-primary pull-right">Save changes</button>
	  </div>
	  </div>
      </form>
