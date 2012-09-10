<div id="global-chat-message" style="height:250px">
</div>
<form id="global-chat-form" class="form-inline" method="post" action="postback">
  <input id="chat_message" name="chat_message" class="input-medium" type="text" value=""/>
  <button class="btn">Send</button>
</form>
{% wire id="global-chat-form" type="submit" postback={new_message userid=m.acl.user} delegate="mod_global_chat" %}
