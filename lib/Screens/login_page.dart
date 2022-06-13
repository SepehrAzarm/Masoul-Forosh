import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:masoukharid/Screens/Password_Recovery/input_page.dart';
import 'package:masoukharid/Constants/constants.dart';
import 'package:masoukharid/Classes/Text&TextStyle/textfield_label_text_style.dart';
import 'package:masoukharid/Methods/text_field_input_decorations.dart';
import 'package:masoukharid/Classes/orange_button.dart';
import 'package:masoukharid/Classes/Text&TextStyle/orange_header_text.dart';
import 'package:masoukharid/Constants/colors.dart';
import 'package:masoukharid/Screens/profile_screen.dart';
import 'package:http/http.dart' as http;
import 'package:masoukharid/Services/storage_class.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:check_vpn_connection/check_vpn_connection.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String id = 'LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  Color phoneColor = kTextFieldBorderColor;
  Color keyColor = kTextFieldBorderColor;
  String? phoneNumber;
  String? password;
  bool obsText = true;
  bool visible = false;
  String? errorText;
  Future authenticateUser() async {
    try {
      var response = await http.post(
        Uri.parse(
            'https://testapi.carbon-family.com/api/market/authentication/login'),
        body: {
          'mobile': phoneNumber,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body.toString());
        Storage.token = await data['token'];
        print(Storage.token);
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
            margin:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          //Phone Number
                          Container(
                            padding: const EdgeInsets.only(
                              left: 115,
                              right: 12,
                            ),
                            width: double.infinity,
                            height: kLabelTextContainerHeight,
                            child: const TextFieldLabel(text: 'شماره موبایل'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                        : phoneColor = kTextFieldBorderColor;
                                  });
                                },
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              Navigator.pushNamed(context, InputNumberPage.id);
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

                          const SizedBox(height: 190),
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
                          const SizedBox(height: 20),
                          //Bottom Button
                          Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                OrangeButton(
                                  text: 'ورود',
                                  onPressed: () async {
                                    if (phoneNumber != null &&
                                        password != null) {
                                      print(phoneNumber);
                                      print(password);
                                      setState(() {
                                        visible = true;
                                      });
                                      await authenticateUser();
                                      // ignore: unnecessary_null_comparison
                                      errorText != null
                                          ? showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Center(
                                                    child: SizedBox(
                                                      width: 80,
                                                      height: 80,
                                                      child: Image(
                                                        image: AssetImage(
                                                            'images/ErroIcon.png'),
                                                      ),
                                                    ),
                                                  ),
                                                  content: Text(
                                                    '$errorText',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontFamily: 'IranYekan',
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                          Navigator.pop(
                                                              context);
                                                        })
                                                  ],
                                                );
                                              })
                                          : Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              ProfileScreen.id,
                                              (Route<dynamic> route) => false,
                                            );
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
                                                    image: AssetImage(
                                                        'images/ErroIcon.png'),
                                                  ),
                                                ),
                                              ),
                                              content: const Text(
                                                'لطفا شماره موبایل و رمز عبور خود را وارد نمایید',
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
                                                      setState(() {
                                                        visible = false;
                                                        errorText = null;
                                                      });
                                                      Navigator.pop(context);
                                                    })
                                              ],
                                            );
                                          });
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 7.0,
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
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
