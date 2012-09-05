{% wire id="edit_faq_form" type="submit" postback={edit_faq id=faq} delegate="mod_help" %} 
{% wire id="cancel" action={update target="faq-div" text=""} %}
<div class="well">
<a id="cancel" class="pull-right"><i class="icon-remove"></i> Cancel</a>
<form id="edit_faq_form" class="form-horizontal" action="postback" method="post">
  {% include "_help_form.tpl" rscid=faq %}
  <div class="control-group">
    <div class="controls">
      <button type="submit" class="btn">Save</button>
    </div>
  </div>
</form>
</div>
