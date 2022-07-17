import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:masoul_kharid/Classes/Cards/activity_log_card.dart';
import 'package:masoul_kharid/Classes/Cards/employee_login_card.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Services/storage_class.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Constants/colors.dart';

class EmployeeLists extends StatefulWidget {
  const EmployeeLists({Key? key}) : super(key: key);
  static const String id = "EmployeeListsScreen";

  @override
  State<EmployeeLists> createState() => _EmployeeListsState();
}

class _EmployeeListsState extends State<EmployeeLists> {
  final storage = const FlutterSecureStorage();
  List loginActivityList = [];
  List activityLogsList = [];
  String? logDescription;
  String? logTitle;

  String createdAtTimeFormatter(Jalali j) {
    return '${j.hour}:${j.minute}';
  }

  Future getLoginActivity() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    try {
      var response = await http.get(
          Uri.parse(
              "https://testapi.carbon-family.com/api/market/history/login"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var items = jsonDecode(data)["history"]["history"];
        setState(() {
          for (var i = 0; i < items.length; i++) {
            loginActivityList.add(items[i]);
          }
        });
        print(response.statusCode);
        print(response.body);
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future getActivityList() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    try {
      var response = await http.get(
          Uri.parse(
              "https://testapi.carbon-family.com/api/market/history/userActionsLogs"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var items = jsonDecode(data)["data"];
        setState(() {
          for (var i = 0; i < items.length; i++) {
            activityLogsList.add(items[i]);
          }
        });
        print(response.statusCode);
        print(response.body);
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future getLogInfo() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    try {
      var response = await http.get(
          Uri.parse(
              "https://testapi.carbon-family.com/api/market/history/userActionsLogs/${Storage.logId}"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        setState(() {
          logTitle = jsonDecode(data)["data"]["action"];
          logDescription = jsonDecode(data)["data"]["descriptions"];
        });
        print(response.statusCode);
        print(response.body);
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getLoginActivity();
    getActivityList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'کارمندان',
            style: TextStyle(
              fontFamily: 'IranYekan',
              color: kOrangeColor,
              fontSize: 18,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const BackButton(
            color: Colors.black,
          ),
          bottom: const TabBar(
            labelPadding: EdgeInsets.all(4),
            indicatorColor: Colors.black,
            indicatorWeight: 1,
            tabs: [
              Text(
                'فعالیت کارمندان',
                style: TextStyle(
                  fontFamily: "Dana",
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
              Text(
                'تاریخچۀ ورورد',
                style: TextStyle(
                  fontFamily: "Dana",
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Activity List
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: ListView.builder(
                  itemCount: activityLogsList.length,
                  itemBuilder: (context, int index) {
                    var dateAndTime =
                        DateTime.parse(activityLogsList[index]["createdAt"]!)
                            .toLocal();
                    Gregorian g = Gregorian.fromDateTime(dateAndTime);
                    Jalali j = Jalali.fromGregorian(g);
                    return EmployeeActivityLogCard(
                      activity: activityLogsList[index]["action"],
                      name: activityLogsList[index]["user"]["fullName"] +
                          ' ' +
                          activityLogsList[index]["user"]["lastName"],
                      time: createdAtTimeFormatter(j),
                      onTap: () async {
                        Storage.logId = activityLogsList[index]["_id"];
                        await getLogInfo();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                title: Center(
                                  child: Text(
                                    '$logTitle',
                                    style: const TextStyle(
                                      fontFamily: 'Dana',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                content: Container(
                                  height: 450,
                                  width: 300,
                                  // color: Colors.amberAccent,
                                  child: Text(
                                    '$logDescription',
                                    style: const TextStyle(
                                      fontFamily: 'IranYekan',
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                actions: [
                                  OrangeButton(
                                    text: 'بستن',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    );
                  }),
            ),
            //Login Activity
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: ListView.builder(
                    itemCount: loginActivityList.length,
                    itemBuilder: (context, int index) {
                      var dateAndTime =
                          DateTime.parse(loginActivityList[index]["createdAt"]!)
                              .toLocal();
                      Gregorian g = Gregorian.fromDateTime(dateAndTime);
                      Jalali j = Jalali.fromGregorian(g);
                      return EmployeeLoginCard(
                        name: loginActivityList[index]["user"]["firstName"] +
                            ' ' +
                            loginActivityList[index]["user"]["lastName"],
                        status: 'ورورد',
                        time: createdAtTimeFormatter(j),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
