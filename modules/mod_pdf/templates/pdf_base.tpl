<!DOCTYPE HTML>
<html>
  <head>
    <style media="all">
      * { margin: 0; padding: 0;}
      
      /* PDF/Print style */
      @page { 
        size: US-Letter portrait;
        margin: 10px;

        @bottom-right {
          content: counter(page);
          font-size: 12px;
          font-style: italic;
        }
      }

      /* HTML PDF VIEWER */
      #pdf-viewer { display: none; }

      /* General */
      html, body {
        min-height: 100%;
      }

      body {
        color: black; 
        font-family: arial, sans-serif; 
        font-size: 12px; 
        line-height: 14px;
      }

      h2 {
        color: #255697; 
        font-family: arial, sans-serif; 
        font-size: 18px; 
        line-height: 24px;
        margin-top: 0.8em;
        margin-bottom: 0.8em;
      }
      
      p {
        margin-bottom: 0.8em;
      }

      /* Pages */
      .page {
        width: 650px;
        min-height: 684px;
        margin: 0 auto;
        page-break-after: always;
        border: 1px solid white; /* wkhtmltopdf hack */
      }

      /* Pages */
      .page-landscape {
        width: 950px;
        min-height: 684px;
        margin: 0 auto;
        page-break-after: always;
        border: 1px solid white; /* wkhtmltopdf hack */
      }

table.gridtable {
	font-family: verdana,arial,sans-serif;
	font-size:11px;
	color:#333333;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
}
table.gridtable th {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #666666;
	background-color: #dedede;
}
table.gridtable td {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #666666;
	background-color: #ffffff;
}
    </style>
</head>
<body>
    
{% block content %}
<div class="page">
  <h1>Add content by extending this template.  User block content to replace me! </h1>
</div>
{% endblock %}
    
</body>
</html> 
