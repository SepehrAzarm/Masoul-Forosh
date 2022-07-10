import 'package:flutter/material.dart';
import 'package:masoukharid/Constants/colors.dart';

class FactorListCard extends StatelessWidget {
  const FactorListCard({
    Key? key,
    required this.storeName,
    required this.invoiceNumber,
    required this.status,
    required this.onTap,
  }) : super(key: key);

  final String storeName;
  final String status;
  final int invoiceNumber;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                  width: 120,
                  child: Center(
                    child: Text(
                      storeName,
                      style: const TextStyle(
                        color: kFactorListCardTextColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: "IranYekan",
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 70,
                  child: Center(
                    child: Text(
                      '$invoiceNumber',
                      style: const TextStyle(
                        color: kFactorListCardTextColor,
                        fontFamily: "IranYekan",
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    height: 30,
                    width: 80,
                    child: Center(
                      child: Text(
                        status,
                        style: const TextStyle(
                          color: kFactorListCardTextColor,
                          fontFamily: "IranYekan",
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    height: 30,
                    width: 60,
                    child: Center(
                      child: GestureDetector(
                        onTap: onTap,
                        child: Container(
                          decoration: BoxDecoration(
                            color: kOrangeColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 28,
                          width: 60,
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
