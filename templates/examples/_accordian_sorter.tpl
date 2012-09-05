<div class="accordion" id="faq-accordion">
    {% for faq in m.search[{search_faq}] %}
    <div class="accordion-group"  id="sort-faq-{{faq.id}}">
      <div class="accordion-heading">
      {# if m.acl.user|visible #}
          {% wire id=["edit-faq", faq.id]|join:"-" action={update target="faq-div" template="_edit_faq.tpl" faq=faq.id} %}
          {% wire id=["delete-faq", faq.id]|join:"-" action={confirm text="Delete the FAQ?" postback={delete_faq id=faq.id} delegate="mod_help"} %}
                <a href="#" class="pull-right" style="margin:5px;" id="delete-faq-{{faq.id}}"><i class="icon-remove"></i> Delete</a>
                <a href="#" class="pull-right" style="margin:5px;" id="edit-faq-{{faq.id}}"><i class="icon-edit"></i> Edit</a>
            {# endif #}
          <a class="accordion-toggle" data-toggle="collapse" data-parent="#faq-accordion" href="#collapse-{{faq.id}}">
            {{forloop.counter}}. {{faq.id.title}}
          </a>
          {% sortable id=["sort-faq",faq.id]|join:"-" tag=faq.id delegate="mod_help" %}
        </div>
        <div id="collapse-{{faq.id}}" class="accordion-body collapse">
          <div class="accordion-inner">
            {{faq.id.body}}
          </div>
        </div>
      </div>
    {% endfor %}
    </div>
