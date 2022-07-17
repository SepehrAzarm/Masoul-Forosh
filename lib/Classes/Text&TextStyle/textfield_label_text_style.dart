import 'package:flutter/material.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Constants/constants.dart';

class TextFieldLabel extends StatelessWidget {
  const TextFieldLabel({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: kTextFieldLabelTextColor,
        fontSize: 14.0,
        fontFamily: kTextFontsFamily,
      ),
    );
  }
}
