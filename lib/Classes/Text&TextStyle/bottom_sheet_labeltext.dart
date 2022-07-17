import 'package:flutter/material.dart';
import 'package:masoul_kharid/Constants/colors.dart';

class BottomSheetLabelText extends StatefulWidget {
  const BottomSheetLabelText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;
  // late double? fontSize = 22;

  @override
  State<BottomSheetLabelText> createState() => _BottomSheetLabelTextState();
}

class _BottomSheetLabelTextState extends State<BottomSheetLabelText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: const TextStyle(
        fontSize: 22,
        fontFamily: 'Dana',
        fontWeight: FontWeight.bold,
        color: kBottomSheetTextColor,
      ),
    );
  }
}
