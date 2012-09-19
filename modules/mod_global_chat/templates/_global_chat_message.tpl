<div>
  <strong>
    {% ifequal m.acl.user  m.signal[signal].userid %}
      You :
    {% else %}
      {{ m.signal[signal].userid.name_first}} :
    {% endifequal %}
  </strong> 
  {{ m.signal[signal].msg }}
</div>
