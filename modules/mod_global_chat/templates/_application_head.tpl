{% wire action={connect signal={check_chat_win} action={script script="
                                                                           try {
                                                                             if (chatwin.closed) { 
                                                                               chatwin = window.open('/global/chat', 'GlobalChat', 'height=500,width=300');
                                                                             }
                                                                           }
                                                                           catch(err) {
                                                                             chatwin = window.open('/global/chat', 'GlobalChat', 'height=500,width=300');
                                                                           }"
                                                          }
               } %}
