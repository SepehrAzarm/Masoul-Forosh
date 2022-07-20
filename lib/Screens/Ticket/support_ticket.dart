import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Screens/Ticket/tickets_list.dart';
import 'package:masoul_kharid/Screens/login_page.dart';
import 'package:masoul_kharid/Screens/profile_screen.dart';

import '../../Constants/borders_decorations.dart';
import '../../Constants/colors.dart';
import '../../Constants/constants.dart';

class SupportTicketScreen extends StatefulWidget {
  const SupportTicketScreen({Key? key}) : super(key: key);
  static const String id = "SupportTicketScreen";
  @override
  State<SupportTicketScreen> createState() => _SupportTicketScreenState();
}

class _SupportTicketScreenState extends State<SupportTicketScreen> {
  String? title;
  String? text;
  String? errorMassage;
  final storage = const FlutterSecureStorage();

  postTicket() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    Map data = {
      "title": title,
      "message": {
        "text": text,
      }
    };
    var body = jsonEncode(data);
    try {
      var response = await http.post(
        Uri.parse(
            'https://testapi.carbon-family.com/api/market/tickets/newTicket'),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 201) {
        print(response.statusCode);
        print(response.body);
      } else {
        var errorData = await jsonDecode(response.body.toString());
        errorMassage = await errorData['message'];
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 401) {
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginPage.id,
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0.2,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'شکایات و نظرات',
          style: TextStyle(
            fontFamily: 'IranYekan',
            color: kOrangeColor,
            fontSize: 17,
          ),
        ),
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'موضوع',
                  style: TextStyle(
                    fontFamily: 'Dana',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kNewsCardHeaderTextColor,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      title = value;
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
                    hintText: 'موضوع تیکت',
                    hintStyle: TextStyle(
                      fontFamily: 'Dana',
                      fontSize: 13,
                      color: Color(0xFFE5E5E5),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  'متن',
                  style: TextStyle(
                    fontFamily: 'Dana',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kNewsCardHeaderTextColor,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        text = value;
                      });
                    },
                    textAlign: TextAlign.start,
                    maxLines: null,
                    minLines: null,
                    expands: true,
                    cursorColor: kButtonOrangeColor,
                    decoration: const InputDecoration(
                      hintText: '  متن تیکت را وارد کنید',
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
                const SizedBox(height: 60),
                OrangeButton(
                  text: 'ارسال',
                  onPressed: () async {
                    if (title != null && text != null) {
                      await postTicket();
                      // ignore: unnecessary_null_comparison
                      errorMassage == null
                          ? Navigator.pushNamedAndRemoveUntil(
                              context,
                              TicketsList.id,
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
                                    '$errorMassage',
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
                                            // visible = false;
                                            errorMassage = null;
                                          });
                                          Navigator.pop(context);
                                        })
                                  ],
                                );
                              });
                    } else {
                      if (title == null && text == null) {
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
                                  'اطلاعات وارد شده صحیح نمی باشند',
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
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
