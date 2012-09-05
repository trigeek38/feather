         <div class="control-group">
            <label class="control-label" for="node_type_id">Node Type:</label>
            <div class="controls">
              <select id="select01" name="node_type_id">
                {% for id in m.search[{query hassubject=[q.triggervalue,'children'] sort='pivot_title'}] %}
                  <option value={{id}}>{{ id.title }}</option>
                {% endfor %}
              </select>
            </div>
          </div>

