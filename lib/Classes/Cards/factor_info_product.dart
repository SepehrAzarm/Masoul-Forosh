import 'package:flutter/material.dart';

import '../../Constants/colors.dart';

class FactorInfoCard extends StatelessWidget {
  const FactorInfoCard({
    Key? key,
    required this.name,
    required this.pricePerAmount,
    required this.totalPrice,
  }) : super(key: key);

  final String name;
  final String pricePerAmount;
  final String totalPrice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            SizedBox(
              height: 37,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Title
                  Padding(
                    padding: const EdgeInsets.only(right: 17),
                    child: SizedBox(
                      height: double.infinity,
                      width: 100,
                      child: Center(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kFactorTitleTextColor,
                            fontFamily: 'IranYekan',
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //price
                  SizedBox(
                    // color: Colors.blue,
                    width: 80,
                    child: Center(
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
                  ),
                  //Total
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: SizedBox(
                      // color: Colors.blue,
                      width: 80,
                      child: Center(
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
                  ),
                ],
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
