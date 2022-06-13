import 'package:flutter/material.dart';
import 'package:masoukharid/Classes/Text&TextStyle/statistics_text.dart';

class SettingsBodyContent extends StatelessWidget {
  const SettingsBodyContent({
    Key? key,
    required this.image,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String image;
  final String text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      width: 50,
                      height: 50,
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          image,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    StatisticsBSHTextStyle(
                      text: text,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }
}
