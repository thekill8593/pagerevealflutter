import 'package:flutter/material.dart';
import 'package:page_reveal/models/task.dart';
import 'package:page_reveal/scoped_models/main.dart';
import 'package:page_reveal/widgets/custom-radio.dart';
import 'package:page_reveal/widgets/custom-text.dart';
import 'package:page_reveal/widgets/custom-textfield.dart';
import 'package:page_reveal/widgets/datepicker.dart';

class EditTask extends StatefulWidget {
  final Task task;
  final MainModel model;

  EditTask({@required this.task, @required this.model});

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  int _taskId;
  String _taskText;
  bool _notifications;
  bool _completed;
  DateTime _fromDate = DateTime.now();
  TimeOfDay _fromTime;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final Task _task = widget.task;
    List strTime = splitTimeOfDay(_task.time);
    setState(() {
      _taskId = _task.id;
      _taskText = _task.task;
      _notifications = _task.notifications;
      _completed = _task.completed;
      _fromDate = DateTime.parse(_task.date);
      _fromTime =
          TimeOfDay(hour: int.parse(strTime[0]), minute: int.parse(strTime[1]));
    });
  }

  List splitTimeOfDay(String time) {
    String _timeString = time;
    _timeString = _timeString.replaceAll("TimeOfDay(", "");
    _timeString = _timeString.replaceAll(")", "");
    return _timeString.split(":");
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
        .updateTask(Task(
            id: _taskId,
            task: _taskText,
            date: validationTime.toString(),
            time: _fromTime.toString(),
            notifications: _notifications,
            completed: _completed))
        .then((_) {
      _buildAlert(context, "Task modified",
              "Your task has been modified successfully")
          .then((_) {
        Navigator.pop(context);
      });
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
            text: "Edit Task",
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
                      initialValue: _taskText,
                      placeholder: "Remind me to",
                      icon: Icons.access_alarm,
                      helperText: "Type the task you want to be remembered",
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter a task';
                        }
                      },
                      onSaved: (String value) {
                        _taskText = value;
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
