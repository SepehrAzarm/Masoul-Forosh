import 'package:flutter/material.dart';
import 'package:masoukharid/Constants/colors.dart';
import 'package:masoukharid/Classes/orange_button.dart';
import 'package:masoukharid/Classes/Text&TextStyle/bottom_sheet_labeltext.dart';
import 'package:masoukharid/Methods/bottom_sheet_boxdecoration.dart';
import 'package:masoukharid/Classes/Text&TextStyle/week_days_text.dart';

class ActiveDaysBSH extends StatefulWidget {
  const ActiveDaysBSH({Key? key}) : super(key: key);

  @override
  _ActiveDaysBSHState createState() => _ActiveDaysBSHState();
}

class _ActiveDaysBSHState extends State<ActiveDaysBSH> {
  List<String> activeDaysList = [];
  bool isCheckedAll = false;
  bool isCheckedSat = false;
  bool isCheckedSun = false;
  bool isCheckedMon = false;
  bool isCheckedTue = false;
  bool isCheckedWed = false;
  bool isCheckedThu = false;
  bool isCheckedFri = false;
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
                                            activeDaysList.add("Saturday");
                                            activeDaysList.add("Sunday");
                                            activeDaysList.add("Monday");
                                            activeDaysList.add("Tuesday");
                                            activeDaysList.add("Wednesday");
                                            activeDaysList.add("Thursday");
                                            activeDaysList.add("Friday");
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
                                          activeDaysList.add("Saturday");
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
                                          activeDaysList.add("Sunday");
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
                                          activeDaysList.add("Monday");
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
                                          activeDaysList.add("Tuesday");
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
                                          activeDaysList.add("Wednesday");
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
                                          activeDaysList.add("Thursday");
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
                                          activeDaysList.add("Friday");
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
