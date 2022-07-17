import 'package:flutter/material.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Constants/constants.dart';

class StatisticsBSHTextStyle extends StatelessWidget {
  const StatisticsBSHTextStyle({Key? key, required this.text})
      : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: kBottomSheetTextColor,
          fontSize: 18.0,
          fontFamily: kTextFontsFamily,
        ),
      ),
    );
  }
}
