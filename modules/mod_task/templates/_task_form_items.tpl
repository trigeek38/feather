      <div class="control-group">
          <!-- Textarea -->
          <label class="control-label">Action</label>
          <div class="controls">
            <div class="textarea">
                  <textarea type="" class="" id="task_detail" name="task_detail">{{ task.task_detail }}</textarea>
            </div>
          </div>
      </div>
      <div class="control-group">
          <!-- Text input-->
          <label class="control-label" for="completed_date">Complete Date</label>
          <div class="controls">
            <input type="text" placeholder="placeholder" class="input-small" id="completed_date" name="completed_date" value={{ task.completed_date|date:"Y-m-d"}}>
            <input type="text" placeholder="placeholder" class="input-small" id="completed_time" name="completed_time" value={{ task.completed_date|date:"H:i"}}>
            <p class="help-block"></p>
          </div>
      </div>
      <div class="control-group">
          <!-- Text input-->
          <label class="control-label" for="hours">Hours</label>
          <div class="controls">
            <input type="text" placeholder="hours" class="input-small" id="hours" name="hours" value={{ task.hours}}>
          </div>
      </div>
      <div class="control-group">
          <!-- Select Basic -->
          <label class="control-label">By</label>
          <div class="controls">
            <select class="input-large" id="user_id" name="user_id">
                <option value="">--Select Assignee--</option>
               {% for inhouse in m.rsc.servicers_inhouse.s.relation %}
               <option value="{{inhouse.id}}" {% ifequal inhouse.id task.user_id %} selected {% endifequal %}>{{ inhouse.title }}</option>
               {% endfor %}
               <option value="">--3rd Party--</option>
               {% for outside in m.rsc.servicers_3rd_party.s.relation %}
               <option value="{{outside.id}}" {% ifequal outside.id task.user_id %} selected {% endifequal %}>{{ outside.title }}</option>
               {% endfor %}
            </select>
          </div>
      </div>
{% wire action={script script="$( '#completed_date' ).datepicker({
                                             dateFormat: 'yy-mm-dd',
                                             changeYear: true
                                            });"} %}

