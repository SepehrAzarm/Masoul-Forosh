import 'package:flutter/material.dart';
import 'package:masoul_kharid/Classes/news_card_for_profile.dart';
import 'package:masoul_kharid/Modals/news.dart';

class NewsList extends StatefulWidget {
  const NewsList({
    Key? key,
  }) : super(key: key);

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List<News> newsList = [
    News(
        image: 'images/Sale-News.png',
        title: 'تخفیف شگفت انگیز',
        contentText: 'تخفیف شگفت انگیز فروشگاه ایکس تا پایان این ماه تمدید شد'),
    News(
        image: 'images/Sale-News.png',
        title: 'تخفیف شگفت انگیز',
        contentText: 'تخفیف شگفت انگیز فروشگاه ایکس تا پایان این ماه تمدید شد'),
    News(
        image: 'images/Sale-News.png',
        title: 'تخفیف شگفت انگیز',
        contentText: 'تخفیف شگفت انگیز فروشگاه ایکس تا پایان این ماه تمدید شد'),
    News(
        image: 'images/Sale-News.png',
        title: 'تخفیف شگفت انگیز',
        contentText: 'تخفیف شگفت انگیز فروشگاه ایکس تا پایان این ماه تمدید شد'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        return NewsCardProfile(
            title: newsList[index].title,
            contentText: newsList[index].contentText);
      },
    );
  }
}
