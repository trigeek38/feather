         <form id="node-quick-add" action="postback" method="POST" class="form-horizontal well"> 
          <div class="control-group">
            <label class="control-label" for="node_type_id">Class: <span class="label alert-error">required</label>
            <div class="controls">
              <select id="node_type_id" name="node_type_id">
                  <option value="">--Select Type--</option>
                {% for title, node_type_id in m.search[{all_bytitle cat="node_type"}] %}
                  <option value={{node_type_id}} {% ifequal node_type_id node_type %} selected {% endifequal %} >{{ title }}</option>
                {% endfor %}
              </select>
            </div>
          </div>
          <div id="node-sub-type-select">
          {% if node_sub_type %}

            <div class="control-group">
            <label class="control-label" for="node_sub_type_id">Category: <span class="label alert-error">required</span></label>
            <div class="controls">
              <select id="node_sub_type_id" name="node_sub_type_id">
                {% if node_type %}
                {% for node_sub_type_id in m.search[{query hassubject=[node_type,'children'] sort='pivot_title'}] %}
                  <option value={{node_sub_type_id}} {% ifequal node_sub_type node_sub_type_id %} selected {% endifequal %} >{{ node_sub_type_id.title }}</option>
                {% endfor %}
                {% else %}
                  <option value="">--Select Parent--</option>
                {% endif %}
              </select>
            </div>
          </div>

          {% else %}

              <div class="control-group">
                 <label class="control-label" for="node_sub_type_id">Category: <span class="label alert-error">required</span></label>
                 <div class="controls">
                   <select id="node_sub_type_id" name="node_sub_type_id">
                     <option value="">--Select Parent--</option>
                   </select>
                </div>
              </div>

          {% endif %}

          </div>
          <div class="control-group">
            <label class="control-label" for="title">Title:<span class="label alert-error">required</span></label>
            <div class="controls">
              <input type="text" class="input-medium" id="title" name="title" value="{{id.title}}">
            </div>
          </div>

	  <div class="control-group">
            <label class="control-label" for="manufacturer_id">Manufacturer:<span class="label alert-error">required</span></label>
            <div class="controls">
              <select id="manufacturer_id" name="manufacturer_id">
                {% for title, manufacturer_id in m.search[{all_bytitle cat="manufacturer"}] %}
                  <option value={{manufacturer_id}}>{{ title }}</option>
                {% endfor %}
              </select>
            </div>
	    <div id="add_new"><a href="#" id="add_mfg">Add</a></div>
	    {% wire id="add_mfg" action={dialog_open title="add_new" template="_quick_add_mfg.tpl"} %}
          </div>

          <div class="control-group">
            <label class="control-label" for="model">Model:</label>
            <div class="controls">
              <input type="text" class="input-medium" id="model" name="model" value="{{id.model}}">
            </div>
          </div>
	  
          <div class="control-group">
            <label class="control-label" for="serial">Serial:</label>
            <div class="controls">
              <input type="text" class="input-medium" id="serial" name="serial" value="{{id.serial}}">
            </div>
          </div>

          <div class="control-group">
            <label class="control-label" for="room">Room:</label>
            <div class="controls">
              <input type="text" class="input-medium" id="room" name="room" value="{{id.room}}">
            </div>
          </div>

          <div class="control-group">
            <label class="control-label" for="summary">Description: <span class="label alert-error">required</span></label>
            <div class="controls">
              <textarea class="input-large" id="summary" name="summary" rows="3">{{id.title}}</textarea>
            </div>
          </div>
          <div class="control-group">
            <div class="controls">
              {% button text="Add" class="btn btn-primary" %} 
            </div>
          </div>
	  </form>
     {% validate id="title" type={presence} %}
     {% validate id="node_type_id" type={presence} %}
     {% validate id="manufacturer_id" type={presence} %}
     {% validate id="summary" type={presence} %}
     {% wire id="node_type_id" type='change' action={update target="node-sub-type-select" template="_node_sub_type_select.tpl"} %}
     {% wire id="node-quick-add" type="submit" postback={quick_add_node} delegate="mod_node" %}
