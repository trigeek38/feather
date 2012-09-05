    <div class="row">
      <div class="span4">
      <h3>Active Classes</h3>
        <table class="table table-striped table-bordered table-condensed">
        <thead>
          <th>Class</th><th width="25%" class="center">Active</th>
        </thead>
        </tbody>
          {% for id in m.search[{node_count_by_type}] %}
          <tr>
            <td><a href="{% url node_list %}?node_type={{id.node_type_id}}">{{ id.node_type_id.title }}</a></td>
            <td class="center">{{ id.total }}</td>
          </tr>
          {% endfor %}
        </tbody>
        </table>
      </div>
      <div class="span4">
      <h3>Pending Work Orders</h3>
          {% with m.search[{issue_count_by_node_type is_complete = 'false' issue_type_id = 'issue_type_work_order'}] as issues %}
          {% include "_open_issue_by_node_type.tpl" %}
	  {% endwith %}
      </div>
    </div>

