import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/models/task.dart';

class TaskList extends StatelessWidget {
  final List<Task> userTasks;
  final Function updateEnabledTaskSwitchValue;
  final dateFormatter = new DateFormat('dd-MM-yyyy hh:mm');

  TaskList(this.userTasks, this.updateEnabledTaskSwitchValue);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: double.infinity),
      height: MediaQuery.of(context).size.height * 0.85,
      child: SingleChildScrollView(
        child: Column(
          children: userTasks
              .map((task) => Card(
                    elevation: 6,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(task.title,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  dateFormatter.format(task.firstReminderDate)),
                            ],
                          ),
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Switch(
                            value: task.enable,
                            onChanged: (newValue) =>
                                updateEnabledTaskSwitchValue(task.id, newValue),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
