import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/orange_header_text.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Screens/Password_Recovery/enter_new_password.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class OTPInputPage extends StatefulWidget {
  const OTPInputPage({Key? key}) : super(key: key);
  static const String id = 'OTPInputPage';

  @override
  State<OTPInputPage> createState() => _OTPInputPageState();
}

class _OTPInputPageState extends State<OTPInputPage> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final storage = const FlutterSecureStorage();
  Timer? countdownTimer;
  Duration myDuration = const Duration(minutes: 5);
  String? code;
  bool obsText = true;
  String? errorText;
  String? newPass;
  bool visible = false;
  bool resendVisible = false;

  Future postOTPVerify() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
    };
    var response = await http.post(
        Uri.parse(
            'https://testapi.carbon-family.com/api/market/authentication/forgetpassword'),
        headers: headers,
        body: {
          "mobile": "string",
          "verificationCode": code,
          "newPassword": newPass,
        });
    if (response.statusCode == 201) {
      var data = await jsonDecode(response.body.toString());
      await storage.delete(key: "token");
      await storage.write(key: "token", value: data["token"]);
      String? value = await storage.read(key: "token");
      print(value);
      print(response.body);
      print(response.statusCode);
    } else {
      print(response.statusCode);
      print(response.body);
      var data = await jsonDecode(response.body.toString());
      setState(() {
        errorText = data['message'];
      });
    }
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      setState(() {
        stopTimer();
      });
    }
    super.dispose();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    if (mounted) {
      setState(() => countdownTimer!.cancel());
    }
  }

  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration(minutes: 5));
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        resendVisible = true;
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: TextField(
                    controller: _otpController,
                    onChanged: (value) {
                      code = value;
                    },
                    cursorColor: kButtonOrangeColor,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kOrangeColor,
                          width: 2.0,
                        ),
                      ),
                      hintText: 'کد تایید',
                      hintStyle: TextStyle(
                        fontFamily: 'Dana',
                        fontSize: 13,
                        color: kTextFieldHintTextColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: false,
                        child: GestureDetector(
                          onTap: () async {
                            // resetTimer();
                            // startTimer();
                            // await getOtp();
                          },
                          child: const Text(
                            'ارسال مجدد کد',
                            style: TextStyle(
                              fontFamily: "Dana",
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: kOrangeColor,
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        'موز',
                        // '$minutes:$seconds',
                        style: TextStyle(
                            fontFamily: "IranYekan",
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: TextField(
                    controller: _newPassword,
                    onChanged: (value) {},
                    cursorColor: kButtonOrangeColor,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kOrangeColor,
                          width: 2.0,
                        ),
                      ),
                      hintText: 'رمز عبور جدید ',
                      hintStyle: TextStyle(
                        fontFamily: 'Dana',
                        fontSize: 13,
                        color: kTextFieldHintTextColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 400),
                OrangeButton(text: 'دریافت کد تایید', onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
