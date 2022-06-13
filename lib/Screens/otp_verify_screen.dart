import 'package:flutter/material.dart';
import 'package:masoukharid/Classes/Text&TextStyle/orange_header_text.dart';
import 'package:masoukharid/Classes/orange_button.dart';
import 'package:masoukharid/Constants/colors.dart';
import 'package:masoukharid/Screens/Password_Recovery/enter_new_password.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OTPVerifyScreen extends StatefulWidget {
  const OTPVerifyScreen({Key? key}) : super(key: key);
  static const String id = 'OTPVerifyScreen';

  @override
  State<OTPVerifyScreen> createState() => _OTPVerifyScreenState();
}

class _OTPVerifyScreenState extends State<OTPVerifyScreen> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String? code;
  String? password;
  bool obsText = true;
  String? errorText;
  bool visible = false;
  Future postOTPVerify() async {
    var response = await http.post(
        Uri.parse(
            'https://testapi.carbon-family.com/api/market/authentication/forgetpassword'),
        body: {'verificationCode': code, "newPassword": password});
    if (response.statusCode == 200) {
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
                  child: OrangeHeaderText(text: 'تایید هویت', fontSize: 35),
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
                const SizedBox(height: 80.0),
                SizedBox(
                  height: 28,
                  child: TextField(
                    obscureText: obsText,
                    controller: _password,
                    onChanged: (String value) {
                      setState(() {
                        password = value;
                      });
                    },
                    cursorColor: kButtonOrangeColor,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        iconSize: 20.0,
                        icon: Icon(obsText == true
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            obsText == true ? obsText = false : obsText = true;
                          });
                        },
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kButtonOrangeColor,
                          width: 2.0,
                        ),
                      ),
                      hintText: 'رمز عبور جدید خود را وارد کنید',
                      hintStyle: const TextStyle(
                        fontSize: 11,
                        color: kTextFieldHintTextColor,
                        fontFamily: 'Dana',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const SizedBox(
                  width: 80,
                  height: 20,
                  child: Text(
                    'رمز عبور باید شامل حروف بزرگ و کوچک انگلیسی و اعداد باشد',
                    style: TextStyle(
                      fontFamily: 'IranYekan',
                      fontSize: 10,
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(height: 210),
                Center(
                  child: Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: visible,
                    child: const SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        color: kOrangeColor,
                      ),
                    ),
                  ),
                ),
                OrangeButton(
                    text: 'تایید',
                    onPressed: () async {
                      setState(() {
                        visible = true;
                      });
                      if (code != null) {
                        await postOTPVerify();
                        // ignore: unnecessary_null_comparison
                        errorText == null
                            ? Navigator.pushNamedAndRemoveUntil(
                                context,
                                EnterNewPass.id,
                                (Route<dynamic> route) => false,
                              )
                            : showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Center(
                                      child: SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: Image(
                                          image:
                                              AssetImage('images/ErroIcon.png'),
                                        ),
                                      ),
                                    ),
                                    content: Text(
                                      '$errorText',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'IranYekan',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    actions: [
                                      OrangeButton(
                                          text: 'بستن',
                                          onPressed: () {
                                            setState(() {
                                              errorText = null;
                                              visible = false;
                                            });
                                            Navigator.pop(context);
                                          })
                                    ],
                                  );
                                });
                        print(errorText);
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  'لطفا کد تایید خود را وارد کنید',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'IranYekan',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                actions: [
                                  OrangeButton(
                                      text: 'بستن',
                                      onPressed: () {
                                        setState(() {
                                          errorText = null;
                                          visible = false;
                                        });
                                        Navigator.pop(context);
                                      })
                                ],
                              );
                            });
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
