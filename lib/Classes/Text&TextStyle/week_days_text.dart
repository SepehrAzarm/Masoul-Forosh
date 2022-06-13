import 'package:flutter/material.dart';
import 'package:masoukharid/Constants/colors.dart';
import 'package:masoukharid/Constants/constants.dart';

class WeekDaysText extends StatelessWidget {
  const WeekDaysText({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: kTextFieldLabelTextColor,
          fontSize: 22.0,
          fontFamily: kTextFontsFamily,
        ),
      ),
    );
  }
}
