import 'package:flutter/material.dart';
import 'package:masoul_kharid/Constants/colors.dart';

class OrangeButton extends StatelessWidget {
  const OrangeButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          decoration: BoxDecoration(
            color: kButtonOrangeColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          // width: 370.0,
          height: 57.0,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Dana',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
