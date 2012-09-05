{% extends "base.tpl" %}
{% block html_head_extra %}

<link rel='stylesheet' type='text/css' href='/lib/css/fullcalendar.css' />
<link rel='stylesheet' type='text/css' href='/lib/css/fullcalendar.print.css' media='print' />
<script type='text/javascript' src='/lib/js/fullcalendar/fullcalendar.min.js'></script>
<script type='text/javascript'>

$(document).ready(function() {
		$('#calendar').fullCalendar({
		       defaultView: "{{ m.rsc[m.acl.user.id].calendar_view|default:'month' }}",
                       buttonText: {
                                agendaWeek: "agenda week",
                                agendaDay: "agenda day"
                       },
		       weekends: true,
                        loading: function(bool) {
                                if (bool) $('#loading').show();
                                else $('#loading').hide();
                        },
 
			header: {
				left: 'prev,next today',
				center: 'title',
				right: 'month,basicWeek,basicDay,agendaWeek,agendaDay'
			},

			editable: true,
	                disableDragging: true,
                        eventSources: [
			 {% if not q.issue_open and not q.issue_closed and not q.project and not q.pm %}
			     {% if m.rsc[m.acl.user.id].open_wo %} 
			       {% wire action={script script="$('input[name=issue_open]').attr('checked', true);"} %}
			       { 
                                 url: '/api/issue/open?status=false',
                                 textColor: '#B94A48',   // an option!
                                 color: '#F2DEDE' // an option!
                               },
			     {% endif %}
			     {% if m.rsc[m.acl.user.id].closed_wo %} 
			       {% wire action={script script="$('input[name=issue_closed]').attr('checked', true);"} %}
                               {
                                 url: '/api/issue/open?status=true',
                                 textColor: '#468847',   // an option!
                                 color: '#DFF0D8' // an option!
                               },
			     {% endif %}
			     {% if m.rsc[m.acl.user.id].open_project %} 
			       {% wire action={script script="$('input[name=project]').attr('checked', true);"} %}
                               {
                                 url: '/api/issue/project?status=false',
                                 textColor: '#F89406',   // an option!
                                 color: '#FCF8E3' // an option!
                               },
			     {% endif %}
			     {% if m.rsc[m.acl.user.id].open_pm %} 
			       {% wire action={script script="$('input[name=pm]').attr('checked', true);"} %}
                               {
                                 url: '/api/issue/pm?status=false',
                                 textColor: '#3A87AD',   // an option!
                                 color: '#D9EDF7' // an option!
                               },
			     {% endif %}
			 {% else %}
                           {% ifequal q.issue_open 'true' %}
                               {
                                 url: '/api/issue/open?status=false',
                                 textColor: '#B94A48',   // an option!
                                 color: '#F2DEDE' // an option!
                               },
                           {% endifequal %}    
                           {% ifequal q.issue_closed 'true' %}
                               {
                                 url: '/api/issue/open?status=true',
                                 textColor: '#468847',   // an option!
                                 color: '#DFF0D8' // an option!
                               },
                           {% endifequal %}    
                           {% ifequal q.project 'true' %}
                               {
                                 url: '/api/issue/project?status=false',
                                 textColor: '#F89406',   // an option!
                                 color: '#FCF8E3' // an option!
                               },
                           {% endifequal %}    
                           {% ifequal q.pm 'true' %}
                               {
                                 url: '/api/issue/pm?status=false',
                                 textColor: '#3A87AD',   // an option!
                                 color: '#D9EDF7' // an option!
                               },
                           {% endifequal %}
			   {% endif %}
                               {
                                 events: [
                                   {
                                     title: 'Default Event',
                                     start: '2011-08-21 12:00:00',
                                     end: '2011-08-21 16:00:00',
                                     allDay: false,
                                   }
                                 ]
                               }
		        ]
		
		});
		
	});

</script>
<style type='text/css'>

	#calendar {
		width: 900px;
		margin: 0 auto;
		}

</style>
{% endblock %}
{% block content %}
<div class="breadcrumb">
<form class="form form-inline" action="" method="GET">
        <input type="checkbox" id="issue_open" name="issue_open" value="true" {% ifequal q.issue_open 'true' %} checked {% endifequal %}>
            <span class="label alert alert-error">Open Work Orders</span>
        <input type="checkbox" id="issue_closed" name="issue_closed" value="true" {% ifequal q.issue_closed 'true' %} checked {% endifequal %}>
            <span class="label alert alert-success">Closed Work Orders</span>
        <input type="checkbox" id="project" name="project" value="true" {% ifequal q.project 'true' %} checked {% endifequal %}>
            <span class="label alert alert-warning">Open Projects</span>
        <input type="checkbox" id="pm" name="pm" value="true" {% ifequal q.pm 'true' %}checked {% endifequal %}>
            <span class="label alert alert-info">Open PMs</span>
      <button type="submit" class="btn btn-success"><i class="icon-filter"></i> Apply</button>
</form>
</div>

<div id='calendar'></div>
  </div>

{% endblock %}
