import 'dart:convert';

import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/orange_header_text.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/textfield_label_text_style.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Constants/constants.dart';
import 'package:masoul_kharid/Methods/text_field_input_decorations.dart';
import 'package:masoul_kharid/Screens/Password_Recovery/input_page.dart';
import 'package:masoul_kharid/Screens/otp_verify_screen.dart';
import 'package:masoul_kharid/Screens/profile_screen.dart';
import 'package:masoul_kharid/Classes/Dialogs/error_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String id = 'LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final storage = const FlutterSecureStorage();
  Color phoneColor = kTextFieldBorderColor;
  Color keyColor = kTextFieldBorderColor;
  String? phoneNumber;
  String? password;
  bool? isVerified;
  bool obsText = true;
  bool visible = false;
  String? errorText;

  Future getOtp() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {'token': value!};
    try {
      var response = await http.get(
        Uri.parse(
            'https://api.carbon-family.com/api/market/authentication/verify'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        print(response.body);
      } else {
        var data = await jsonDecode(response.body.toString());
        errorText = await data['message'];
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future authenticateUser() async {
    try {
      var response = await http.post(
        Uri.parse(
            'https://api.carbon-family.com/api/market/authentication/login'),
        body: {
          'mobile': phoneNumber,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body.toString());
        await storage.write(key: "token", value: data['token']);
        String? value = await storage.read(key: "token");
        Map<String, dynamic> payload = Jwt.parseJwt(value!);
        isVerified = payload["user"]["isVerified"];
        print(isVerified);
        print(payload);
        print(response.statusCode);
      } else {
        var data = await jsonDecode(response.body.toString());
        errorText = await data['message'];
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  checkInternet() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == false) {
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
                'لطفا اتصال اینترنت خود را چک کنید',
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
  }

  checkVPNConnection() async {
    if (await CheckVpnConnection.isVpnActive()) {
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
                'لطفا فیلتر شکن خود را قطع کنید',
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
  }

  @override
  void initState() {
    checkInternet();
    checkVPNConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
          child: Container(
            height: MediaQuery.of(context).size.height,
            margin:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    // color: Colors.pinkAccent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          // height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              const SizedBox(height: 80),
                              // Header Text
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: OrangeHeaderText(
                                    text: 'ورود',
                                    fontSize: 40.0,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              //Phone Number
                              Container(
                                padding: const EdgeInsets.only(
                                  left: 115,
                                  right: 12,
                                ),
                                width: double.infinity,
                                height: kLabelTextContainerHeight,
                                child:
                                    const TextFieldLabel(text: 'شماره موبایل'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextField(
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    controller: _controllerPhoneNumber,
                                    cursorColor: kButtonOrangeColor,
                                    textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.center,
                                    onChanged: (String value) {
                                      setState(() {
                                        phoneNumber = value;
                                        value != null
                                            ? phoneColor = kButtonOrangeColor
                                            : phoneColor =
                                                kTextFieldBorderColor;
                                      });
                                    },
                                    style: const TextStyle(
                                      fontFamily: 'IranYekan',
                                    ),
                                    decoration: textFieldDecorations(
                                      suffixIcon: Container(
                                        margin: const EdgeInsets.all(10.0),
                                        child: ImageIcon(
                                          const AssetImage(
                                            'images/Icons/phoneIcon.png',
                                          ),
                                          color: phoneColor,
                                          size: 10,
                                        ),
                                      ),
                                    )),
                              ),
                              const SizedBox(height: 40),
                              // Password Field
                              Container(
                                padding: const EdgeInsets.only(
                                  left: 115,
                                  right: 12,
                                ),
                                width: double.infinity,
                                height: kLabelTextContainerHeight,
                                child: const TextFieldLabel(text: 'رمز عبور'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextField(
                                  obscuringCharacter: '*',
                                  obscureText: obsText,
                                  textAlign: TextAlign.center,
                                  controller: _controllerPassword,
                                  onChanged: (String value) {
                                    setState(() {
                                      password = value;
                                    });
                                  },
                                  decoration: textFieldDecorations(
                                    suffixIcon: IconButton(
                                      iconSize: 24.0,
                                      icon: Icon(obsText == true
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          obsText == true
                                              ? obsText = false
                                              : obsText = true;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, InputNumberPage.id);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    'رمز عبور خود را فراموش کرده اید؟',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontFamily: 'IranYekan',
                                      color: Color(0xFF0088FF),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 130,
                    // color: Colors.amberAccent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OrangeButton(
                          text: 'ورود',
                          onPressed: () async {
                            if (phoneNumber != null && password != null) {
                              print(phoneNumber);
                              print(password);
                              setState(() {
                                visible = true;
                              });
                              await authenticateUser();
                              // ignore: unnecessary_null_comparison
                              if (errorText != null) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ErrorDialog(
                                        errorText: '$errorText',
                                        onPressed: () {
                                          setState(() {
                                            errorText = null;
                                            visible = false;
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    });
                              } else {
                                if (isVerified == true) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    ProfileScreen.id,
                                    (Route<dynamic> route) => false,
                                  );
                                } else {
                                  getOtp();
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushNamed(
                                    context,
                                    OTPVerifyScreen.id,
                                  );
                                }
                              }
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ErrorDialog(
                                      errorText:
                                          'لطفا شماره موبایل و رمز عبور خود را وارد نمایید',
                                      onPressed: () {
                                        setState(() {
                                          errorText = null;
                                          visible = false;
                                        });
                                        Navigator.pop(context);
                                      },
                                    );
                                  });
                            }
                          },
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'تمامی حقوق مادی و معنوی مربوط به',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.0,
                                fontFamily: 'Dana',
                              ),
                            ),
                            Text(
                              ' اپلیکیشن مسئول فروش میباشد',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.0,
                                fontFamily: 'Dana',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
