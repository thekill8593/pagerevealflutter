import 'package:flutter/material.dart';
import 'package:page_reveal/widgets/custom-radio.dart';
import 'package:page_reveal/widgets/custom-textfield.dart';
import 'package:page_reveal/widgets/datepicker.dart';

class CreateTask extends StatefulWidget {
  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  String _task = "";
  bool _notifications = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _fromDate = DateTime.now();
  TimeOfDay _fromTime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    //create map
    final Map<String, dynamic> data = {
      "task": _task,
      "date": _fromDate.toString(),
      "time": _fromTime.toString(),
      "notifications": _notifications
    };

    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("New task"),
          ),
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
