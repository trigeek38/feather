{% wire action={connect signal={open_global_chat session=m.acl.user} 
        action={script script="chatwin = window.open('global/chat', 'GlobalChat', 'height=500,width=300')"}} %}

{% wire action={connect signal={check_chat_dialog} action={script script="
                                                                           try {
                                                                             if (chatwin.closed) { 
                                                                               $('#open-global-chat').trigger('click');
                                                                             }
                                                                           }
                                                                           catch(err) {
                                                                             $('#open-global-chat').trigger('click');
                                                                           }"
                                                          }
               } %}

{% wire id="open-global-chat" action={emit signal={open_global_chat session=m.acl.user}} %}
<button style="display:none;" id="open-global-chat">Chat Room</button>
