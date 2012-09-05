         <div class="control-group">
            <label class="control-label" for="node_sub_type_id">Category: <span class="label label-important">(required)</span></label>
            <div class="controls">
              <select id="node_sub_type_id" name="node_sub_type_id">
	        {% if q.triggervalue %}
                {% for id in m.search[{query hassubject=[q.triggervalue,'children'] sort='pivot_title'}] %}
                  <option value={{id}}>{{ id.title }}</option>
                {% endfor %}
		{% else %}
                  <option value="">--Select Parent--</option>
		{% endif %}
              </select>
            </div>
          </div>

