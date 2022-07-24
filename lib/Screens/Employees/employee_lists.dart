import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:masoul_kharid/Classes/Cards/activity_log_card.dart';
import 'package:masoul_kharid/Classes/Cards/employee_login_card.dart';
import 'package:masoul_kharid/Classes/Dialogs/error_dialog.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Screens/login_page.dart';
import 'package:masoul_kharid/Screens/profile_screen.dart';
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

  int page = 1;
  int logPage = 1;
  bool _hasNextPage = true;
  bool _logHasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLogFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  bool _isLogLoadMoreRunning = false;
  late ScrollController _controller;
  late ScrollController _logController;

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
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      var response = await http.get(
          Uri.parse(
              "https://api.carbon-family.com/api/market/history/login?page=$page"),
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
        if (response.statusCode == 401) {
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginPage.id,
            (Route<dynamic> route) => false,
          );
        }
        if (response.statusCode == 403) {
          showDialog(
              context: context,
              builder: (context) {
                return ErrorDialog(
                  errorText: 'شما دسترسی به این بخش را ندارید',
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      ProfileScreen.id,
                      (Route<dynamic> route) => false,
                    );
                  },
                );
              });
        }
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  Future loadMoreLoginActivity() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 100) {
      page += 1;
      print(page);
      setState(() {
        _isLoadMoreRunning = true;
      });
      try {
        final response = await http.get(
          Uri.parse(
              "https://api.carbon-family.com/api/market/history/login?page=$page"),
          headers: headers,
        );
        final List fetchedPosts = [];
        if (response.statusCode == 200) {
          var data = response.body;
          var items = jsonDecode(data)["history"]["history"];
          for (var i = 0; i < items.length; i++) {
            fetchedPosts.add(items[i]);
          }
          print(response.statusCode);
          print(response.body);
        }
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            loginActivityList.addAll(fetchedPosts);
            _isLoadMoreRunning = false;
          });
        } else {
          setState(() {
            _hasNextPage = false;
            _isLoadMoreRunning = false;
          });
        }
      } catch (err) {
        print(err);
      }
    }
  }

  Future getActivityList() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    setState(() {
      _isLogFirstLoadRunning = true;
    });
    try {
      var response = await http.get(
          Uri.parse(
              "https://api.carbon-family.com/api/market/history/userActionsLogs?page=$logPage"),
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
        if (response.statusCode == 403) {
          showDialog(
              context: context,
              builder: (context) {
                return ErrorDialog(
                  errorText: 'شما دسترسی به این بخش را ندارید',
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      ProfileScreen.id,
                      (Route<dynamic> route) => false,
                    );
                  },
                );
              });
        }
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLogFirstLoadRunning = false;
    });
  }

  Future loadMoreLogActivity() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    if (_logHasNextPage == true &&
        _isLogFirstLoadRunning == false &&
        _isLogLoadMoreRunning == false &&
        _logController.position.extentAfter < 100) {
      logPage += 1;
      setState(() {
        _isLogLoadMoreRunning = true;
      });
      try {
        final response = await http.get(
          Uri.parse(
              "https://api.carbon-family.com/api/market/history/userActionsLogs?page=$logPage"),
          headers: headers,
        );
        final List fetchedPosts = [];
        if (response.statusCode == 200) {
          var data = response.body;
          var items = jsonDecode(data)["data"];
          var pageNumber = jsonDecode(data)["page"];
          for (var i = 0; i < items.length; i++) {
            fetchedPosts.add(items[i]);
          }
          print(pageNumber);
          print(response.statusCode);
          print(response.body);
        }
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            activityLogsList.addAll(fetchedPosts);
            _isLogLoadMoreRunning = false;
          });
        } else {
          setState(() {
            _isLogLoadMoreRunning = false;
            _logHasNextPage = false;
          });
        }
      } catch (err) {
        print(err);
      }
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
              "https://api.carbon-family.com/api/market/history/userActionsLogs/${Storage.logId}"),
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
    _controller = ScrollController()..addListener(loadMoreLoginActivity);
    _logController = ScrollController()..addListener(loadMoreLogActivity);
    getActivityList();
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(loadMoreLoginActivity);
    _logController.removeListener(loadMoreLogActivity);
    super.dispose();
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
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        controller: _logController,
                        itemCount: activityLogsList.length,
                        itemBuilder: (context, int index) {
                          var dateAndTime = DateTime.parse(
                                  activityLogsList[index]["createdAt"]!)
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
                  if (_isLogLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: kOrangeColor,
                        ),
                      ),
                    ),
                  if (_logHasNextPage == false)
                    Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 40),
                      child: const Center(
                        child: Text(
                          'پایان لیست',
                          style: TextStyle(
                            fontFamily: "Dana",
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            //Login Activity
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          controller: _controller,
                          itemCount: loginActivityList.length,
                          itemBuilder: (context, int index) {
                            var dateAndTime = DateTime.parse(
                                    loginActivityList[index]["createdAt"]!)
                                .toLocal();
                            Gregorian g = Gregorian.fromDateTime(dateAndTime);
                            Jalali j = Jalali.fromGregorian(g);
                            return EmployeeLoginCard(
                              name: loginActivityList[index]["user"]
                                      ["firstName"] +
                                  ' ' +
                                  loginActivityList[index]["user"]["lastName"],
                              status: 'ورورد',
                              time: createdAtTimeFormatter(j),
                            );
                          }),
                    ),
                    if (_isLoadMoreRunning == true)
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: kOrangeColor,
                          ),
                        ),
                      ),
                    if (_hasNextPage == false)
                      Container(
                        padding: const EdgeInsets.only(top: 30, bottom: 40),
                        child: const Center(
                          child: Text(
                            'پایان لیست',
                            style: TextStyle(
                              fontFamily: "Dana",
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
