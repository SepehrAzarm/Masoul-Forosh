import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masoul_kharid/Classes/Dialogs/error_dialog.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Screens/BottomSheets/active_days.dart';
import 'package:masoul_kharid/Screens/login_page.dart';
import 'package:masoul_kharid/Screens/profile_screen.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);
  static const String id = 'AccountSettings';
  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final TextEditingController _address = TextEditingController();
  final String helpImageAsset = 'images/Icons/HelpIcon.png';
  final storage = const FlutterSecureStorage();
  final ImagePicker _picker = ImagePicker();
  List activeDays = [];
  String? address;
  String? errorText;
  bool visible = false;
  late File imageFile;
  String? imagePath;
  var newImage;
  Future getMarketInfo() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {'token': value!};
    try {
      var response = await http.get(
        Uri.parse('https://testapi.carbon-family.com/api/market/profile'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var data = response.body;
        var marketInfo = jsonDecode(data)['market'];
        print(marketInfo);
        setState(() {
          imagePath = marketInfo["logo"];
          address = marketInfo["locationInfo"]["address"];
          _address.text = '$address ';
        });
        print(response.statusCode);
        print(response.body);
      } else {
        if (response.statusCode == 401) {
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginPage.id,
            (Route<dynamic> route) => false,
          );}
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future chooseImage() async {
    var selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      var image = selectedImage;
      newImage = convertToFile(image);
    });
  }

  Future postImage() async {
    String? value = await storage.read(key: "token");
    String fileName = newImage.path.split('/').last;
    try {
      var dioRequest = Dio();
      dioRequest.options.baseUrl =
          'https://testapi.carbon-family.com/api/market/profile/uploadImage';
      dioRequest.options.headers = {
        'token': value!,
        "Content-Type": "multipart/from-data",
        'accept': "application/json"
      };
      var formData = FormData.fromMap({
        'marketImages': await MultipartFile.fromFile(
          newImage.path,
          filename: fileName,
          contentType: MediaType("image", "jpg"),
        )
      });
      var response = await dioRequest.post(
          'https://testapi.carbon-family.com/api/market/profile/uploadImage',
          data: formData);
      if (response.statusCode == 201) {
        print(response.statusCode);
        print(response.data);
        var path = await response.data['path'];
        setState(() {
          imagePath = path;
        });
        print(path);
      } else {
        print(response.statusCode);
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }

  File convertToFile(XFile? image) {
    var newImage = File(image!.path);
    return newImage;
  }

  Future putUpdateMarketProfile() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    Map data = {
      "logo": imagePath,
    };
    var body = jsonEncode(data);
    print(body);
    try {
      var response = await http.put(
        Uri.parse('https://testapi.carbon-family.com/api/market/profile'),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 201) {
        print(response.statusCode);
        print(response.body);
      } else {
        var errorData = await jsonDecode(response.body.toString());
        errorText = await errorData['message'];
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future putUpdateMarketAddress() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    Map data = {
      "address": address,
    };
    var body = jsonEncode(data);
    print(body);
    try {
      var response = await http.put(
        Uri.parse(
            'https://testapi.carbon-family.com/api/market/profile/location'),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 201) {
        print(response.statusCode);
        print(response.body);
      } else {
        var errorData = await jsonDecode(response.body.toString());
        errorText = await errorData['message'];
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future putUpdateMarketActiveDays() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    Map data = {
      "activeDays": activeDays,
    };
    var body = jsonEncode(data);
    print(body);
    try {
      var response = await http.put(
        Uri.parse(
            'https://testapi.carbon-family.com/api/market/profile/activeDaysAndHours'),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 201) {
        print(response.statusCode);
        print(response.body);
      } else {
        var errorData = await jsonDecode(response.body.toString());
        errorText = await errorData['message'];
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  profilePicFunc() {
    if (imagePath == null) {
      return const AssetImage(
        'images/staticImages/productStaticImage.jpg',
      );
    } else {
      return NetworkImage('https://testapi.carbon-family.com/${imagePath!}');
    }
  }

  @override
  void initState() {
    getMarketInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getMarketInfo,
      child: address == null
          ? const Center(
              child: CircularProgressIndicator(
              color: kOrangeColor,
            ))
          : Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.white,
              appBar: AppBar(
                toolbarHeight: 60,
                elevation: 0.2,
                backgroundColor: Colors.white,
                leading: BackButton(
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                centerTitle: true,
                title: const Text(
                  'تنظیمات حساب',
                  style: TextStyle(
                    fontFamily: 'IranYekan',
                    color: kOrangeColor,
                    fontSize: 15,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 15,
                      width: 25,
                      child: Center(
                        child: Image(
                          image: AssetImage(helpImageAsset),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    flex: 8,
                    child: ListView(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 220,
                              width: MediaQuery.of(context).size.width,
                              child: const Image(
                                image: AssetImage(
                                    'images/HeaderPics/profileheaderpic.jpg'),
                                fit: BoxFit.fill,
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 160),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 60,
                                  child: CircleAvatar(
                                    radius: 57,
                                    backgroundImage: profilePicFunc(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 70),
                              OrangeButton(
                                text: 'ویرایش عکس فروشگاه',
                                onPressed: () async {
                                  await chooseImage();
                                  await postImage();
                                },
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    address = value;
                                  });
                                },
                                controller: _address,
                                cursorColor: kButtonOrangeColor,
                                decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kOrangeColor,
                                      width: 2.0,
                                    ),
                                  ),
                                  hintText: 'آدرس',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Dana',
                                    fontSize: 13,
                                    color: Color(0xFFE5E5E5),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              OrangeButton(
                                text: 'ویرایش روز های فعال',
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          const ActiveDaysBSH()).then((value) {
                                    print(value);
                                    setState(() {
                                      activeDays = value;
                                    });
                                  });
                                },
                              ),
                              const SizedBox(height: 30),
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
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: OrangeButton(
                      text: 'تایید',
                      onPressed: () async {
                        setState(() {
                          visible = true;
                        });
                        if (visible == true) {
                          await putUpdateMarketProfile();
                          await putUpdateMarketAddress();
                          if (activeDays.isNotEmpty) {
                            await putUpdateMarketActiveDays();
                          }
                          errorText == null
                              // ignore: use_build_context_synchronously
                              ? Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  ProfileScreen.id,
                                  (Route<dynamic> route) => false,
                                )
                              : showDialog(
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
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
