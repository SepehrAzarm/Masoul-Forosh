import 'package:flutter/material.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/orange_header_text.dart';
import 'package:masoul_kharid/Constants/borders_decorations.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Constants/constants.dart';

class NewsEdit extends StatefulWidget {
  const NewsEdit({Key? key}) : super(key: key);
  static const String id = 'NewsEdit';

  @override
  State<NewsEdit> createState() => _NewsEditState();
}

class _NewsEditState extends State<NewsEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  OrangeHeaderText(
                    text: 'ویرایش خبر',
                    fontSize: 35,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'ویرایش عکس',
                    style: TextStyle(
                      fontFamily: 'Dana',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kNewsCardHeaderTextColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4E4E4),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      width: 370.0,
                      height: 57.0,
                      child: const Center(
                        child: Text(
                          'ویرایش عکس خبر',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Dana',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'ویرایش متن',
                    style: TextStyle(
                      fontFamily: 'Dana',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kNewsCardHeaderTextColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const TextField(
                    cursorColor: kButtonOrangeColor,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kOrangeColor,
                          width: 2.0,
                        ),
                      ),
                      hintText: 'عنوان خبر',
                      hintStyle: TextStyle(
                        fontFamily: 'Dana',
                        fontSize: 13,
                        color: Color(0xFFE5E5E5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    child: const TextField(
                      maxLines: null,
                      minLines: null,
                      expands: true,
                      cursorColor: kButtonOrangeColor,
                      decoration: InputDecoration(
                        hintText: 'توضیحات خبر را وارد کنید',
                        hintStyle: TextStyle(
                          fontFamily: 'Dana',
                          fontSize: 13,
                          color: Color(0xFFE5E5E5),
                        ),
                        contentPadding: kTextFieldPadding,
                        filled: true,
                        fillColor: Colors.white,
                        border: kTextFieldBorder,
                        enabledBorder: kTextFieldEnabled,
                        focusedBorder: kTextFieldFocused,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      'تعداد کاراکتر: 300',
                      style: TextStyle(
                        fontFamily: 'IranYekan',
                        fontSize: 10,
                        color: kTextFieldHintTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  OrangeButton(text: 'تایید', onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
