      {% wire id="node-network-form" type="submit" postback={edit_node_network id=id} delegate="mod_node" %}
      <form class="form-horizontal" method="POST" action="postback" id="node-network-form">
      <div class="well">
          <div class="control-group">
            <label class="control-label" for="hostname">Hostname:</label>
            <div class="controls">
              <input type="text" class="input-medium" id="hostname" name="hostname" value="{{id.hostname}}">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="oct1">IP:</label>
            <div class="controls">
              <input type="text" class="input-xmini" id="oct1" name="oct1" value="{{id.oct1}}">
              <input type="text" class="input-xmini" id="oct2" name="oct2" value="{{id.oct2}}">
              <input type="text" class="input-xmini" id="oct3" name="oct3" value="{{id.oct3}}">
              <input type="text" class="input-xmini" id="oct4" name="oct4" value="{{id.oct4}}">
            </div>
          </div>
	  <hr>
          <div class="control-group">
            <label class="control-label" for="sends_to">Send to:</label>
            <div class="controls">
	      <select id="sends_to" name="sends_to">
	      <option value="">--Select a destination--</option>
	      {% for server in m.search[{node_type_server node_type='node_type_server'}] %}
	          <option value={{ server.id }} {% ifequal id.sends_to server.id %} selected {% endifequal %}>{{ m.rsc[server.id].title }}</option>
	      {% endfor %}
	      </select>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="port">Port:</label>
            <div class="controls">
              <input type="text" class="input-xmini" id="port" name="port" value="{{id.port}}">
            </div>
          </div>
          <div class="control-group">
            <button type="submit" class="btn btn-primary pull-right">Save changes</button>
	  </div>
	  </div>
      </form>
