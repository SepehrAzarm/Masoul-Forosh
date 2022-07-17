import 'package:flutter/material.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/bottom_sheet_labeltext.dart';
import 'package:masoul_kharid/Classes/statistics_bsh_content_widget.dart';
import 'package:masoul_kharid/Methods/bottom_sheet_boxdecoration.dart';
import 'package:masoul_kharid/Screens/Employees/employe_list.dart';
import 'package:masoul_kharid/Constants/colors.dart';

class EmployeesSettingsBSH extends StatelessWidget {
  const EmployeesSettingsBSH({Key? key}) : super(key: key);

  final String employeeImageAsset = 'images/Icons/EmployeesIcon.png';
  final String historyIconImageAsset = 'images/SettingsIcons/history.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBottomSheetBackgroundColor,
      child: Container(
        height: 270.0,
        decoration: bottomSheetBoxDecoration(),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),
          child: Center(
            child: Column(
              children: [
                //Title
                SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BottomSheetLabelText(
                        text: 'تنظیمات کارمندان',
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
                const SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    height: 170,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Center(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, EmployeeList.id);
                              },
                              child: StatisticsBSHContent(
                                image: employeeImageAsset,
                                text: 'لیست کارمندان',
                                onTap: () {
                                  Navigator.pushNamed(context, EmployeeList.id);
                                },
                              ),
                            ),
                            const Divider(thickness: 1),
                          ],
                        ),
                      ),
                    ),
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
