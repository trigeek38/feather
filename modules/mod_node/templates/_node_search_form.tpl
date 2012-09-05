
<div class="autocomplete-wrapper">
<form method="get" action="/search" class="pull-right form-inline">
  Search:
  <input type="text" id="node" value=""/><br>
  <ul id="suggestions" class="suggestions-list"></ul>
  <input type="hidden" id="id" name="id" value="" />
  {% wire id="node" type="keyup"
          action={typeselect cat="node" 
                            target="suggestions"
                            action_with_id={with_args action={set_value target="id"} arg={value select_id}}
                            action={submit}} 
  %}
</form>
  </div>
