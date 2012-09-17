{% extends "pdf_base.tpl" %}
   {% block content %}
     <p>{{ id.title }} </p>
     <p>{{ id.body|show_media }} </p>
   {% endblock %}

