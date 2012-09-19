{% extends "base.tpl" %}

<div class="page-header">
   <h1>Profile <small>Home Page</small></h1>
</div>
{% block chapeau %}
{% endblock %}
{% block content %}
{% if m.acl.user %}
{% with m.rsc[m.acl.user.id] as user %}

{% wire id="profile-form" type="submit" postback={update_profile id=user.id} delegate="workorders" %}

<div class="page-header">
    <h1>{{ m.acl.user.id.title }}</h1>
{% include "_global_chat_button.tpl" %}
{% button class="btn" postback={convert_to_pdf} delegate="mod_pdf" %}
</div>
<form class="form-horizontal" id="profile-form" action="postback" method="POST">
  <div class="well">
  <h4>Contact Info</h4>
  <div class="control-group">
    <label class="control-label" for="email">Email</label>
    <div class="controls">
      <input type="text" id="email" name="email" placeholder="Email" value="{{user.email}}">
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="phone">Cell</label>
    <div class="controls">
      <input type="text" id="phone" name="phone" placeholder="phone" value="{{user.phone}}">
    </div>
  </div>
  {% include "_time_zone_select.tpl" %}
  </div>
  <div class="well">
  <h4>Calendar Defaults</h4>
  <div class="control-group">
    <label class="control-label" for="calendar_view">Default View:</label>
    <div class="controls">
      <select id="calendar_view" name="calendar_view">
          <option value="month" {% ifequal user.calendar_view "month" %} selected {% endifequal %}>Month</option>
          <option value="basicWeek" {% ifequal user.calendar_view "basicWeek" %} selected {% endifequal %}>Week</option>
          <option value="basicDay" {% ifequal user.calendar_view "basicDay" %} selected {% endifequal %}>Day</option>
          <option value="agendaWeek" {% ifequal user.calendar_view "agendaWeek" %} selected {% endifequal %}>Agenda Week</option>
          <option value="agendaDay" {% ifequal user.calendar_view "agendaDay" %} selected {% endifequal %}>Agenda Day</option>
      </select>
    </div>
  </div>
  <div class="control-group">
    <div class="controls">
      <label class="checkbox">
        <input type="checkbox" name="open_wo" id="open_wo" {% if user.open_wo %} checked {% endif %}> Show Open Work Orders 
      </label>
    </div>
  </div>
  <div class="control-group">
    <div class="controls">
      <label class="checkbox">
        <input type="checkbox" name="closed_wo" id="closed_wo" {% if user.closed_wo %} checked {% endif %}> Show Closed Work Orders 
      </label>
    </div>
  </div>
  <div class="control-group">
    <div class="controls">
      <label class="checkbox">
        <input type="checkbox" name="open_project" id="open_project" {% if user.open_project %} checked {% endif %}> Show Open Projects 
      </label>
    </div>
  </div>
  <div class="control-group">
    <div class="controls">
      <label class="checkbox">
        <input type="checkbox" name="open_pm" id="open_pm" {% if user.open_pm %} checked {% endif %}> Show Open PMs 
      </label>
    </div>
  </div>
  </div>
      <button type="submit" class="btn btn-primary">Save</button>
</form>

{% endwith %}

{% else %}
  <div class="alert alert-error"><h2>Please log in to see this page</h2></div>

{% endif %}


{% endblock %}
