import 'package:flutter/material.dart';
import 'package:masoul_kharid/Constants/text_styles.dart';
import 'package:masoul_kharid/Screens/News/news_main_page.dart';

import 'package:masoul_kharid/Constants/colors.dart';

class NewsCardProfile extends StatelessWidget {
  const NewsCardProfile({
    Key? key,
    required this.title,
    required this.contentText,
  }) : super(key: key);


  final String title;
  final String contentText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Content Picture
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(14.0),
                  ),
                ),
                width: 80,
                height: 80,
                child: const Image(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    'images/Sale-News.png',
                  ),
                ),
              ),
              //Content Text
              SizedBox(
                height: 100,
                width: 230,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Header Text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        title,
                        style: kNewsCardHeaderTextStyle,
                      ),
                    ),
                    //Content Text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        contentText,
                        style: kNewsCardContentTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
              //Left Arrow
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, NewsMainPage.id);
                },
                child: const SizedBox(
                  height: 100,
                  width: 20,
                  // color: Colors.red,
                  child: Center(
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: kGreyTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 1,
        )
      ],
    );
  }
}
