import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:page_reveal/models/task.dart';
import 'package:page_reveal/notifications/notifications.dart';
import 'package:page_reveal/scoped_models/main.dart';
import 'package:page_reveal/widgets/custom-radio.dart';
import 'package:page_reveal/widgets/custom-text.dart';
import 'package:page_reveal/widgets/custom-textfield.dart';
import 'package:page_reveal/widgets/datepicker.dart';

class CreateTask extends StatefulWidget {
  final MainModel model;
  final LocalNotification notifications;

  CreateTask({
    @required this.model,
    @required this.notifications,
  });

  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  String _task = "";
  bool _notifications = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _fromDate = DateTime.now();
  TimeOfDay _fromTime = TimeOfDay.now();

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    final DateTime validationTime = DateTime(_fromDate.year, _fromDate.month,
        _fromDate.day, _fromTime.hour, _fromTime.minute);

    if (validationTime.difference(DateTime.now()).isNegative) {
      _buildAlert(context, "Error", "Please select a valid date");
      return;
    }

    widget.model
        .insertTask(Task(
            id: 0,
            task: _task,
            date: validationTime.toString(),
            time: _fromTime.toString(),
            notifications: _notifications,
            completed: false))
        .then((int taskId) {
      //notifications stuff
      if (_notifications) {
        var scheduledNotificationDateTime = validationTime;
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'your other channel id',
            'your other channel name',
            'your other channel description');
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        NotificationDetails platformChannelSpecifics = NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        widget.notifications.showScheduleNotification(
            taskId,
            "New task!!",
            _task,
            widget.notifications.flutterLocalNotificationsPlugin,
            platformChannelSpecifics,
            scheduledNotificationDateTime);
      }

      _buildAlert(context, "Task Created",
              "Your task has been created successfully")
          .then((_) {
        Navigator.pop(context);
      });
    });
  }

  Future<Widget> _buildAlert(
      BuildContext context, String title, String message) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
              title: CustomText(
            text: "Create Task",
            fontSize: 24.0,
          )),
          body: Container(
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 150.0,
                    padding:
                        EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
                    color: Colors.deepPurple,
                    child: CustomTextFormField(
                      placeholder: "Remind me to",
                      icon: Icons.access_alarm,
                      helperText: "Type the task you want to be remembered",
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter a task';
                        }
                      },
                      onSaved: (String value) {
                        _task = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: DateTimePicker(
                      labelText: 'Select date and time',
                      selectedDate: _fromDate,
                      selectedTime: _fromTime,
                      selectDate: (DateTime date) {
                        setState(() {
                          _fromDate = date;
                        });
                      },
                      selectTime: (TimeOfDay time) {
                        setState(() {
                          _fromTime = time;
                        });
                      },
                    ),
                  ),
                  Container(
                    child: CustomRadioButton(
                      onChanged: (bool value) {
                        setState(() {
                          _notifications = !_notifications;
                        });
                      },
                      value: _notifications,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton(
                          backgroundColor: Colors.deepPurple,
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 40.0,
                          ),
                          onPressed: _submitForm,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
