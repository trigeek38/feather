<!DOCTYPE html>
<html lang="en">
  <head>
    <title>{% block title %}{% endblock %} &mdash; {{ m.config.site.title.value }}</title>
	<!--
		Website built by:
		Jeff Bell
		Proudly powered by: Zotonic, the Erlang CMS <http://www.zotonic.com>
	-->
    <meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
    <meta name="author" content="Jeff Bell &copy; 2012" />
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <title>5Nines Base</title>

    <!-- Le styles -->
    <link href="/lib/css/site.css" rel="stylesheet">
    <link href="/lib/css/bootstrap.css" rel="stylesheet">

    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="../assets/ico/favicon.ico">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="../assets/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="../assets/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="../assets/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="../assets/ico/apple-touch-icon-57-precomposed.png">

	{% all include "_html_head.tpl" %}
	{% all include "_application_head.tpl" %}

	{% lib "css/zp-menu.css" "css/jquery.loadmask.css" %}
	{% lib "css/zp-dialog.css" 
	       "css/jquery-ui-1.8.16.custom.css"
	       "css/jquery-ui.1.8.16.ie.css"
	       "css/jquery.loadmask.css"
	       "css/zp-growl.css"
	       "css/DT_bootstrap.css"
	%}
	<!--[if IE]>{% lib "css/zp-ie.css" %}<![endif]-->
        <script src="/lib/js/jquery.js"></script>
	{% lib "js/apps/modernizr.js" 
               "js/apps/jquery-ui-1.8.11.min.js"
               "js/jquery.dataTables.min.js"
	       "js/DT_bootstrap.js"
	%}
	{% block html_head_extra %}{% endblock %}
</head>
<body class="{% block page_class %}page{% endblock %}">

    <section class="">
       <header class="clearfix">
           <a href="/"><img src="/lib/img/5nines_logo_275_55.png"></a>
        </header>
	{% include "_main_nav.tpl" %}
        <section id="content-area" class="container">

        {% block content_area %}
            <section id="sidebar" class="span2">
                {% block sidebar %}
                    {% include "_side_bar.tpl" %}
                {% endblock %}
            </section>

            <article id="content" class="span9">
                <div class="padding">
		{% block messages %}{% endblock %}
                {% block chapeau %}{% endblock %}
                    {% block content %}
						<!-- The default content goes here. -->
                    {% endblock %}
                </div>
            </article>

        {% endblock %}
        </section>

        <footer class="clearfix container">
			<nav class="left">{% menu id=id menu_id='footer_menu' %}</nav>
			<section class="right">
				<p class="footer-blog-title">{_ Website powered by _} <a href="http://zotonic.com">Zotonic</a> {{ m.config.zotonic.version.value }}.</p>
			</section>
		</footer>

    </section>

    {% lib 
			"js/apps/zotonic-1.0.js" 
			"js/apps/z.widgetmanager.js" 
			"js/modules/z.notice.js"
			"js/modules/z.jquery.dialog.js"
			"js/modules/livevalidation-1.3.js" 
			"js/modules/z.inputoverlay.js"
			"js/modules/jquery.loadmask.js"
                        "js/z.superfish.js" 
	%}
	
	{% block _js_include_extra %}{% endblock %}

    <script src="/lib/js/bootstrap.js"></script>
    <script type="text/javascript">
        $(function() { 
	    $.widgetManager(); });
	    $("rel[tooltip]").tooltip();
    </script>

	{% stream %}
        {% script %}

    {% all include "_html_body.tpl" %}
</body>
</html>
