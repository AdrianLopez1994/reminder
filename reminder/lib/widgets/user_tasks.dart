import 'package:flutter/material.dart';
import 'package:reminder/models/enums/period.dart';
import 'package:reminder/models/task.dart';
import 'package:reminder/widgets/user_new_task.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'task_list.dart';

class UserTasks extends StatefulWidget {
  UserTasks({Key key}) : super(key: key);

  @override
  _UserTasksState createState() => _UserTasksState();
}

class _UserTasksState extends State<UserTasks> {
  final List<Task> userTasks = [
    Task("Comprar pan", DateTime.now(), Period.DAILY),
    Task("Comprar huevos", DateTime.now(), Period.MONTHLY),
    Task("Pagar garaje", DateTime.now(), Period.YEARLY),
    Task("Pagar a Mer", DateTime.now(), Period.DAILY),
  ];

  void addReminderToTaskList(Task newTask) {
    setState(() {
      userTasks.add(newTask);
    });
  }

  void updateTaskEnableFlag(int taskIdentifier, bool newValue) {
    setState(() {
      // TODO: OPTIMIZE THIS LOOP
      userTasks.map((task) {
        if (task.id == taskIdentifier) {
          task.enable = newValue;
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlidingSheet(
      elevation: 6,
      cornerRadius: 16,

      border: Border.all(
        color: Colors.grey.shade300,
        width: 3,
      ),
      snapSpec: const SnapSpec(
        snap: true,
        snappings: [0.1, 0.1, 1.0],
        positioning: SnapPositioning.relativeToSheetHeight,
      ),
      // The body widget will be displayed under the SlidingSheet
      // and a parallax effect can be applied to it.
      headerBuilder: buildSliddingSheetHeader,
      body: TaskList(userTasks, this.updateTaskEnableFlag),

      builder: (context, state) {
        return UserNewTask(this.addReminderToTaskList);
      },
    );
  }

  Widget buildSliddingSheetHeader(BuildContext context, SheetState state) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: double.infinity, maxWidth: double.infinity),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.lightBlue[100]),
      child: Text(
        "+ Add new Reminder",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}
