		<table class="table table-striped table-bordered table-condensed">
                <thead>
                  <tr>
                    <th width="8%">#</th>
                    <th width="10%">Item</th>
                    <th>Details</th>
                    <th width="15%">Assigned to</th>
                    <th width="15%">Due Date</th>
                  </tr>
                </thead>
                <tbody>
                {% for issue in issues %}
                        <tr>
                          <td><a href="{% url issue_detail id=issue.id %}">{{ issue.id }}</a></td>
                          <td><a href="{% url node_detail id=issue.rsc_id %}">{{ issue.rsc_id.title }}</a></td>
                          <td>{{ issue.issue_detail }}</td>
                          <td>{{ issue.assigned_id.title }}</td>
                          <td>{{ issue.request_date|date:"Y-m-d" }}</td>
                        </tr>
                {% endfor %}
                </tbody>
                </table>

