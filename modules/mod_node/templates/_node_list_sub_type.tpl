    <div class="row">
      <div class="span4">
      <h3>Active Categories</h3>
        <table class="table table-striped table-bordered table-condensed">
        <thead>
          <th>Category</th>
          <th>Class</th>
	  <th width="25%" class="center">Count</th>
        </thead>
        </tbody>
          {% for id in m.search[{node_count_by_sub_type}] %}
          <tr>
            <td><a href="{% url node_list %}?node_type={{id.node_type_id}}&node_sub_type={{id.node_sub_type_id}}">{{ id.node_sub_type_id.title }}</a></td>
            <td>{{ id.node_type_id.title }}</td>
            <td class="center">{{ id.total }}</td>
          </tr>
          {% endfor %}
        </tbody>
        </table>
      </div>
      <div class="span4">
      <h3>Pending Work Orders</h3>
          {% include "_open_issue_by_node_sub_type.tpl" %}
      </div>
    </div>

