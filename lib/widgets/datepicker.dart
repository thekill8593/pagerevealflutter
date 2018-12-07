import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_reveal/widgets/custom-text.dart';

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.iconColor,
      this.icon,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;
  final Color iconColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: iconColor),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.only(right: 15.0)),
              CustomText(
                text: labelText,
                color: Colors.grey[800],
                fontWeight: FontWeight.w900,
              ),
            ],
          ),
          Column(
            children: <Widget>[
              CustomText(
                text: valueText,
                color: Colors.grey[600],
              )
            ],
          )
        ],
      ),
    );
  }
}

class DateTimePicker extends StatelessWidget {
  DateTimePicker(
      {Key key,
      this.labelText,
      this.selectedDate,
      this.selectedTime,
      this.selectDate,
      this.selectTime})
      : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(DateTime.now().year, DateTime.now().month),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: _InputDropdown(
            labelText: "Date",
            valueText: DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            iconColor: Colors.green,
            icon: Icons.calendar_today,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        SizedBox(height: 20.0),
        Container(
          child: _InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            iconColor: Colors.pink,
            icon: Icons.timer,
            labelText: "Time",
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}
