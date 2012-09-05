		<table class="table table-striped table-bordered table-condensed">
                <thead>
                  <tr>
                    <th width="10%">#</th>
                    <th>Details</th>
                    <th width="15%">Assigned to</th>
                    <th width="15%">Due Date</th>
                    <th width="15%">Complete Date</th>
                  </tr>
                </thead>
                <tbody>
                {% for issue in issues %}
                        <tr>
                          <td><a href="{% url issue_detail id=issue.id %}">{{ issue.id }}</a></td>
                          <td>{{ issue.issue_detail }}</td>
                          <td>{{ issue.assigned_id.title }}</td>
                          <td>{{ issue.request_date|date:"Y-m-d" }}</td>
                          <td>{{ issue.complete_date|date:"Y-m-d" }}</td>
                        </tr>
                {% endfor %}
                </tbody>
                </table>

