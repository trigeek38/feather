<?xml version="1.0" encoding="UTF-8"?>
<Response>
    {% ifequal q.Digits 1 %}
        <Say>I will now connect you to the conference line</Say>
        <Dial>
            <Conference>1234</Conference>
        </Dial>
     {% else %}
        <Say>Goodbye</Say>
        <Hangup/>
     {% endifequal %}
</Response>
