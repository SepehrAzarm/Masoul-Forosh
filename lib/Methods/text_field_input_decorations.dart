import 'package:flutter/material.dart';
import 'package:masoukharid/Constants/borders_decorations.dart';
import 'package:masoukharid/Constants/constants.dart';

InputDecoration textFieldDecorations({Widget? suffixIcon}) {
  return InputDecoration(
    contentPadding: kTextFieldPadding,
    filled: true,
    fillColor: Colors.white,
    border: kTextFieldBorder,
    enabledBorder: kTextFieldEnabled,
    focusedBorder: kTextFieldFocused,
    suffixIcon: suffixIcon,
  );
}
