{% wire id="open-global-chat" action={emit signal={open_global_chat session=m.acl.user}} %}
<button style="display:none;" id="open-global-chat">Chat Room</button>
{% button text="Chat Room" class="button" action={emit signal={check_chat_dialog}} %}
{% wire action={connect signal={insert_new_message} action={insert_bottom target="global-chat-message" template="_global_chat_message.tpl"}} %}
