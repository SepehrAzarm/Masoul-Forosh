import 'package:flutter/material.dart';
import 'package:masoul_kharid/Classes/Dialogs/delete_dialog.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Constants/strings.dart';
import 'package:masoul_kharid/Screens/News/news_edit.dart';

import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Constants/text_styles.dart';

class NewsMainPage extends StatefulWidget {
  const NewsMainPage({Key? key}) : super(key: key);
  static const String id = 'NewsMainPage';

  @override
  _NewsMainPageState createState() => _NewsMainPageState();
}

class _NewsMainPageState extends State<NewsMainPage> {
  final String imageAssetName = 'images/Sale-News.jpg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: ListView(
              children: [
                SizedBox(
                    height: 350,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18)),
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          imageAssetName,
                        ),
                      ),
                    )),
                Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 80,
                      // color: Colors.lightBlueAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  'تخفیف شگفت انگیز',
                                  style: kNewsCardTitleTxtStyle,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  'تعداد لایک خبر:69',
                                  style: TextStyle(
                                    fontFamily: 'IranYekanExtraBold',
                                    fontSize: 8,
                                    color: kNewsCardContentTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    const DeleteDialog(
                                  text: 'آیا از خذف خبر مطمئنید؟',
                                ),
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.amberAccent,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(14),
                                ),
                              ),
                              height: 45,
                              width: 45,
                              child: Image.asset('images/Icons/DeleteIcon.png'),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, NewsEdit.id);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.amberAccent,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(14),
                                ),
                              ),
                              height: 45,
                              width: 45,
                              child: Image.asset('images/Icons/EditIcon.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        kDefaultText,
                        style: TextStyle(
                          fontFamily: 'IranYekan',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: kNewsCardContentTextColor,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 80,
            child: OrangeButton(
              text: 'بازگشت',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
