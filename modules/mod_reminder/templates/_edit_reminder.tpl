<form class="form-horizontal" id="edit-reminder-form" method="POST" action="postback">
  <div class="control-group">
    <label class="control-label" for="reminder_title">{_ Title _}</label>
    <div class="controls">
      <input type="text" id="reminder_title" name="reminder_title" value="{{remid.title}}" />
      {% validate id="reminder_title" type={presence} type={length minimum="5" maximum="35"} %}
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="reminder_message">{_ Message _}</label>
    <div class="controls">
      <textarea id="reminder_message" name="reminder_message">{{remid.summary}}</textarea>
      {% validate id="reminder_message" type={presence} type={length maximum="200"} %}
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" >{_ Date Time _}</label>
    <div class="controls">
      <input type="text" style="width:80px" name="dt:ymd:1:date" class="do_datepicker" value="{{remid.date_end|time_diff:diff|date:'Y-m-d'}}"/>
      <input type="time" style="width:60px" name="dt:hi:1:date" value="{{remid.date_end|time_diff:diff|date:'H:i'}}"/>
      <p class="help-block">Date:yyyy-mm-dd, Time:hh:mm(Military)</p>
    </div>
  </div>
  <div class="control-group">
    <button class="btn" type="submit">{_ Save _}</button>
  </div>
</form>
{% wire id="edit-reminder-form" type="submit" postback={edit_reminder remid=remid diff=diff} delegate="resource_reminder" %}
