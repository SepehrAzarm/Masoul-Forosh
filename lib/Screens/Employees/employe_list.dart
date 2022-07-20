import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:masoul_kharid/Classes/Cards/employee_list_card.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Screens/Employees/employee_profile.dart';
import 'package:masoul_kharid/Screens/login_page.dart';
import 'package:masoul_kharid/Screens/profile_screen.dart';
import 'package:masoul_kharid/Services/storage_class.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);
  static const String id = 'EmployeeListScreen';

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  List employeeNames = [];
  List employeeLastName = [];
  List employeeImages = [];
  List employeeStatus = [];
  List employeeIdList = [];

  final storage = const FlutterSecureStorage();

  Future getEmployeeList() async {
    var queryParameters = {
      'role': 'owner',
    };
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {'token': value!};
    try {
      var response = await http.get(
          Uri.parse(
            "https://testapi.carbon-family.com/api/market/users",
          ),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var employee = jsonDecode(data)["users"];
        setState(() {
          for (var i = 0; i < employee.length; i++) {
            employeeNames.add(employee[i]["firstName"]);
            employeeLastName.add(employee[i]["lastName"]);
            employeeImages.add(employee[i]["profileImage"]);
            employeeStatus.add(employee[i]["status"]);
            employeeIdList.add(employee[i]["_id"]);
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
      }

    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getEmployeeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0.2,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, ProfileScreen.id, (Route<dynamic> route) => false);
          },
        ),
        title: const Text(
          'لیست کارمندان',
          style: TextStyle(
            fontFamily: 'IranYekan',
            color: kOrangeColor,
            fontSize: 17,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: employeeNames.isNotEmpty ? employeeNames.length : 0,
          itemBuilder: (context, int index) {
            return EmployeeListCard(
              onTap: () {
                Storage.employeeId = employeeIdList[index];
                Navigator.pushNamed(context, EmployeeProfile.id);
              },
              name: employeeNames[index] + ' ' + employeeLastName[index],
              status: employeeStatus[index] == true ? 'فعال' : 'غیر فغال',
              image: employeeImages[index] == null
                  ? 'https://testapi.carbon-family.com/uploads/users/usersProfileImages/cacf6b802a0e391967d195af9d43b1cc_6246f113965272bf7ca06282_1648817834578.png'
                  : 'https://testapi.carbon-family.com/' +
                      employeeImages[index],
            );
          },
        ),
      ),
    );
  }
}
