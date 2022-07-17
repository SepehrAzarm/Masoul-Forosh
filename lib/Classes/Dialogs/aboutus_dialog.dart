import 'package:flutter/material.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Constants/strings.dart';

class AboutUsDialog extends StatelessWidget {
  const AboutUsDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
        ),
        child: Image.asset('images/AboutUsHeader.png'),
      ),
      children: [
        const Text(
          'درباره ما',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Snaap',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF0B111A),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            height: 250,
            width: double.maxFinite,
            child: ListView(
              children: const [
                Text(
                  kDefaultText,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'IranYekan',
                    color: kGreyTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
