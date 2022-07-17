import 'package:flutter/material.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StatisticCard extends StatelessWidget {
  const StatisticCard(
      {Key? key,
      required this.title,
      required this.valueText,
      required this.percent})
      : super(key: key);

  final String title;
  final int valueText;
  final double percent;

  @override
  Widget build(BuildContext context) {
    double percentText = percent;
    return SizedBox(
      height: 85,
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CircularPercentIndicator(
                    lineWidth: 6,
                    animation: true,
                    radius: 28,
                    percent: percent / 100,
                    progressColor: kOrangeColor,
                    center: Text(
                      '${percentText.toInt()}%',
                      style: const TextStyle(
                          fontFamily: 'IranYekan', color: kOrangeColor),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'IranYekan',
                      fontWeight: FontWeight.bold,
                      color: kOrangeColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Text(
                    '$valueText ',
                    style: const TextStyle(
                      fontFamily: 'IranYekan',
                      color: Color(0xFF989898),
                      fontSize: 15,
                    ),
                  ),
                  const Text(
                    'تومان',
                    style: TextStyle(
                      fontFamily: 'IranYekan',
                      color: Color(0xFF989898),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
