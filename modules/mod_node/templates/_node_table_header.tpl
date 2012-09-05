{% ifequal q.qorder "desc" %}
    <a href="{% url node_list %}?qsort={{field}}&qorder=asc&node_type={{ q.node_type }}&node_sub_type={{q.node_sub_type}}">{{ label }}</a>
{% else %}
    <a href="{% url node_list %}?qsort={{field}}&qorder=desc&node_type={{ q.node_type }}&node_sub_type={{ q.node_sub_type }}">{{ label }}</a>
{% endifequal %}

