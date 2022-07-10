import 'package:flutter/material.dart';
import 'package:masoukharid/Constants/colors.dart';

class EmployeeLoginCard extends StatelessWidget {
  const EmployeeLoginCard({
    Key? key,
    required this.name,
    required this.status,
    required this.time,
  }) : super(key: key);

  final String name;
  final String status;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 55,
        child: Column(
          children: [
            SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'آقای $name',
                    style: const TextStyle(
                      fontFamily: "IranSans",
                      fontWeight: FontWeight.bold,
                      color: kBottomSheetTextColor,
                    ),
                  ),
                  Text(
                    status,
                    style: const TextStyle(
                      fontFamily: "Dana",
                      color: Color(0xFF707070),
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      fontFamily: "IranYekan",
                      color: Color(0xFF707070),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }
}
