import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masoukharid/Classes/orange_button.dart';
import 'package:masoukharid/Constants/colors.dart';
import 'package:masoukharid/Screens/profile_screen.dart';

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
  String? address;
  String? province;
  String? city;
  String? zipCode;
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
          province = marketInfo["locationInfo"]["province"];
          city = marketInfo["locationInfo"]["city"];
          zipCode = marketInfo["locationInfo"]["zipCode"];
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
      "locationInfo": {
        "address": address,
        "province": province,
        "city": city,
        "zipCode": zipCode,
        "longitude": 1.1,
        "latitude": 1.1
      },
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
              body: ListView(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 220,
                        color: Colors.amberAccent,
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
                              backgroundImage: NetworkImage(
                                imagePath != null
                                    ? 'https://testapi.carbon-family.com/' +
                                        imagePath!
                                    : 'https://testapi.carbon-family.com/uploads/markets/marketImages/7185b4aa4494c37820e2d4abfefc6166_6246f113965272bf7ca06282_1648818031253.jpg',
                              ),
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
                        TextButton(
                          onPressed: () async {
                            await chooseImage();
                            await postImage();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: kOrangeColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: 370.0,
                            height: 57.0,
                            child: const Center(
                              child: Text(
                                'ویرایش عکس فروشگاه',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Dana',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       children: const [
                        //         SizedBox(
                        //           height: 30,
                        //           child: TextFieldLabel(text: 'آدرس'),
                        //         ),
                        //         SizedBox(
                        //           width: 3,
                        //         ),
                        //         Text(
                        //           '*',
                        //           style: TextStyle(
                        //             color: Colors.red,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     SizedBox(
                        //       height: 28,
                        //       child: TextField(
                        //         controller: _address,
                        //         onChanged: (String value) {
                        //           address = value;
                        //         },
                        //         cursorColor: kButtonOrangeColor,
                        //         decoration: InputDecoration(
                        //           focusedBorder: const UnderlineInputBorder(
                        //             borderSide: BorderSide(
                        //               color: kButtonOrangeColor,
                        //               width: 2.0,
                        //             ),
                        //           ),
                        //           hintText: '$address',
                        //           hintStyle: const TextStyle(
                        //             fontSize: 11,
                        //             color: kTextFieldHintTextColor,
                        //             fontFamily: 'Dana',
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(height: 130),
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
                          text: 'تایید',
                          onPressed: () async {
                            setState(() {
                              visible = true;
                            });
                            if (visible == true) {
                              await putUpdateMarketProfile();
                              errorText == null
                                  ? Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      ProfileScreen.id,
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
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
