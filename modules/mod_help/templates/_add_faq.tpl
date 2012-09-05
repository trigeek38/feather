{% wire id="add_faq_form" type="submit" postback={add_faq} delegate="mod_help" %} 
{% wire id="cancel" action={update target="faq-div" text=""} %}
<div class="well">
<a href="#" id="cancel" class="pull-right"><i class="icon-remove"></i> Cancel</a>
<form id="add_faq_form" class="form-horizontal" action="postback" method="post">
  {% include "_help_form.tpl" %}
  <div class="control-group">
    <div class="controls">
      <button type="submit" class="btn">Add</button>
    </div>
  </div>
</form>
</div>
