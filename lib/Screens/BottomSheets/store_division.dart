import 'package:flutter/material.dart';
import 'package:masoukharid/Classes/orange_button.dart';
import 'package:masoukharid/Classes/Text&TextStyle/bottom_sheet_labeltext.dart';
import 'package:masoukharid/Methods/bottom_sheet_boxdecoration.dart';
import 'package:masoukharid/Classes/Text&TextStyle/week_days_text.dart';
import 'package:masoukharid/Constants/colors.dart';

class StoreDivisionBSH extends StatefulWidget {
  const StoreDivisionBSH({Key? key}) : super(key: key);

  @override
  _StoreDivisionBSHState createState() => _StoreDivisionBSHState();
}

class _StoreDivisionBSHState extends State<StoreDivisionBSH> {
  bool first = false;
  bool second = false;
  bool third = false;
  bool forth = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBottomSheetBackgroundColor,
      child: Container(
        height: 500,
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
                      BottomSheetLabelText(
                        text: 'انتخاب دسته بندی فروشگاه',
                        fontSize: 22,
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
                    height: 290,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Center(
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const WeekDaysText(
                                      text: 'دسته اول',
                                    ),
                                    Checkbox(
                                      activeColor: kButtonOrangeColor,
                                      value: first,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          first = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                              height: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const WeekDaysText(
                                      text: 'دسته دوم',
                                    ),
                                    Checkbox(
                                      activeColor: kButtonOrangeColor,
                                      value: second,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          second = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                              height: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const WeekDaysText(
                                      text: 'دسته سوم',
                                    ),
                                    Checkbox(
                                      activeColor: kButtonOrangeColor,
                                      value: third,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          third = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                              height: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const WeekDaysText(
                                      text: 'دسته چهارم',
                                    ),
                                    Checkbox(
                                      activeColor: kButtonOrangeColor,
                                      value: forth,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          forth = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                              height: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 19,
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
