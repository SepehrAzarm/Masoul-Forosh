import 'package:flutter/material.dart';
import 'colors.dart';

const kTextFieldBorder = OutlineInputBorder(
  borderSide: BorderSide(width: 5.0),
  borderRadius: BorderRadius.all(
    Radius.circular(10.0),
  ),
);
const kTextFieldEnabled = OutlineInputBorder(
  borderSide: BorderSide(color: kTextFieldBorderColor, width: 1.0),
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
);
const kTextFieldFocused = OutlineInputBorder(
  borderSide: BorderSide(
    color: kButtonOrangeColor,
    width: 2.0,
  ),
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
);
const kTextFieldDisabled = OutlineInputBorder(
  borderSide: BorderSide(color: kButtonOrangeColor, width: 3.0),
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
);
