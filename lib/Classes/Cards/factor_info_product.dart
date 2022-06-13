import 'package:flutter/material.dart';

import '../../Constants/colors.dart';

class FactorInfoCard extends StatelessWidget {
  const FactorInfoCard({
    Key? key,
    required this.productAmount,
    required this.name,
    required this.pricePerAmount,
    required this.totalPrice,
  }) : super(key: key);

  final String productAmount;
  final String name;
  final String pricePerAmount;
  final String totalPrice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 55,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Container(
              // color: Colors.tealAccent,
              height: 37,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Title
                  Padding(
                    padding: const EdgeInsets.only(right: 17),
                    child: Container(
                      // color: Colors.orange,
                      height: double.infinity,
                      width: 100,
                      child: Center(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kFactorTitleTextColor,
                            fontFamily: 'IranSans',
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //price
                  Container(
                    // color: Colors.blue,
                    width: 60,
                    child: Text(
                      '$pricePerAmount تومان',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kFactorTitleTextColor,
                        fontFamily: "IranYekan",
                        fontSize: 9,
                      ),
                    ),
                  ),
                  //Total
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                      // color: Colors.blue,
                      width: 60,
                      child: Text(
                        '$totalPrice تومان',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kFactorTitleTextColor,
                          fontFamily: "IranYekan",
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 25),
              child: Text(
                'فروشگاه آذر مرغ',
                style: TextStyle(
                  fontFamily: "IranSans",
                  color: Color(0xFF4A4A4A),
                  fontSize: 4,
                ),
              ),
            ),
            const SizedBox(height: 3),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Color(0xFFF7F7F7),
                thickness: 2,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
