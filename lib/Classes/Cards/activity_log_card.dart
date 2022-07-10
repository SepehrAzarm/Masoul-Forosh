import 'package:flutter/material.dart';
import 'package:masoukharid/Constants/colors.dart';

class EmployeeActivityLogCard extends StatelessWidget {
  const EmployeeActivityLogCard({
    Key? key,
    required this.name,
    required this.activity,
    required this.time,
  }) : super(key: key);

  final String name;
  final String activity;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 62,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 31,
                    child: Text(
                      'آقای $name',
                      style: const TextStyle(
                        fontFamily: "Snap",
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: Text(
                      activity,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: "Snap",
                        color: kBottomSheetTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      fontFamily: "IranYekan",
                      color: kBottomSheetTextColor,
                      fontSize: 10,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_left,
                    color: kBottomSheetBackgroundColor,
                    size: 30,
                  )
                ],
              ),
            ],
          ),
          const Divider(
            height: 1,
            thickness: 1,
          )
        ],
      ),
    );
  }
}
