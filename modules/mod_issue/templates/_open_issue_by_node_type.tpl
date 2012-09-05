        <table class="table table-striped table-bordered table-condensed">
        <thead>
          <th>Class</th><th width="25%" class="center">Tickets</th>
        </thead>
        </tbody>
          {% for id in issues %}
          <tr>
            <td><a href="{% url node_list %}?node_type={{id.node_type_id}}">{{ id.node_type_id.title }}</a></td>
            <td class="center">{{ id.total }}</td>
          </tr>
          {% endfor %}
        </tbody>
        </table>
