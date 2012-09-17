<?xml version="1.0" encoding="UTF-8"?>
<Response>
{% for id, rank in m.search[{fulltext text=from}] %}
        {{ [q.Body, id]|sms }} 
{% endfor %}
</Response>

