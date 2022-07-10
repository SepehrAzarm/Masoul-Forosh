import 'package:flutter/material.dart';

class TicketListCard extends StatelessWidget {
  const TicketListCard({
    Key? key,
    required this.name,
    required this.time,
    required this.createdAt,
    required this.onTap,
  }) : super(key: key);
  final String name;
  final String createdAt;
  final String time;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SizedBox(
          height: 65,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Text(
                            'آقای $name',
                            style: const TextStyle(
                              fontFamily: "IranYekan",
                              color: Color(0xFF121A26),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Text(
                            'زمان ایجاد: $createdAt',
                            style: const TextStyle(
                              fontFamily: "IranYekan",
                              color: Color(0xFF707070),
                              fontSize: 10,
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
                            color: Color(0xFF707070),
                            fontSize: 10,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF707070),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
                height: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
