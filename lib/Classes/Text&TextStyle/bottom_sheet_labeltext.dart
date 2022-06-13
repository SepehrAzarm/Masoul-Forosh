import 'package:flutter/material.dart';
import 'package:masoukharid/Constants/colors.dart';

class BottomSheetLabelText extends StatefulWidget {
  BottomSheetLabelText({
    Key? key,
    required this.text,
    this.fontSize,
  }) : super(key: key);

  final String text;
  late double? fontSize = 22;

  @override
  State<BottomSheetLabelText> createState() => _BottomSheetLabelTextState();
}

class _BottomSheetLabelTextState extends State<BottomSheetLabelText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        fontSize: widget.fontSize,
        fontFamily: 'Dana',
        fontWeight: FontWeight.bold,
        color: kBottomSheetTextColor,
      ),
    );
  }
}
