import 'package:flutter/material.dart';
import 'package:masoukharid/Classes/Text&TextStyle/statistics_text.dart';

class StatisticsBSHContent extends StatelessWidget {
  const StatisticsBSHContent({
    Key? key,
    required this.image,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String image;
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  // color: Colors.black,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                width: 45,
                height: 45,
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
    );
  }
}
