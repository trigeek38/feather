{% wire id="edit_howto_form" type="submit" postback={edit_howto id=id} delegate="mod_help" %} 
{% wire id="cancel" action={redirect dispatch="howto_detail" id=id slug=id.slug} %}
<div class="well">
<a href="#" id="cancel" class="pull-right"><i class="icon-remove"></i> Cancel</a>
<form id="edit_howto_form" class="form-horizontal" action="postback" method="post">
  {% include "_help_form.tpl" rscid=id %}
  <div class="control-group">
    <div class="controls">
      <button type="submit" class="btn">Save</button>
    </div>
  </div>
</form>
</div>
