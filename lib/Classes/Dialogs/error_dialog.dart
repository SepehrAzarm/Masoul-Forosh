import 'package:flutter/material.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog(
      {Key? key, required this.errorText, required this.onPressed,})
      : super(key: key);

  final String errorText;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: SizedBox(
          width: 80,
          height: 80,
          child: Image(
            image: AssetImage('images/ErroIcon.png'),
          ),
        ),
      ),
      content: Text(
        errorText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'IranYekan',
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        OrangeButton(
          text: 'بستن',
          onPressed: onPressed,
        ),
      ],
    );
  }
}
