import 'package:flutter/material.dart';
import 'package:masoukharid/Constants/colors.dart';

class OrderListCard extends StatelessWidget {
  const OrderListCard({
    Key? key,
    required this.onTap,
    required this.shopName,
    required this.orderNumber,
    required this.time,
    required this.image,
  }) : super(key: key);

  final String shopName;
  final String orderNumber;
  final String time;
  final Widget image;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      // color: Colors.yellow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      10,
                    ),
                  ),
                ),
                height: 60,
                width: 60,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: image,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 22,
                    child: Text(
                      shopName,
                      style: const TextStyle(
                        fontFamily: "IranYekan",
                        color: Color(0xFF121A26),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    'زمان ایجاد سفارش: $time',
                    style: const TextStyle(
                      fontFamily: "IranYekan",
                      color: Color(0xFF707070),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              Text(
                orderNumber,
                style: const TextStyle(
                  fontFamily: "IranYekan",
                  color: Color(0xFF707070),
                  fontSize: 10,
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: SizedBox(
                    height: 30,
                    width: 70,
                    child: Container(
                      decoration: BoxDecoration(
                        color: kOrangeColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 28,
                      width: 60,
                      child: const Center(
                        child: Text(
                          'جزئیات',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "IranYekan",
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          ),
          const Divider(
            thickness: 1,
            height: 1,
          )
        ],
      ),
    );
  }
}
