import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/models/enums/period.dart';
import 'package:reminder/models/task.dart';

class UserNewTask extends StatefulWidget {
  final Function addNewReminderCallback;
  //const UserNewTask({Key key}) : super(key: key);

  UserNewTask(this.addNewReminderCallback);

  @override
  _UserNewTaskState createState() => _UserNewTaskState(addNewReminderCallback);
}

class _UserNewTaskState extends State<UserNewTask> {
  final Function addNewReminderCallback;
  final titleController = TextEditingController();
  final DateFormat dateFormatter = new DateFormat('dd-MM-yyyy hh:mm');
  final List<String> availablePeriods = ["Year", "Month", "Day"];

  String currentReminderDateSelected = "Pick a date";
  DateTime dateTimeSelected = DateTime.now();
  String selectedPeriod;
  String selectedPeriodValue = '1';

  _UserNewTaskState(this.addNewReminderCallback);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    super.dispose();
  }

  Future<void> showDateSelector(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final DateTime date = await showDatePicker(
      //we wait for the dialog to return
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) //if the user has selected a date
      setState(() {
        this.dateTimeSelected = date;
        // we format the selected date and assign it to the state variable
        currentReminderDateSelected = dateFormatter.format(date);
      });
  }

  Future<void> showTimeSelector(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final TimeOfDay time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) //if the user has selected a date
      setState(() {
        dateTimeSelected = new DateTime(
            dateTimeSelected.year,
            dateTimeSelected.month,
            dateTimeSelected.day,
            time.hour,
            time.minute);
        // we format the selected date and assign it to the state variable
        currentReminderDateSelected = dateFormatter.format(dateTimeSelected);
      });
  }

  void pickPeriodUnit(String period) {
    setState(() {
      selectedPeriod = period;
    });
  }

  void pickPeriodValue(String period) {
    setState(() {
      selectedPeriodValue = period;
    });
  }

  void createNewReminder() {
    print("Saving data:");
    print("Title: " + titleController.text);
    print("Repeat every: " + selectedPeriodValue + " " + selectedPeriod);
    print("Start at: " + currentReminderDateSelected.toString());
    print("------------");

    this.addNewReminderCallback(
        new Task(titleController.text, this.dateTimeSelected, Period.DAILY));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
            maxHeight: double.infinity, maxWidth: double.infinity),
        padding: EdgeInsets.all(20),
        height: 400,
        child: Center(
            widthFactor: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "What",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Title"),
                  controller: titleController,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Repeat every",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new DropdownButton<String>(
                      value: selectedPeriodValue,
                      items: <String>['1', '2', '3', '4', '5', '6']
                          .map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (period) => pickPeriodValue(period),
                    ),
                    new DropdownButton<String>(
                      value: selectedPeriod,
                      items:
                          <String>['Year', 'Month', 'Day'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (period) => pickPeriodUnit(period),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Start at",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            currentReminderDateSelected,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            child: Text("Select date"),
                            onPressed: () => showDateSelector(context),
                          ),
                          ElevatedButton(
                            child: Text("Select time"),
                            onPressed: () => showTimeSelector(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => {createNewReminder()},
                    child: Text("Save data"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
