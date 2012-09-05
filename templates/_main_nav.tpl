    <div class="container">
    <div class="navbar">
      <div class="navbar-inner">
        <div class="container">
          <a class="brand" data-toggle="modal" href="#5NinesModal">5Nines</a>
          <div class="btn-group pull-right">
            <a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
              <i class="icon-user"></i> {{m.acl.user.title}}
              <span class="caret"></span>
            </a>
            <ul class="dropdown-menu">
              <li><a href="{% url profile_detail %}">Profile</a></li>
              <li class="divider"></li>
	      {% if m.acl.user %}
              <li><a href="{% url logoff %}">Sign Out</a></li>
	      {% else %}
              <li><a href="{% url logon %}">Sign In</a></li>
	      {% endif %}
            </ul>
          </div>
            <ul class="nav">
              <li class="active"><a href="#">Home</a></li>
              <li><a href="#about">About</a></li>
              <li><a href="#contact">Contact</a></li>
 <li class="dropdown">
    <a href="#"
          class="dropdown-toggle"
          data-toggle="dropdown">
          Help
          <b class="caret"></b>
    </a>
    <ul class="dropdown-menu">
      <li><a href="{% url faq %}">FAQ</a></li>
      <li><a href="{% url howto %}">How-To</a></li>
    </ul>
  </li>
            </ul>
        </div>
      </div>
    </div>
    </div>
<div class="modal hide" id="5NinesModal">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal">×</button>
    <h3>5Nines LLC</h3>
  </div>
  <div class="modal-body">
          <ul id="myTab" class="nav nav-tabs">
            <li class="active"><a href="#about" data-toggle="tab">About Us</a></li>
            <li><a href="#address" data-toggle="tab">Address</a></li>
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown">People <b class="caret"></b></a>
              <ul class="dropdown-menu">
                <li><a href="#jeff" data-toggle="tab">Jeff Bell</a></li>
                <li><a href="#sanket" data-toggle="tab">Sanket Gawade</a></li>
              </ul>
            </li>
          </ul>
          <div id="myTabContent" class="tab-content">
            <div class="tab-pane fade in active well" id="about">
	    <p>We provide enterprise network and system managment services, as well as DICOM/HL7/EHR consulting and custom software development. We design support systems and software to ensure 99.999% uptime and maintain business continuity.  We are <img src="http://workorders:8000/lib/img/5nines_logo_275_55.png" alt="" width="135" height="27" /></p>
            </div>
            <div class="tab-pane fade well" id="address">
	    <h3>Our locations</h3>
	    <address>
	        <strong>5Nines LLC</strong>
		<br>5550 NW 111th Blvd
		<br>Gainesville, FL 32653
	    </address>
	    <hr>
	    <address>
	        <strong>UF & Shands</strong>
		<br>1600 SW Archer Road
		<br>Room AG117
		<br>SW Archer Road
		<br>Gainesville, FL 32610
	    </address>
            </div>
            <div class="tab-pane fade" id="jeff">
	    <div class="well">
	        <strong>Jeff Bell - Owner</strong>
		<br>
		<blockquote>I'm a graduate of the Univeristy of Florida, class of '95. I love technology and making thing better.
		            I am marrie and have two wonderful children, a boy and a girl.  I love the Gators and I am an avid 
			    racquetball player.
		</blockquote>
		<hr>
		<h3>I can be reached at</h3>
		<p>Twitter: @trigeek38</p>
		<p>Google+: jeff.5nines@gmail.com</p>
		<p>Email: jeff@5nineshq.com</p>
		<p>Cell: 352-246-9644</p>
		<br>
            </div>
            </div>
            <div class="tab-pane fade" id="sanket">
	    <div class="well">
                <strong>Sanket Gawade - Engineer</strong>
                <br>
                <blockquote>I'm a graduate of Southern Methodist University, Master of Computer Science, class of '2010. 
                            I love technology and making thing better.  
                </blockquote>
                <hr>
                <h3>I can be reached at</h3>
                <p>Twitter: @sanketgawade7</p>
                <p>Google+: sanketgawade7@gmail.com</p>
                <p>Email: sanket@5nineshq.com</p>
                <p>Cell: 352-219-2940</p>
                <br>

	    </div>
            </div>
          </div>
  </div>
  <div class="modal-footer">
         &copy 5Nines LLC 2012
  </div>
</div>

