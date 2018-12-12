import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final String fontFamily;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextDecoration textDecoration;

  CustomText(
      {@required this.text,
      this.fontFamily = "LatoRegular",
      this.color = Colors.white,
      this.fontSize = 20.0,
      this.fontWeight = FontWeight.w400,
      this.textDecoration = TextDecoration.none});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: fontFamily,
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          decoration: textDecoration),
    );
  }
}
