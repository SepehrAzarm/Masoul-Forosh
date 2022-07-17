import 'package:flutter/material.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/bottom_sheet_labeltext.dart';
import 'package:masoul_kharid/Methods/bottom_sheet_boxdecoration.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/week_days_text.dart';

class ActiveDaysBSH extends StatefulWidget {
  const ActiveDaysBSH({Key? key}) : super(key: key);

  @override
  _ActiveDaysBSHState createState() => _ActiveDaysBSHState();
}

class _ActiveDaysBSHState extends State<ActiveDaysBSH> {
  List<int> activeDaysList = [];
  bool isCheckedAll = false;
  bool isCheckedSat = false;
  bool isCheckedSun = false;
  bool isCheckedMon = false;
  bool isCheckedTue = false;
  bool isCheckedWed = false;
  bool isCheckedThu = false;
  bool isCheckedFri = false;

  Map<String, int> activeDaysMap = {
    'دوشنبه': 0,
    'سه شنبه': 1,
    'چهارشنبه': 2,
    'پنج شنبه': 3,
    'جمعه': 4,
    'شنبه': 5,
    'یکشنبه': 6,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF757575),
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
                      const BottomSheetLabelText(
                        text: 'انتخاب روز های فعالیت',
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
                                      text: 'همه',
                                    ),
                                    Checkbox(
                                      activeColor: kButtonOrangeColor,
                                      value: isCheckedAll,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isCheckedAll = value!;
                                          if (isCheckedAll == true) {
                                            isCheckedSat = true;
                                            isCheckedSun = true;
                                            isCheckedMon = true;
                                            isCheckedTue = true;
                                            isCheckedWed = true;
                                            isCheckedThu = true;
                                            isCheckedFri = true;
                                            activeDaysList.add(0);
                                            activeDaysList.add(1);
                                            activeDaysList.add(2);
                                            activeDaysList.add(3);
                                            activeDaysList.add(4);
                                            activeDaysList.add(5);
                                            activeDaysList.add(6);
                                          } else {
                                            isCheckedSat = false;
                                            isCheckedSun = false;
                                            isCheckedMon = false;
                                            isCheckedTue = false;
                                            isCheckedWed = false;
                                            isCheckedThu = false;
                                            isCheckedFri = false;
                                          }
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
                                      text: 'شنبه',
                                    ),
                                    Checkbox(
                                      activeColor: kButtonOrangeColor,
                                      value: isCheckedSat,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isCheckedSat = value!;
                                          activeDaysList.add(5);
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
                                      text: 'یک شنبه',
                                    ),
                                    Checkbox(
                                      activeColor: kButtonOrangeColor,
                                      value: isCheckedSun,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isCheckedSun = value!;
                                          activeDaysList.add(6);
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
                                      text: 'دو شنبه',
                                    ),
                                    Checkbox(
                                      activeColor: kButtonOrangeColor,
                                      value: isCheckedMon,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isCheckedMon = value!;
                                          activeDaysList.add(0);
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
                                      text: 'سه شنبه',
                                    ),
                                    Checkbox(
                                      activeColor: kButtonOrangeColor,
                                      value: isCheckedTue,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isCheckedTue = value!;
                                          activeDaysList.add(1);
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
                                      text: 'چهار شنبه',
                                    ),
                                    Checkbox(
                                      activeColor: kButtonOrangeColor,
                                      value: isCheckedWed,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isCheckedWed = value!;
                                          activeDaysList.add(2);
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
                                      text: 'پنج شنبه',
                                    ),
                                    Checkbox(
                                      activeColor: kButtonOrangeColor,
                                      value: isCheckedThu,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isCheckedThu = value!;
                                          activeDaysList.add(3);
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
                                      text: 'جمعه',
                                    ),
                                    Checkbox(
                                      activeColor: kButtonOrangeColor,
                                      value: isCheckedFri,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isCheckedFri = value!;
                                          activeDaysList.add(4);
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
                    onPressed: () {
                      Navigator.pop(
                        context,
                        activeDaysList,
                      );
                    },
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
