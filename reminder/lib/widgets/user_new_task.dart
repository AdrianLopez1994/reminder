import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserNewTask extends StatefulWidget {
  const UserNewTask({Key key}) : super(key: key);

  @override
  _UserNewTaskState createState() => _UserNewTaskState();
}

class _UserNewTaskState extends State<UserNewTask> {
  String currentReminderDateSelected = "Pick a date";
  final DateFormat dateFormatter = new DateFormat('dd-MM-yyyy hh:mm');
  final List<String> availablePeriods = ["Year", "Month", "Day"];
  DateTime dateTimeSelected = DateTime.now();
  String selectedPeriod;
  String selectedPeriodValue = '1';

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
                    onPressed: () => {print("Saving data")},
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
