      <div class="control-group">
          <!-- Select Basic -->
          <label class="control-label">Item</label>
          <div class="controls">
            <select class="input-large" id="rsc_id" name="rsc_id">
                {% for node in m.search[{query cat='node'}] %}
                    <option value="{{node.id}}" {% ifequal node.id id.rsc_id %} selected {% endifequal %}>{{node.title}}</option>
                {% endfor %}
            </select>
          </div>
      </div>

     <div class="control-group">
          <!-- Select Basic -->
          <label class="control-label">Issue Type</label>
          <div class="controls">
            <select class="input-large" id="issue_type_id" name="issue_type_id">
	        {% for issue_type in m.search[{query cat='issue_type'}] %}
                    <option value="{{issue_type.id}}" {% ifequal issue_type.id id.issue_type_id %} selected {% endifequal %}>{{issue_type.title}}</option>
		{% endfor %}
            </select>
          </div>
      </div>

      <div class="control-group">
          <!-- Textarea -->
          <label class="control-label">Details</label>
          <div class="controls">
            <div class="textarea">
                  <textarea type="" class="" id="issue_detail" name="issue_detail">{{ id.issue_detail }} </textarea>
            </div>
          </div>
      </div>

      <div class="control-group">
          <!-- Text input-->
          <label class="control-label" for="input01">Requsted By</label>
          <div class="controls">
            <input type="text" placeholder="placeholder" class="input-large" id="requested_by" name="requested_by" value="{{ id.requested_by }}">
            <p class="help-block"></p>
          </div>
      </div>

      <div class="control-group">
          <!-- Text input-->
          <label class="control-label" for="input01">Request Date</label>
          <div class="controls">
            <input type="text" placeholder="placeholder" class="input-small" id="request_date" name="request_date" value={{ id.request_date|date:"Y-m-d" }}>
            <input type="text" placeholder="placeholder" class="input-small" id="request_time" name="request_time" value={{ id.request_date|date:"H:i"}}>
            <p class="help-block"></p>
          </div>
      </div>

      <div class="control-group">
          <!-- Select Basic -->
          <label class="control-label">Assigned To</label>
          <div class="controls">
            <select class="input-large" id="assigned_id" name="assigned_id">
                <option value="">--Select Assignee--</option>
               {% for inhouse in m.rsc.servicers_inhouse.s.relation %}
               <option value="{{inhouse.id}}" {% ifequal inhouse.id id.assigned_id %} selected {% endifequal %}>{{ inhouse.title }}</option>
               {% endfor %}
               <option value="">--3rd Party--</option>
               {% for id in m.rsc.servicers_3rd_party.s.relation %}
               <option value="{{id}}">{{ id.title }}</option>
               {% endfor %}
            </select>
          </div>
      </div>
          <input type="checkbox" id="is_complete" name="is_complete" value="true" {% if id.is_complete %} checked {% endif %}>
          <span class="label ">Is closed?</span>

      <div class="control-group">
          <!-- Text input-->
          <label class="control-label" for="input01">Complete Date</label>
          <div class="controls">
            <input type="text" placeholder="placeholder" class="input-small" id="complete_date" name="complete_date" value={{ id.complete_date|date:"Y-m-d"}}>
            <input type="text" placeholder="placeholder" class="input-small" id="complete_time" name="complete_time" value={{ id.complete_date|date:"H:i"}}>
            <p class="help-block"></p>
          </div>
      </div>

      <div class="control-group">
          <!-- Textarea -->
          <label class="control-label">Solution</label>
          <div class="controls">
            <div class="textarea">
                  <textarea type="" class="" id="issue_solution" name="issue_solution">{{ id.issue_solution }} </textarea>
            </div>
          </div>
      </div>
    {% validate id="rsc_id" type={presence} %}
    {% validate id="issue_detail" type={presence} %}
    {% validate id="issue_type_id" type={presence} %}
    {% validate id="requested_by" type={presence} %}
    {% validate id="request_date" type={presence} %}
    {% validate id="request_time" type={presence} %}
<script>
        $(function() {
                $( "#request_date" ).datepicker({ 
                                             dateFormat: "yy-mm-dd",
                                             changeYear: true 
                                            });
                $( "#complete_date" ).datepicker({ 
                                             dateFormat: "yy-mm-dd",
                                             changeYear: true 
                                            });
        });
        </script>
