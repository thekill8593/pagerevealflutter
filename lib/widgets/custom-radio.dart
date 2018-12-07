import 'package:flutter/material.dart';
import 'package:page_reveal/widgets/custom-text.dart';

class CustomRadioButton extends StatelessWidget {
  final Function onChanged;
  final bool value;

  CustomRadioButton({@required this.onChanged, this.value = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchListTile(
          value: value,
          title: CustomText(
            text: "Notifications",
            color: Colors.grey[800],
            fontWeight: FontWeight.w900,
          ),
          onChanged: onChanged,
        )
      ],
    );
  }
}

/**
 * 
 * return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Accept Terms'),
    );
 */
