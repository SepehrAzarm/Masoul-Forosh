import 'package:flutter/material.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/orange_header_text.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masoul_kharid/Screens/Password_Recovery/otp_input_page.dart';
import 'package:masoul_kharid/Services/storage_class.dart';

class InputNumberPage extends StatefulWidget {
  const InputNumberPage({Key? key}) : super(key: key);

  static const String id = 'InputNumberPage';

  @override
  State<InputNumberPage> createState() => _InputNumberPageState();
}

class _InputNumberPageState extends State<InputNumberPage> {
  final TextEditingController _mobileController = TextEditingController();
  String? mobile;
  String? errorText;
  bool visible = false;
  getOTPVerify() async {
    try {
      var response = await http.get(
        Uri.parse(
            'https://testapi.carbon-family.com/api/market/authentication/forgetpassword/$mobile'),
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        print(response.body);
      } else {
        print(response.statusCode);
        print(response.body);
        var data = await jsonDecode(response.body.toString());
        setState(() {
          errorText = data['message'];
        });
      }
    } catch (e) {
      print(e);
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
                  child:
                      OrangeHeaderText(text: 'بازیابی رمز عبور', fontSize: 35),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      'برای بازیابی رمز عبور خود، شماره موبایل و یا پست الکترونیک خود را وارد نمایید',
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
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _mobileController,
                  onChanged: (value) {
                    setState(() {
                      mobile = value;
                    });
                  },
                  cursorColor: kButtonOrangeColor,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: kOrangeColor,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'شماره موبایل',
                    hintStyle: TextStyle(
                      fontFamily: 'IranYekan',
                      fontSize: 13,
                      color: Color(0xFF707070),
                    ),
                  ),
                ),
                const SizedBox(height: 360),
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
                    text: 'دریافت کد تایید',
                    onPressed: () async {
                      setState(() {
                        visible = true;
                      });
                      if (mobile != null) {
                        Storage.mobile = mobile!;
                        await getOTPVerify();
                        // ignore: unnecessary_null_comparison
                        errorText == null
                            ? Navigator.pushNamed(
                                context,
                                OTPInputPage.id,
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
                                title: const Center(
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Image(
                                      image: AssetImage('images/ErroIcon.png'),
                                    ),
                                  ),
                                ),
                                content: const Text(
                                  'لطفا شماره موبایل خود را وارد نمایید',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'IranYekan',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                actions: [
                                  OrangeButton(
                                      text: 'بستن',
                                      onPressed: () {
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
