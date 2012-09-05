{% wire id="issue-complete" type="submit" postback={mark_issue_complete id=id} delegate="mod_issue" %}
<form id="issue-complete" name="issue-complete" action="postback" method="POST" class="form-horizontal">

      <div class="control-group">
          <!-- Textarea -->
          <label class="control-label">Solution</label>
          <div class="controls">
            <div class="textarea">
                  <textarea type="" class="" id="issue_solution2" name="issue_solution2">{{ id.issue_solution }}</textarea>
            </div>
          </div>
      </div>
      <div class="control-group">
          <!-- Text input-->
          <label class="control-label" for="input01">Complete Date</label>
          <div class="controls">
            <input type="text" placeholder="placeholder" class="input-small" id="complete_date2" name="complete_date2" value={{ id.complete_date|date:"Y-m-d"}}>
            <input type="text" placeholder="placeholder" class="input-small" id="complete_time2" name="complete_time2" value={{ id.complete_date|date:"H:i"}}>
            <p class="help-block"></p>
          </div>
      </div>

    <button type="submit" class="btn btn-primary">Update</button>
</form>
{% wire action={script script="$( '#complete_date2' ).datepicker({
                                             dateFormat: 'yy-mm-dd',
                                             changeYear: true
                                            });"} %}
{% validate id="complete_date2" type={presence} %}
{% validate id="complete_time2" type={presence} %}
{% validate id="issue_solution2" type={presence} %}
                                   
