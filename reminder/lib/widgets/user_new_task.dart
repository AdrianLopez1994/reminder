import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/models/enums/period.dart';
import 'package:reminder/models/task.dart';
import 'package:local_auth/local_auth.dart';

class UserNewTask extends StatefulWidget {
  final Function addNewReminderCallback;
  //const UserNewTask({Key key}) : super(key: key);

  UserNewTask(this.addNewReminderCallback);

  @override
  _UserNewTaskState createState() => _UserNewTaskState(addNewReminderCallback);
}

class _UserNewTaskState extends State<UserNewTask> {
  //Callback to add reminder to main reminder list
  final Function addNewReminderCallback;

  //Controller to retrieve title value
  final titleController = TextEditingController();

  //Formatter to show selected date time
  final DateFormat dateFormatter = new DateFormat('dd-MM-yyyy hh:mm');

  //Available periods to choose (TODO - this must be a enum)
  final List<String> availablePeriods = ["Year", "Month", "Day"];

  //Default selected date message
  String currentReminderDateSelected = "Pick a date";

  //Variables to store user selected info
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

  //Show date selector modal
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

  //Show time selector modal
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

  //Callback to save selected period
  void pickPeriodUnit(String period) {
    setState(() {
      selectedPeriod = period;
    });
  }

  //Callback to save period unit
  void pickPeriodValue(String period) {
    setState(() {
      selectedPeriodValue = period;
    });
  }

  //Callback function to retrieve user input data
  void createNewReminder() async {
    print("Saving data:");
    print("Title: " + titleController.text);
    print("Repeat every: " + selectedPeriodValue + " " + selectedPeriod);
    print("Start at: " + currentReminderDateSelected.toString());
    print("------------");

    var localAuth = LocalAuthentication();
    bool didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        biometricOnly: true);

    print("Can authenticate: " + didAuthenticate.toString());
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
