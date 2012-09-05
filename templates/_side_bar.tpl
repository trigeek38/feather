<h3>Modules</h3>
    <div>
    <a href="{% url node_home %}">Inventory</a>
    </div>
    <div>
    <a href="{% url issue_home %}">Issues</a>
    </div>
<h3>Quick Add</h3>
    <div><a href="#" id="add_mfg">Manufacturer</a></div>
    {% wire id="add_mfg" action={dialog_open title="Add Manufacturer" template="_quick_add_mfg.tpl"} %}
    <div><a href="#" id="add_class">Equipment Class</a></div>
    {% wire id="add_class" action={dialog_open title="Add Class" template="_quick_add_class.tpl"} %}
    <div><a href="#" id="add_category">Equipment Category</a></div>
    {% wire id="add_category" action={dialog_open title="Add Category" template="_quick_add_category.tpl"} %}

<hr/>
<h3>My Stuff</h3>
    <div>
    <a href="{% url profile_detail %}">Profile</a>
    </div>
