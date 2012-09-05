        <table class="table table-striped table-bordered table-condensed">
        <thead>
          <th>Category</th>
          <th>Class</th>
	  <th width="25%" class="center">Tickets</th>
        </thead>
        </tbody>
          {% for id in m.search[{issue_count_by_node_sub_type is_complete='false' issue_type_id = 'issue_type_project'}] %}
          <tr>
            <td><a href="{% url node_list %}?node_type={{id.node_sub_type_id.s.children[1].id}}&node_sub_type={{id.node_sub_type_id}}">{{ id.node_sub_type_id.title }}</a></td>
            <td>{{ id.node_sub_type_id.s.children[1].title }}</td>
            <td class="center">{{ id.total }}</td>
          </tr>
          {% endfor %}
        </tbody>
        </table>
