import 'package:flutter/material.dart';
import 'package:masoul_kharid/Constants/colors.dart';

class OrangeHeaderText extends StatelessWidget {
  OrangeHeaderText({
    Key? key,
    required this.text,
    this.fontSize,
  }) : super(key: key);

  final String text;
  double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        color: kButtonOrangeColor,
        fontFamily: 'Dana',
      ),
    );
  }
}
