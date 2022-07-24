import 'package:flutter/material.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/bottom_sheet_labeltext.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/textfield_label_text_style.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Constants/constants.dart';
import 'package:masoul_kharid/Methods/bottom_sheet_boxdecoration.dart';
import 'package:masoul_kharid/Methods/text_field_input_decorations.dart';

class DepositBSH extends StatelessWidget {
  const DepositBSH({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBottomSheetBackgroundColor,
      child: Container(
        height: 300,
        decoration: bottomSheetBoxDecoration(),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: BottomSheetLabelText(
                        text: 'واریز',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      iconSize: 35,
                      color: kBottomSheetTextColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              const Center(
                child: Text(
                  'به زودی',
                  style: TextStyle(
                    fontFamily: "Dana",
                    color: kOrangeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
