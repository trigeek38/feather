<table class="table table-bordered .table-condensed">
  <thead>
    <tr>
      <th>Requested By</th>
      <th>Date/Time</th>
      <th>Assigned to</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><input type="text" class="input-medium" id="requested_by" name="requested_by"></td>
      <td><input type="text" class="input-medium" placeholder="yyyy-mm-dd" id="request_date" name="request_date">
          <input type="text" class="input-small" placeholder="hh:mm" id="request_time" name="request_time"></td>
      <td> 
            <select class="input-medium" id="assigned_id" name="assigned_id">
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
      </td>
    </tr>
    <tr>
      <td colspan="3"><h4>Details:</h4><textarea rows='3' class="input-xxlarge" id="issue_detail" name="issue_detail"></textarea></td>
    </tr>
  </tbody>
</table>
<input type="hidden" id="rsc_id" name="rsc_id" value="{{ id }}">
<input type="hidden" id="issue_type_id" name="issue_type_id" value={{ m.rsc.issue_type_work_order.id }}>

{% validate id="rsc_id" type={presence} %}
{% validate id="issue_type_id" type={presence} %}
{% validate id="request_date" type={presence} %}
{% validate id="request_time" type={presence} %}
{% validate id="issue_detail" type={presence} %}
{% validate id="requested_by" type={presence} %}
<script>
        $(function() {
                $( "#request_date" ).datepicker({ 
                                             dateFormat: "yy-mm-dd",
                                             changeYear: true 
                                            });
        });
</script>
