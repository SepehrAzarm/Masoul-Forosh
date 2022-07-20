import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:masoul_kharid/Classes/chat_text_and_avatar.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Screens/Ticket/tickets_list.dart';
import 'package:masoul_kharid/Screens/login_page.dart';
import 'package:masoul_kharid/Screens/profile_screen.dart';
import 'package:masoul_kharid/Services/storage_class.dart';
import 'package:shamsi_date/shamsi_date.dart';

class TicketChatScreen extends StatefulWidget {
  const TicketChatScreen({Key? key}) : super(key: key);
  static const String id = "TicketChatScreen";

  @override
  State<TicketChatScreen> createState() => _TicketChatScreenState();
}

class _TicketChatScreenState extends State<TicketChatScreen> {
  final TextEditingController _massage = TextEditingController();
  final storage = const FlutterSecureStorage();
  List massagesList = [];
  String? title;
  String? text;
  String? createdAt;
  String? ownerName;
  String? errorText;
  late Map<String, dynamic> payload;

  late Jalali j;

  String createdAtTimeFormatter(Jalali j) {
    final f = j.formatter;
    return '${f.wN} ${f.d} ${f.mN} ${f.yy} | ${j.hour}:${j.minute}';
  }

  Future getTicketInfo() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    try {
      var response = await http.get(
          Uri.parse(
              "https://testapi.carbon-family.com/api/market/tickets/${Storage.ticketId}"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var messages = jsonDecode(data)["ticket"]["messages"];
        setState(() {
          for (var i = 0; i < messages.length; i++) {
            massagesList.add(messages[i]);
          }
          title = jsonDecode(data)["ticket"]["title"];
          createdAt = jsonDecode(data)["ticket"]["createdAt"];
          ownerName = jsonDecode(data)["ticket"]["ownerName"];
          payload = Jwt.parseJwt(value);
          print(payload);
          var dateAndTime = DateTime.parse(createdAt!).toLocal();
          Gregorian g = Gregorian.fromDateTime(dateAndTime);
          j = Jalali.fromGregorian(g);
        });
        print(response.statusCode);
        print(response.body);
      } else {
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

  Future postResponseToTicket() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    Map data = {
      "ticketId": Storage.ticketId,
      "message": {
        "text": text,
      }
    };
    var body = jsonEncode(data);
    try {
      var response = await http.post(
        Uri.parse(
            'https://testapi.carbon-family.com/api/market/tickets/responseToTicket'),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 201) {
        print(response.statusCode);
        print(response.body);
      } else {
        var errorData = await jsonDecode(response.body.toString());
        setState(() {
          errorText = errorData['message'];
        });
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future putUpdateTicketStatus() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    Map<String, dynamic> data = {
      "ticketId": Storage.ticketId,
      "status": false,
    };
    var body = jsonEncode(data);
    try {
      var response = await http.put(
          Uri.parse(
              "https://testapi.carbon-family.com/api/market/tickets/status"),
          headers: headers,
          body: body);
      if (response.statusCode == 200) {
        print(response.statusCode);
        print(response.body);
      } else {
        var data = await jsonDecode(response.body.toString());
        setState(() {
          errorText = data['message'];
        });
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getTicketInfo();
    super.initState();
  }

  bool isMe = true;
  @override
  Widget build(BuildContext context) {
    return title == null
        ? const Center(
            child: CircularProgressIndicator(
            color: kOrangeColor,
          ))
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              toolbarHeight: 60,
              centerTitle: true,
              elevation: 0.5,
              backgroundColor: Colors.white,
              leading: const BackButton(
                color: Colors.black,
              ),
              title: Text(
                '$title',
                style: const TextStyle(
                  fontFamily: "IranYekan",
                  fontWeight: FontWeight.bold,
                  color: kOrangeColor,
                  fontSize: 17,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    //Top Content
                    SizedBox(
                      height: 70,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 65,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const CircleAvatar(
                                        radius: 28,
                                        backgroundColor: Colors.black,
                                        backgroundImage: AssetImage(
                                          'images/EmployeeProfile.png',
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15),
                                            child: Text(
                                              '$ownerName',
                                              style: const TextStyle(
                                                fontFamily: "IranYekan",
                                                color: Color(0xFF121A26),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15),
                                            child: Text(
                                              'زمان ایجاد: ${createdAtTimeFormatter(j)} ',
                                              style: const TextStyle(
                                                fontFamily: "IranYekan",
                                                color: Color(0xFF707070),
                                                fontSize: 8,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Center(
                                                child: Text(
                                                  'آیا مطمئن هستید؟',
                                                  style: TextStyle(
                                                    fontFamily: 'IranYekan',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 19,
                                                  ),
                                                ),
                                              ),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: const Color(
                                                              0xFFFF0000),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      height: 45,
                                                      width: 140,
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Center(
                                                          child: Text(
                                                            'خیر',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Dana',
                                                              fontSize: 14,
                                                              color: Color(
                                                                  0xFFFF0000),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFFFF0000),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      height: 45,
                                                      width: 140,
                                                      child: TextButton(
                                                        onPressed: () async {
                                                          await putUpdateTicketStatus();
                                                          Navigator
                                                              .pushNamedAndRemoveUntil(
                                                            context,
                                                            TicketsList.id,
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false,
                                                          );
                                                        },
                                                        child: const Center(
                                                          child: Text(
                                                            'بله',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Dana',
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    child: SizedBox(
                                        height: 40,
                                        width: 90,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFF2222),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          height: 28,
                                          width: 60,
                                          child: const Center(
                                            child: Text(
                                              'بستن تیکت',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "IranYekan",
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            itemCount: massagesList.length,
                            itemBuilder: (context, int index) {
                              ImageProvider picFunc() {
                                if (massagesList[index]["userProfileImage"] ==
                                    null) {
                                  return const AssetImage(
                                    'images/EmployeeProfile.png',
                                  );
                                } else {
                                  return NetworkImage(
                                      'https://testapi.carbon-family.com/${massagesList[index]["userProfileImage"]}');
                                }
                              }

                              return ChatTextAndAvatar(
                                isMe: payload["user"]["_id"] ==
                                        massagesList[index]["userId"]
                                    ? true
                                    : false,
                                text: massagesList[index]["text"],
                                profileImage: picFunc(),
                              );
                            }),
                      ),
                    ),
                    //Text Box
                    Container(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextField(
                              controller: _massage,
                              onChanged: (value) {
                                text = value;
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'متن پیام را وارد کنید...',
                                  hintStyle: TextStyle(
                                    fontFamily: "Dana",
                                    color: Color(0xFF707070),
                                  )),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () async {
                              await postResponseToTicket();
                              massagesList = [];
                              await getTicketInfo();
                              setState(() {
                                text == null;
                                _massage.clear();
                              });
                            },
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: kOrangeColor,
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
