// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Constants/constants.dart';

class TaxWidget extends StatelessWidget {
  TaxWidget({
    Key? key,
    required this.mainText,
    required this.secondaryText,
    required this.onChanged,
    this.enabled,
    this.controller,
    this.suffixIcon,
  }) : super(key: key);

  final String mainText;
  final String secondaryText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  bool? enabled = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                mainText,
                style: const TextStyle(
                  fontFamily: 'Dana',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B4B4B),
                ),
              ),
              Text(
                secondaryText,
                style: const TextStyle(
                  fontFamily: 'Dana',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE4E4E4),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
            width: 130,
            child: TextField(
              style: const TextStyle(
                fontFamily: 'IranYekan',
                fontSize: 12,
              ),
              onChanged: onChanged,
              enabled: enabled,
              controller: controller,
              keyboardType: TextInputType.number,
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: kTextFieldPadding,
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 5.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF707070), width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: kButtonOrangeColor,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                suffixIcon: suffixIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
