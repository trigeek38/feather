	  <div class="control-group">
            <label class="control-label" for="node_status_id">Status:</label>
            <div class="controls">
              <select id="node_status_id" name="node_status_id">
                {% for title, node_status_id in m.search[{all_bytitle cat="node_status"}] %}
                  <option value={{node_status_id}} {% ifequal id.node_status_id node_status_id %} selected {% endifequal %}>{{ title }}</option>
                {% endfor %}
              </select>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="department_id">Department:</label>
            <div class="controls">
              <select id="department_id" name="department_id">
                {% for title, department_id in m.search[{all_bytitle cat="department"}] %}
                  <option value={{department_id}} {% ifequal id.department_id department_id %} selected {% endifequal %}>{{ title }}</option>
                {% endfor %}
              </select>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="node_type_id">Node Type:</label>
            <div class="controls">
              <select id="node_type_id" name="node_type_id">
                  <option value="">--Select Type--</option>
                {% for title, node_type_id in m.search[{all_bytitle cat="node_type"}] %}
                  <option value={{node_type_id}} {% ifequal id.node_type_id node_type_id %} selected {% endifequal %}>{{ title }}</option>
                {% endfor %}
              </select>
            </div>
          </div>
	  <div id="node-sub-type-select">
	  {% if id %}
            <div class="control-group">
               <label class="control-label" for="node_sub_type_id">Node Sub Type:</label>
               <div class="controls">
                 <select id="node_sub_type_id" name="node_sub_type_id">
                   {% for node_sub_type_id in m.search[{query hassubject=[id.node_type_id,'children'] sort='pivot_title'}] %}
                     <option value={{node_sub_type_id}} {% ifequal id.node_sub_type_id node_sub_type_id %} selected {% endifequal %} >{{ node_sub_type_id.title }}</option>
                   {% endfor %}
                 </select>
               </div>
             </div>
	   {% else %}
              <div class="control-group">
                 <label class="control-label" for="node_sub_type_id">Node Sub Type:</label>
                 <div class="controls">
                   <select id="node_sub_type_id" name="node_sub_type_id">
                     <option value="">--Select Parent--</option>
                   </select>
                </div>
              </div>
	    {% endif %}
	  </div>
          <div class="control-group">
            <label class="control-label" for="manufacturer_id">Manufacturer:</label>
            <div class="controls">
              <select id="manufacturer_id" name="manufacturer_id">
                {% for title, manufacturer_id in m.search[{all_bytitle cat="manufacturer"}] %}
                  <option value={{manufacturer_id}} {% ifequal id.manufacturer_id manufacturer_id %} selected {% endifequal %}>{{ title }}</option>
                {% endfor %}
              </select>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label" for="title">Title:</label>
            <div class="controls">
              <input type="text" class="input-medium" id="title" name="title" value="{{id.title}}">
            </div>
          </div>

          <div class="control-group">
            <label class="control-label" for="hostname">Hostname:</label>
            <div class="controls">
              <input type="text" class="input-medium" id="hostname" name="hostname" value="{{id.hostname}}">
            </div>
          </div>

          <div class="control-group">
            <label class="control-label" for="model">model:</label>
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
            <label class="control-label" for="warranty">Warranty:</label>
            <div class="controls">
              <input type="text" class="input-medium" id="warranty" name="warranty" value="{{id.warranty|date:"Y-m-d"}}">
            </div>
          </div>

          <div class="control-group">
            <label class="control-label" for="sends_to">Sends To:</label>
            <div class="controls">
              <input type="text" class="input-medium" id="sends_to" name="sends_to" value="{{id.sends_to}}">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="oct1">Oct 1:</label>
            <div class="controls">
              <input type="text" class="input-small" id="oct1" name="oct1" value="{{id.oct1}}">
              <input type="text" class="input-small" id="oct2" name="oct2" value="{{id.oct2}}">
              <input type="text" class="input-small" id="oct3" name="oct3" value="{{id.oct3}}">
              <input type="text" class="input-small" id="oct4" name="oct4" value="{{id.oct4}}">
            </div>
          </div>

          <div class="control-group">
            <label class="control-label" for="summary">Description:</label>
            <div class="controls">
              <textarea class="input-xlarge" id="summary" name="summary" rows="3">{{id.summary}}</textarea>
            </div>
          </div>
     {% wire id="node_type_id" type="change"
        action={ update target="node-sub-type-select" template="_node_sub_type_select.tpl" }
     %}
     {% validate id="title" type={presence} %}
<script>
	$(function() {
		$( "#warranty" ).datepicker({ 
                                             dateFormat: "yy-mm-dd",
                                             changeYear: true 
                                            });
	});
	</script>



