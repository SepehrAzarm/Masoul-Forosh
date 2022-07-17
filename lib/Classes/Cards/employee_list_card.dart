import 'package:flutter/material.dart';
import 'package:masoul_kharid/Constants/colors.dart';

class EmployeeListCard extends StatelessWidget {
  const EmployeeListCard({
    Key? key,
    required this.onTap,
    required this.name,
    required this.status,
    required this.image,
  }) : super(key: key);
  final String name;
  final String status;
  final String image;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Content Picture
                CircleAvatar(
                  radius: 38,
                  backgroundColor: kOrangeColor,
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(image),
                  ),
                ),
                //Content Text
                SizedBox(
                  height: 70,
                  width: 230,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Header Text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: kNewsCardHeaderTextColor,
                            fontFamily: 'Dana',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      //Content Text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          'وضعیت: $status',
                          style: const TextStyle(
                            color: Color(0xFF414141),
                            fontFamily: 'Dana',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Left Arrow
                const SizedBox(
                  height: 100,
                  width: 20,
                  // color: Colors.red,
                  child: Center(
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: kGreyTextColor,
                      size: 30,
                    ),
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
    );
  }
}
