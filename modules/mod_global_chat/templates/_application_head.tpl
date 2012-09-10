{% wire action={connect signal={open_global_chat session=m.acl.user} action={dialog_open title="Chat Room" template="_global_chat.tpl" width="300"}} %}
{% wire action={connect signal={check_chat_dialog} action={script 
                                                            script="var title=$('.ui-dialog-title').html();
                                                                    if (title != 'Chat Room')
                                                                    { 
                                                                      $('#open-global-chat').trigger('click');
                                                                    }"
                                                          }
               } %}
