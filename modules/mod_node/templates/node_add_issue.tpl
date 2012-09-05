<div>
<form id="issue-form" action="postback" method="POST" class="form-horizontal">
  <div class="control-group">
      <label class="control-label" for="requested_by">Requested By:</label>
      <div class="controls">
          <input type="text" class="input-medium" id="requested_by" name="requested_by">
      </div>
  </div>
  <div class="control-group">
      <label class="control-label" for="request_date">Request Date:</label>
      <div class="controls">
      <input type="text" class="input-medium" placeholder="yyyy-mm-dd" id="request_date" name="request_date">
      </div>
  </div>
  <div class="control-group">
      <label class="control-label" for="request_time">Request Time:</label>
      <div class="controls">
          <input type="text" class="input-small" placeholder="hh:mm" id="request_time" name="request_time"></td>
      </div>
  </div>
  <div class="control-group">
      <label class="control-label" for="assigned_id">Assigned To:</label>
      <div class="controls">
            <select class="" id="assigned_id" name="assigned_id">
                <option value="">--Select Assignee--</option>
               {% for inhouse in m.rsc.servicers_inhouse.s.relation %}
               <option value="{{inhouse.id}}" {% ifequal inhouse.id id.assigned_id %} selected {% endifequal %}>
                             {{ inhouse.title }}
               </option>
               {% endfor %}
               <option value="">--3rd Party--</option>
               {% for id in m.rsc.servicers_3rd_party.s.relation %}
               <option value="{{id}}">{{ id.title }}</option>
               {% endfor %}
            </select>
      </div>
  </div>
  <div class="control-group">
      <label class="control-label" for="issue_detail">Details:</label>
      <div class="controls">
      <textarea rows='3' class="input-large" id="issue_detail" name="issue_detail"></textarea></td>
      </div>
  </div>
  <div class="form-actions">
      <button type="submit" class="btn btn-primary">Save changes</button>
      {% button text="cancel" class="btn" action={dialog_close} %}
  </div>
      <input type="hidden" id="rsc_id" name="rsc_id" value="{{ id }}">
      <input type="hidden" id="issue_type_id" name="issue_type_id" value={{ issue_type_id }}>
</form>
</div>

{% wire id="issue-form" type="submit" postback={add_issue} delegate="mod_issue" %}
{% wire id="issue-form" type="submit" postback={add_issue} delegate="mod_issue" %}
{% validate id="rsc_id" type={presence} %}
{% validate id="issue_type_id" type={presence} %}
{% validate id="request_date" type={presence} %}
{% validate id="request_time" type={presence} %}
{% validate id="issue_detail" type={presence} %}
{% validate id="requested_by" type={presence} %}
{% wire action={script script="$( '#request_date' ).datepicker({ 
                                             dateFormat: 'yy-mm-dd',
                                             changeYear: true 
                                            });"} %}

