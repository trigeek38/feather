<form class="form-horizontal" id="add-reminder-form" method="POST" action="postback">
  <div class="control-group">
    <label class="control-label" for="reminder_title">{_ Title _}</label>
    <div class="controls">
      <input type="text" id="reminder_title" name="reminder_title"/>
      {% validate id="reminder_title" type={presence} type={length minimum="5" maximum="35"} %}
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="reminder_message">{_ Message _}</label>
    <div class="controls">
      <textarea rows="2" id="reminder_message" name="reminder_message"> </textarea>
      {% validate id="reminder_message" type={presence} type={length maximum="200"} %}
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">{_ Date Time _}</label>
    <div class="controls">
      <input type="text" style="width:80px" name="dt:ymd:1:date" class="do_datepicker"/>
      <input type="time" style="width:60px" name="dt:hi:1:date"/>
      <p class="help-block">Date:yyyy-mm-dd, Time:Hr:min (Military Time)</p>
    </div>
  </div>
  <div class="control-group">
    <button class="btn" type="submit">{_ Set Reminder_}</button>
  </div>
</form>
{% wire id="add-reminder-form" type="submit" postback={set_reminder id=id diff=diff} delegate="resource_reminder" %}
