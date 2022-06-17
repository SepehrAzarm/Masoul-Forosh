import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiManager {
  final storage = const FlutterSecureStorage();
  Future<String> authenticateUser(String? phoneNumber, String? password) async {
    String token = '';
    try {
      var response = await http.post(
          Uri.parse(
              'https://testapi.carbon-family.com/api/admin/authentication/login'),
          body: {
            'mobile': phoneNumber,
            'password': password,
          });
      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body.toString());
        token = await data['token'];
        print("Hello World");
        print(response.statusCode);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
    return token;
  }

  void getOTPVerify() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {'token': value!};
    try {
      var response = await http.get(
        Uri.parse(
            'https://testapi.carbon-family.com/api/admin/authentication/verify'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> postOTPVerify(String? code, String token) async {
    String newToken = '';
    Map<String, String> headers = {'token': token};
    var response = await http.post(
        Uri.parse(
            'https://testapi.carbon-family.com/api/admin/authentication/verify'),
        headers: headers,
        body: {
          'verificationCode': code,
        });
    if (response.statusCode == 200) {
      var data = await jsonDecode(response.body.toString());
      newToken = await data['token'];
      print(response.statusCode);
    } else {
      print(response.statusCode);
      print(response.body);
    }
    return newToken;
  }
}
