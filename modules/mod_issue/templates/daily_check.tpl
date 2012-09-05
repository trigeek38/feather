{% extends "base.tpl" %}
{% block content %}
    <div class="page-header">
        <h1>Daily Checks</h1>
    </div>
    <h3 class="alert alert-notice">LTA</h3>
        {% for id in m.search[{search_nodes node_sub_type_id=m.rsc.node_sub_type_lta.id}] %}
	    <div>{{m.rsc[id.id].title}}</div>
	    <form class="form-horizontal">
              <div class="control-group">
                 <label class="control-label" for="comments">Comments:</label>
                 <div class="controls">
                    <textarea class="input" placeholder="Comments" name="comments" id="comments"></textarea>
                 </div>
              </div>
              <div class="control-group">
                 <label class="control-label" for="hrs">hrs:</label>
                 <div class="controls">
                    <input type="text" class="input-small" placeholder="hrs" name="hrs" id="hrs">
                 </div>
              </div>
              <div class="control-group">
                 <div class="controls">
                    <button type="submit" class="btn">Post</button>
                 </div>
              </div>
            </form>
	{% endfor %}
    <h3 class="alert alert-notice">MTA</h3>
        <ul>
        {% for id in m.search[{search_nodes node_sub_type_id=m.rsc.node_sub_type_mta.id}] %}
	    <li>{{id.title}}</li>
	{% endfor %}
	</ul>
    <h3 class="alert alert-notice">AP</h3>
        <ul>
        {% for id in m.search[{search_nodes node_sub_type_id=m.rsc.node_sub_type_ap.id}] %}
	    <li>{{id.title}}</li>
	{% endfor %}
	</ul>
    <h3 class="alert alert-notice">MiniAP</h3>
        <ul>
        {% for id in m.search[{search_nodes node_sub_type_id=m.rsc.node_sub_type_mini_ap.id}] %}
	    <li>{{id.title}}</li>
	{% endfor %}
	</ul>
    <h3 class="alert alert-notice">Image Router</h3>
        <ul>
        {% for id in m.search[{search_nodes node_sub_type_id=m.rsc.node_sub_type_image_router.id}] %}
	    <li>{{id.title}}</li>
	{% endfor %}
	</ul>
{% endblock %}
