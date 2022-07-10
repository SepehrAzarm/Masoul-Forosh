import 'package:flutter/material.dart';
import 'package:masoukharid/Classes/Text&TextStyle/bottom_sheet_labeltext.dart';
import 'package:masoukharid/Classes/Text&TextStyle/textfield_label_text_style.dart';
import 'package:masoukharid/Classes/orange_button.dart';
import 'package:masoukharid/Constants/colors.dart';
import 'package:masoukharid/Constants/constants.dart';
import 'package:masoukharid/Methods/bottom_sheet_boxdecoration.dart';
import 'package:masoukharid/Methods/text_field_input_decorations.dart';

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
              Container(
                height: 140,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 12),
                      height: kLabelTextContainerHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          TextFieldLabel(text: 'مبلغ برداشت را وارد کنید: '),
                          Text(
                            '(به تومان)',
                            style: TextStyle(
                              fontFamily: "Dana",
                              color: Color(0xFF6D6D6D),
                              fontSize: 8,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        // controller: _controllerPhoneNumber,
                        cursorColor: kButtonOrangeColor,
                        // textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        onChanged: (String value) {},
                        style: const TextStyle(
                          fontFamily: 'IranYekan',
                        ),
                        decoration: textFieldDecorations(),
                      ),
                    ),
                  ],
                ),
              ),
              OrangeButton(
                text: 'واریز',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
