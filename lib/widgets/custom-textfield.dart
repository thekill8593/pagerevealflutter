import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String placeholder;
  final String initialValue;
  final Color textColor;
  final double textFontSize;
  final String textFontFamily;
  final IconData icon;
  final String helperText;
  final Function validator;
  final Function onSaved;

  CustomTextFormField(
      {this.placeholder,
      this.initialValue = "",
      this.textColor = Colors.white,
      this.textFontSize = 20.0,
      this.textFontFamily = "LatoRegular",
      this.icon,
      this.helperText = "",
      @required this.validator,
      @required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
          color: textColor, fontSize: textFontSize, fontFamily: textFontFamily),
      autocorrect: false,
      initialValue: initialValue,
      decoration: InputDecoration(
          labelText: placeholder,
          labelStyle: TextStyle(
            color: textColor,
            fontFamily: textFontFamily,
            fontSize: (textFontSize + 4.0),
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.white,
          ),
          helperText: helperText,
          helperStyle: TextStyle(color: textColor),
          errorStyle: TextStyle(color: Colors.red[200]),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300])),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: textColor)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300])),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: textColor))),
      validator: validator,
      onSaved: onSaved,
    );
  }
}

//"Type the task you want to be remembered"
/*

 return TextFormField(
      decoration: InputDecoration(
        labelText: 'Product title',
      ),
      initialValue: product == null ? '' : product.title,
      validator: (String value) {
        //return
        if (value.isEmpty || value.length < 5) {
          return "Title is required and should be 5+ characters long";
        }
      },
      onSaved: (String value) {
        _formData['title'] = value;
      },
    ); */
