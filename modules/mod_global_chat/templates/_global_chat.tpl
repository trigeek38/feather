<!DOCTYPE html>
<html lang="en">
  <head>
    <meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
    <meta name="author" content="Jeff Bell &copy; 2012" />
    <meta name="author" content="Sanket Gawade &copy; 2012" />
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">

    <link href="/lib/css/bootstrap.css" rel="stylesheet">
        {% lib "css/zp-menu.css" "css/jquery.loadmask.css" %}
         <script src="/lib/js/jquery.js"></script>
        {% lib "js/apps/modernizr.js"
               "js/apps/jquery-ui-1.8.11.min.js"
        %}
</head>

<body>
  <div id="global-chat-message" style="height:450px">
  </div>
  <form id="global-chat-form" class="form-inline" method="post" action="postback">
    <input id="chat_message" name="chat_message" class="input-medium" type="text" value=""/>
    <button class="btn">Send</button>
  </form>
  {% wire id="global-chat-form" type="submit" postback={new_message userid=m.acl.user} delegate="mod_global_chat" %}
  {% wire action={connect signal={insert_new_message} action={insert_bottom target="global-chat-message" template="_global_chat_message.tpl"}} %}

  {% lib
         "js/apps/zotonic-1.0.js"
         "js/apps/z.widgetmanager.js"
  %}
  <script type="text/javascript">
    $(function() {
      $.widgetManager();
    });
  </script>
  {% stream %}
  {% script %}
</body>
</html>

