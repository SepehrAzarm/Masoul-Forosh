import 'package:flutter/material.dart';
import 'package:masoukharid/Constants/colors.dart';

class FactorListCard extends StatelessWidget {
  const FactorListCard({
    Key? key,
    required this.storeName,
    required this.invoiceNumber,
    required this.onTap,
  }) : super(key: key);

  final String storeName;
  final int invoiceNumber;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: Column(
        children: [
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 30,
                  width: 130,
                  child: Center(
                    child: Text(
                      storeName,
                      style: const TextStyle(
                        color: kFactorListCardTextColor,
                        fontFamily: "IranYekan",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 100,
                  child: Center(
                    child: Text(
                      '$invoiceNumber',
                      style: const TextStyle(
                        color: kFactorListCardTextColor,
                        fontFamily: "IranYekan",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 100,
                  child: Center(
                    child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                        decoration: BoxDecoration(
                          color: kOrangeColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 28,
                        width: 70,
                        child: const Center(
                          child: Text(
                            'مشاهده',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "IranYekan",
                              color: Colors.white,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color(0xFF707070),
            thickness: 0.3,
            height: 0.5,
          ),
        ],
      ),
    );
  }
}
