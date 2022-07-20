import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masoul_kharid/Screens/login_page.dart';
import 'package:masoul_kharid/Services/storage_class.dart';

class EmployeeProfile extends StatefulWidget {
  const EmployeeProfile({Key? key}) : super(key: key);
  static const String id = 'EmployeeProfile';

  @override
  State<EmployeeProfile> createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  List<dynamic> marketAdminUserAccess = [];
  Map accessMap = {};
  List accessListKeys = [];
  List accessListValues = [];
  List toggled = [];
  final storage = const FlutterSecureStorage();
  bool visible = false;
  bool history = false;
  bool marketProfile = false;
  bool products = false;
  bool news = false;
  String? image;
  String? firstName;
  String? lastName;
  String? mobile;
  String? role;
  String? errorText;
  bool? status;

  getAccessInfo() async {
    await getEmployeeInfo();
    marketAdminUserAccess.contains('products')
        ? products = true
        : products = false;
    marketAdminUserAccess.contains('history')
        ? history = true
        : history = false;
    marketAdminUserAccess.contains('marketProfile')
        ? marketProfile = true
        : marketProfile = false;
    marketAdminUserAccess.contains('news') ? news = true : news = false;
  }

  Future getEmployeeInfo() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    try {
      var response = await http.get(
        Uri.parse(
            "https://testapi.carbon-family.com/api/market/users/${Storage.employeeId}"),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var data = response.body;
        setState(() {
          firstName = jsonDecode(data)["user"]["firstName"];
          lastName = jsonDecode(data)["user"]["lastName"];
          mobile = jsonDecode(data)["user"]["mobile"];
          status = jsonDecode(data)["user"]["status"];
          image = jsonDecode(data)["user"]["profileImage"];
          role = jsonDecode(data)["user"]["role"];
          marketAdminUserAccess = jsonDecode(data)["user"]["access"];
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

  Future getEmployeeAccessList() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    try {
      var response = await http.get(
        Uri.parse(
            "https://testapi.carbon-family.com/api/market/users/access/list"),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var data = response.body;
        setState(() {
          accessMap = jsonDecode(data)["data"];
          accessMap.forEach((key, value) {
            accessListKeys.add(key);
            accessListValues.add(value);
          });
          print(accessListKeys);
          print(accessListValues);
        });
        print(response.statusCode);
        // print(response.body);
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future putEditEmployeeAccess() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    Map data = {
      "userId": Storage.employeeId,
      "access": marketAdminUserAccess,
    };
    var body = jsonEncode(data);
    try {
      var response = await http.put(
          Uri.parse("https://testapi.carbon-family.com/api/market/users"),
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

  Future putEditEmployeeStatus() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    Map data = {
      "userId": Storage.employeeId,
      "status": false,
    };
    var body = jsonEncode(data);
    try {
      var response = await http.put(
          Uri.parse("https://testapi.carbon-family.com/api/market/users"),
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
    getAccessInfo();
    getEmployeeAccessList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getEmployeeInfo,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 65,
          elevation: 0.2,
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: const BackButton(
            color: Colors.black,
          ),
          title: const Text(
            'پروفایل',
            style: TextStyle(
              fontFamily: 'IranYekan',
              color: kOrangeColor,
              fontSize: 20,
            ),
          ),
        ),
        body: firstName == null
            ? const Center(
                child: CircularProgressIndicator(
                color: kOrangeColor,
              ))
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 160,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 130,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        //Content Picture
                                        SizedBox(
                                          width: 130,
                                          height: 130,
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundImage: NetworkImage(image ==
                                                    null
                                                ? 'https://testapi.carbon-family.com/uploads/users/usersProfileImages/cacf6b802a0e391967d195af9d43b1cc_6246f113965272bf7ca06282_1648817834578.png'
                                                : 'https://testapi.carbon-family.com/' +
                                                    image!),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        //Content Text
                                        SizedBox(
                                          height: 65,
                                          width: 230,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //Header Text
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6),
                                                child: Text(
                                                  '$firstName $lastName',
                                                  style: const TextStyle(
                                                    color:
                                                        kNewsCardHeaderTextColor,
                                                    fontFamily: 'IranYekan',
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              //Content Text
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6),
                                                child: Text(
                                                  status == true
                                                      ? 'فعال'
                                                      : 'غیر فغال',
                                                  style: const TextStyle(
                                                    color: Color(0xFF414141),
                                                    fontFamily: 'Dana',
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              child: Text(
                                'شماره تماس: $mobile',
                                style: const TextStyle(
                                  fontFamily: 'IranYekan',
                                  fontSize: 14,
                                  color: kBottomSheetTextColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              child: Text(
                                role == "owner" ? 'سمت: مدیر' : 'سمت: کارمند',
                                style: const TextStyle(
                                  fontFamily: 'IranYekan',
                                  fontSize: 14,
                                  color: kBottomSheetTextColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            height: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 40,
                                  child: Text(
                                    'دسترسی ها:',
                                    style: TextStyle(
                                      fontFamily: 'Dana',
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: accessListValues.length,
                                      itemBuilder: (context, int index) {
                                        if (marketAdminUserAccess
                                            .contains(accessListKeys[index])) {
                                          toggled.add(index);
                                        }
                                        return SizedBox(
                                          height: 35,
                                          width: 175,
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                activeColor: kButtonOrangeColor,
                                                value: toggled.contains(index)
                                                    ? true
                                                    : false,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    if (toggled
                                                        .contains(index)) {
                                                      toggled.clear();
                                                      marketAdminUserAccess
                                                          .remove(
                                                              accessListKeys[
                                                                  index]);
                                                    } else {
                                                      toggled.add(index);
                                                      marketAdminUserAccess.add(
                                                          accessListKeys[
                                                              index]);
                                                    }
                                                  });
                                                },
                                              ),
                                              Text(
                                                '${accessListValues[index]}',
                                                style: const TextStyle(
                                                  fontFamily: 'Dana',
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
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
                              text: 'تایید دسترسی ها',
                              onPressed: () async {
                                print(marketAdminUserAccess);
                                setState(() {
                                  visible = true;
                                });
                                await putEditEmployeeAccess();
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
                                        })
                                    : showDialog(
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
                                              'عملیات با موفقیت انجام شد',
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
                                                      errorText = null;
                                                      visible = false;
                                                    });
                                                    Navigator.pop(context);
                                                  })
                                            ],
                                          );
                                        });
                              }),
                          SizedBox(
                            height: 80,
                            child: TextButton(
                              onPressed: () async {
                                setState(() {
                                  visible = true;
                                });
                                await putEditEmployeeStatus();
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
                                        })
                                    : showDialog(
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
                                              'عملیات با موفقیت انجام شد',
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
                                                      errorText = null;
                                                      visible = false;
                                                    });
                                                    Navigator.pop(context);
                                                  })
                                            ],
                                          );
                                        });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF0000),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                width: 370.0,
                                height: 57.0,
                                child: const Center(
                                  child: Text(
                                    'تعلیق',
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
