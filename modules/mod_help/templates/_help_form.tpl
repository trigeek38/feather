  <div class="control-group">
    <label class="control-label" for="title">Question</label>
    <div class="controls">
      <input type="text" class="input-xxlarge" placeholder="How-To" id="title" name="title" value="{{rscid.title}}">
    </div>
  </div>
  <div class="control-group">
  <label class="control-label" for="html_body">Answer</label>
    <div class="controls">
      <textarea type="text" rows="18" class="input-xxlarge" placeholder="Answer" id="html_body" name="html_body">{{rscid.body}}</textarea>
    </div>
  </div>
{% wire type="load" action={script script="tinyMCE.init({ mode : 'textareas' ,  onchange_callback: 'myCustomOnChangeHandler' });"} %}
<script>
function myCustomOnChangeHandler(inst) {
        tinyMCE.triggerSave(); 
}
</script>
