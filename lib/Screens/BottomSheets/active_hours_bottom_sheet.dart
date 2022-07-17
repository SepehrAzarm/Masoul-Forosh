import 'package:flutter/material.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Constants/constants.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Methods/bottom_sheet_boxdecoration.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/bottom_sheet_labeltext.dart';

class ActiveHoursBottomSheet extends StatefulWidget {
  const ActiveHoursBottomSheet({Key? key}) : super(key: key);

  @override
  _ActiveHoursBottomSheetState createState() => _ActiveHoursBottomSheetState();
}

class _ActiveHoursBottomSheetState extends State<ActiveHoursBottomSheet> {
  TimeOfDay selectedTimeFrom = TimeOfDay.now();
  TimeOfDay selectedTimeTo = TimeOfDay.now();

  _selectTimeFrom(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTimeFrom,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFFFF7700),
            colorScheme: const ColorScheme.light(primary: Color(0xFFFF7700)),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (timeOfDay != null && timeOfDay != selectedTimeFrom) {
      setState(() {
        selectedTimeFrom = timeOfDay;
      });
    }
  }

  _selectTimeTo(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTimeTo,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFFFF7700),
            colorScheme: const ColorScheme.light(primary: Color(0xFFFF7700)),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (timeOfDay != null && timeOfDay != selectedTimeTo) {
      setState(() {
        selectedTimeTo = timeOfDay;
      });
    }
  }

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
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BottomSheetLabelText(
                        text: 'انتخاب ساعات فعالیت',
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
                    child: Center(
                      child: SizedBox(
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'از',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kTextFieldLabelTextColor,
                                fontSize: 30.0,
                                fontFamily: kTextFontsFamily,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _selectTimeFrom(context);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${selectedTimeFrom.hour}:${selectedTimeFrom.minute}',
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontFamily: 'Dana',
                                      color: kTextFieldHintTextColor,
                                    ),
                                  ),
                                  const Divider(
                                    height: 1.0,
                                    thickness: 3,
                                    color: kTextFieldHintTextColor,
                                  )
                                ],
                              ),
                            ),
                            const Text(
                              'الی',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kTextFieldLabelTextColor,
                                fontSize: 30.0,
                                fontFamily: kTextFontsFamily,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _selectTimeTo(context);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${selectedTimeTo.hour}:${selectedTimeTo.minute}',
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontFamily: 'Dana',
                                      color: kTextFieldHintTextColor,
                                    ),
                                  ),
                                  const Divider(
                                    height: 3.0,
                                    thickness: 3,
                                    color: kTextFieldHintTextColor,
                                  )
                                ],
                              ),
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
