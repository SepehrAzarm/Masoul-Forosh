import 'package:flutter/material.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({
    Key? key,
    required this.type,
    required this.dateAndTime,
    required this.amount,
    required this.status,
    required this.onTap,
  }) : super(key: key);

  final String type;
  final String dateAndTime;
  final String amount;
  final Widget status;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 70,
        child: Column(
          children: [
            SizedBox(
              height: 65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 28,
                    backgroundImage:
                        AssetImage('images/Icons/WalletCardLogo.png'),
                  ),
                  SizedBox(
                    width: 280,
                    // color: Colors.amberAccent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                type,
                                style: const TextStyle(
                                  fontFamily: "Dana",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$amount تومان',
                                style: const TextStyle(
                                  fontFamily: "IranYekan",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dateAndTime,
                                style: const TextStyle(
                                  fontFamily: "IranYekan",
                                  fontSize: 8,
                                ),
                              ),
                              status,
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                height: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
