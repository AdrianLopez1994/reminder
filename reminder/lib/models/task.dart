import 'dart:math';

import './enums/period.dart';

class Task {
  int id;
  String title;
  Period period;
  DateTime firstReminderDate;
  bool enable;

  Task(this.title, this.firstReminderDate, this.period) {
    this.id = new Random().nextInt(1000);
    this.enable = true;
  }
}
