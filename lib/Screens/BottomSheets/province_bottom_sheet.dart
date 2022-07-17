import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Constants/text_styles.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/bottom_sheet_labeltext.dart';
import 'package:masoul_kharid/Methods/bottom_sheet_boxdecoration.dart';

class ProvinceChoose extends StatefulWidget {
  const ProvinceChoose({Key? key}) : super(key: key);

  @override
  _ProvinceChooseState createState() => _ProvinceChooseState();
}

class _ProvinceChooseState extends State<ProvinceChoose> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF757575),
      child: Container(
        height: 450,
        decoration: bottomSheetBoxDecoration(),
        child: Container(
          // color: Colors.amber,
          margin: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  // color: Colors.lightBlueAccent,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BottomSheetLabelText(
                        text: 'انتخاب استان',
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
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: SizedBox(
                    height: 250,
                    child: CupertinoPicker(
                      onSelectedItemChanged: (int value) {},
                      itemExtent: 40,
                      squeeze: 0.98,
                      children: const [
                        Text(
                          'تبریز',
                          style: kBottomSheetTextStyle,
                        ),
                        Text(
                          'تهران',
                          style: kBottomSheetTextStyle,
                        ),
                        Text(
                          'اصفهان',
                          style: kBottomSheetTextStyle,
                        ),
                        Text(
                          'اورمیه',
                          style: kBottomSheetTextStyle,
                        ),
                        Text(
                          'اردبیل',
                          style: kBottomSheetTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                // const Divider(
                //   height: 1,
                //   thickness: 1,
                // ),
                const SizedBox(
                  height: 14,
                ),
                SizedBox(
                  height: 80,
                  child: OrangeButton(
                    onPressed: () {},
                    text: 'تأیید',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
