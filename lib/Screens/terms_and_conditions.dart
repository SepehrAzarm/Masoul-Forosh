import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/orange_header_text.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Screens/splash_screen.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);
  static const String id = "TermsAndConditionsScreen";

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  final storage = const FlutterSecureStorage();
  bool checked = false;
  String? bodyText;

  @override
  void initState() {
    super.initState();
    getGlobalInfo();
  }

  Future getGlobalInfo() async {
    try {
      var response = await http.get(
        Uri.parse(
            'https://testapi.carbon-family.com/api/market/configs/globalConfigs'),
      );
      if (response.statusCode == 200) {
        var data = response.body;
        setState(() {
          bodyText = jsonDecode(data)["data"]["rules"];
        });
        print(response.statusCode);
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return bodyText == null
        ? const Center(
            child: CircularProgressIndicator(
            color: kOrangeColor,
          ))
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: SafeArea(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: OrangeHeaderText(
                          text: 'شرایط و ضوابط',
                          fontSize: 35.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '$bodyText',
                      style: const TextStyle(
                        fontFamily: "IranYekan",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 4, thickness: 1),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Checkbox(
                              activeColor: kButtonOrangeColor,
                              value: checked,
                              onChanged: (bool? value) {
                                setState(() {
                                  checked = value!;
                                });
                              },
                            ),
                            const Text(
                              'شرایط و قوانین فوق را مطالعه کردم و میپذیرم',
                              style: TextStyle(
                                fontFamily: 'Dana',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            SplashScreen.id,
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: checked == false
                                  ? Colors.grey
                                  : kButtonOrangeColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            // width: 370.0,
                            height: 57.0,
                            child: const Center(
                              child: Text(
                                "تائید",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Dana',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
