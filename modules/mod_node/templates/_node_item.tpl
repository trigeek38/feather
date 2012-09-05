      <tr>
      <td><a href="{% url node_detail id=id.id %}">
          {{id.id.title}}</a></td>
      <td>{{id.node_type_id.title}}</td>
      <td>{{id.node_sub_type_id.title}}</td>
      <td>{{m.rsc[id.id].room}}</td>
      <td>{{id.attached_to.title}}</td>
      <td>{{id.node_status_id.title}}</td>
      <td>{{ m.issue.count_pending_work_orders[id.id] }}</td>
      <td>{{ m.issue.count_pending_projects[id.id] }}</td>
      </tr>

