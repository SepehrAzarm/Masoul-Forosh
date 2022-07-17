import 'package:flutter/material.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/orange_header_text.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Screens/Password_Recovery/otp_input_page.dart';

class EnterNewPass extends StatefulWidget {
  const EnterNewPass({Key? key}) : super(key: key);
  static const String id = 'EnterNewPassPage';

  @override
  State<EnterNewPass> createState() => _EnterNewPassState();
}

class _EnterNewPassState extends State<EnterNewPass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: const BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/backgroundwhite.jpg'),
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.07), BlendMode.dstATop),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child:
                      OrangeHeaderText(text: 'بازیابی رمز عبور', fontSize: 35),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      'رمز عبور جدید خود را وارد کنید',
                      style: TextStyle(
                        fontFamily: 'Dana',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC1C0BD),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                const TextField(
                  cursorColor: kButtonOrangeColor,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: kOrangeColor,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'رمز عبور',
                    hintStyle: TextStyle(
                      fontFamily: 'Dana',
                      fontSize: 13,
                      color: Color(0xFF707070),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                const TextField(
                  cursorColor: kButtonOrangeColor,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: kOrangeColor,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'تکرار رمز عبور',
                    hintStyle: TextStyle(
                      fontFamily: 'Dana',
                      fontSize: 13,
                      color: Color(0xFF707070),
                    ),
                  ),
                ),
                const SizedBox(height: 320),
                OrangeButton(
                    text: 'تایید',
                    onPressed: () {
                      Navigator.pushNamed(context, OTPInputPage.id);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
