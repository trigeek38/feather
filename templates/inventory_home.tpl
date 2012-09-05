{% extends "base.tpl" %}

{% block chapeau %}
  <h2>Inventory Home</h2>
{% endblock %}
{% block content %}
<div class="" id="inventory_main">
    <h3>List of thing on this page</h3>
    <ul>
        <li>Total active items</li>
        <li>Items with upcoming warranty</li>
        <li>Items with upcoming contract</li>
        <li>Links by Type with count of active</li>
	<li>Links to items with open work orders</li>
    </ul>
</div>
<div>
    {% include "node_form.tpl" %}
</div>

{% endblock %}
