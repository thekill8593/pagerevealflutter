import 'package:flutter/material.dart';

class Task {
  final int id;
  final String task;
  final String date;
  final String time;
  final bool notifications;
  final bool completed;

  Task(
      {@required this.id,
      @required this.task,
      @required this.date,
      @required this.time,
      @required this.notifications,
      @required this.completed});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'task': task,
      'date': date,
      'time': time,
      'notifications': notifications ? 1 : 0,
      'completed': completed ? 1 : 0
    };
    return map;
  }
}
