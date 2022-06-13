import 'package:flutter/material.dart';
import 'package:masoukharid/Constants/text_styles.dart';
import 'package:masoukharid/Screens/News/news_main_page.dart';

import 'package:masoukharid/Constants/colors.dart';

class NewsCardProfile extends StatelessWidget {
  NewsCardProfile({
    Key? key,
    this.image = 'images/Sale-News.png',
    required this.title,
    required this.contentText,
  }) : super(key: key);

  late String image;
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
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    image,
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