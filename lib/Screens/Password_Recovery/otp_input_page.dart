import 'package:flutter/material.dart';
import 'package:masoukharid/Classes/Text&TextStyle/orange_header_text.dart';
import 'package:masoukharid/Classes/orange_button.dart';
import 'package:masoukharid/Screens/Password_Recovery/enter_new_password.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OTPInputPage extends StatefulWidget {
  const OTPInputPage({Key? key}) : super(key: key);
  static const String id = 'OTPInputPage';

  @override
  State<OTPInputPage> createState() => _OTPInputPageState();
}

class _OTPInputPageState extends State<OTPInputPage> {
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
                      'کد تایید ارسال شده را وارد نمایید',
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
                OTPTextField(
                  length: 6,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 50,
                  fieldStyle: FieldStyle.box,
                ),
                const SizedBox(height: 400),
                OrangeButton(
                    text: 'دریافت کد تایید',
                    onPressed: () {
                      Navigator.pushNamed(context, EnterNewPass.id);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
