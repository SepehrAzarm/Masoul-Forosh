import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/textfield_label_text_style.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Screens/Employees/employe_list.dart';

class AddNewEmployee extends StatefulWidget {
  const AddNewEmployee({Key? key}) : super(key: key);
  static const String id = 'AddNewEmployeeScreen';

  @override
  State<AddNewEmployee> createState() => _AddNewEmployeeState();
}

class _AddNewEmployeeState extends State<AddNewEmployee> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordConfirmation = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final storage = const FlutterSecureStorage();
  final ImagePicker _picker = ImagePicker();
  late File imageFile;
  var newImage;
  String? imagePath;
  String? firstName;
  String? lastName;
  String? mobile;
  String? password;
  String? passwordConfirmation;
  String? email;
  bool obsText = true;
  bool visible = false;
  String? errorText;

  Future postAddNewEmployee() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    Map data = {
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
      "profileImage": imagePath,
      "role": "support",
      "access": ["products"],
      "email": email
    };
    var body = jsonEncode(data);
    try {
      var response = await http.post(
          Uri.parse('https://testapi.carbon-family.com/api/market/users'),
          headers: headers,
          body: body);
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

  Future chooseImage() async {
    var selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      var image = selectedImage;
      newImage = convertToFile(image);
    });
  }

  File convertToFile(XFile? image) {
    var newImage = File(image!.path);
    return newImage;
  }

  Future postImage() async {
    String? value = await storage.read(key: "token");
    String fileName = newImage.path.split('/').last;
    try {
      var dioRequest = Dio();
      dioRequest.options.baseUrl =
          'https://testapi.carbon-family.com/api/market/users/uploadImage';
      dioRequest.options.headers = {
        'token': value!,
        "Content-Type": "multipart/from-data",
        'accept': "application/json"
      };
      var formData = FormData.fromMap({
        'usersProfileImages': await MultipartFile.fromFile(
          newImage.path,
          filename: fileName,
          contentType: MediaType("image", "jpg"),
        )
      });
      var response = await dioRequest.post(
          'https://testapi.carbon-family.com/api/market/users/uploadImage',
          data: formData);
      if (response.statusCode == 201) {
        print(response.statusCode);
        print(response.data);
        var path = await response.data['path'];
        setState(() {
          imagePath = path;
        });
      } else {
        print(response.statusCode);
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        elevation: 0.2,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black,
        ),
        title: const Text(
          'کارمند جدید',
          style: TextStyle(
            fontFamily: 'IranYekan',
            color: kOrangeColor,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //First Name
                const SizedBox(height: 20),
                SizedBox(
                  height: 110,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await chooseImage();
                          await postImage();
                        },
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFFFFDFC2),
                          radius: 55,
                          backgroundImage: NetworkImage(imagePath == null
                              ? 'https://testapi.carbon-family.com/uploads/users/usersProfileImages/cacf6b802a0e391967d195af9d43b1cc_6246f113965272bf7ca06282_1648817834578.png'
                              : 'https://testapi.carbon-family.com/' +
                                  imagePath!),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              SizedBox(
                                height: 30,
                                child: TextFieldLabel(text: 'نام'),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 28,
                            width: 240,
                            child: TextField(
                              controller: _firstName,
                              onChanged: (String value) {
                                setState(() {
                                  firstName = value;
                                });
                              },
                              cursorColor: kButtonOrangeColor,
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kButtonOrangeColor,
                                    width: 2.0,
                                  ),
                                ),
                                hintText: 'نام خود را وارد کنید',
                                hintStyle: TextStyle(
                                  fontSize: 11,
                                  color: kTextFieldHintTextColor,
                                  fontFamily: 'Dana',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // lastName
                const SizedBox(height: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(
                          height: 30,
                          child: TextFieldLabel(text: 'نام خانوادگی'),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 28,
                      child: TextField(
                        controller: _lastName,
                        onChanged: (String value) {
                          setState(() {
                            lastName = value;
                          });
                        },
                        cursorColor: kButtonOrangeColor,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: kButtonOrangeColor,
                              width: 2.0,
                            ),
                          ),
                          hintText: 'نام خانوادگی خود را وارد کنید',
                          hintStyle: TextStyle(
                            fontSize: 11,
                            color: kTextFieldHintTextColor,
                            fontFamily: 'Dana',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //Email
                const SizedBox(height: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(
                          height: 30,
                          child: TextFieldLabel(text: 'آدرس ایمیل'),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 28,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _email,
                        onChanged: (String value) {
                          setState(() {
                            email = value;
                          });
                        },
                        cursorColor: kButtonOrangeColor,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: kButtonOrangeColor,
                              width: 2.0,
                            ),
                          ),
                          hintText: 'ایمیل ادمین را وارد کنید',
                          hintStyle: TextStyle(
                            fontSize: 11,
                            color: kTextFieldHintTextColor,
                            fontFamily: 'Dana',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //mobile
                const SizedBox(height: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(
                          height: 30,
                          child: TextFieldLabel(text: 'شماره موبایل'),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 28,
                      child: TextField(
                        controller: _mobile,
                        onChanged: (String value) {
                          setState(() {
                            mobile = value;
                          });
                        },
                        keyboardType: TextInputType.number,
                        cursorColor: kButtonOrangeColor,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: kButtonOrangeColor,
                              width: 2.0,
                            ),
                          ),
                          hintText: 'شماره موبایل ادمین را وارد کنید',
                          hintStyle: TextStyle(
                            fontSize: 11,
                            color: kTextFieldHintTextColor,
                            fontFamily: 'Dana',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //passWord
                const SizedBox(height: 30.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(
                          height: 30,
                          child: TextFieldLabel(text: 'رمز عبور'),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 28,
                      child: TextField(
                        obscureText: obsText,
                        controller: _password,
                        onChanged: (String value) {
                          setState(() {
                            password = value;
                          });
                        },
                        cursorColor: kButtonOrangeColor,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            iconSize: 20.0,
                            icon: Icon(obsText == true
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                obsText == true
                                    ? obsText = false
                                    : obsText = true;
                              });
                            },
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: kButtonOrangeColor,
                              width: 2.0,
                            ),
                          ),
                          hintText: 'رمز عبور را وارد کنید',
                          hintStyle: const TextStyle(
                            fontSize: 11,
                            color: kTextFieldHintTextColor,
                            fontFamily: 'Dana',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //Password Confirmation
                const SizedBox(height: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(
                          height: 30,
                          child: TextFieldLabel(text: 'تکرار رمز عبور'),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 28,
                      child: TextField(
                        obscureText: true,
                        controller: _passwordConfirmation,
                        onChanged: (String value) {
                          setState(() {
                            passwordConfirmation = value;
                          });
                        },
                        cursorColor: kButtonOrangeColor,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: kButtonOrangeColor,
                              width: 2.0,
                            ),
                          ),
                          hintText: 'تکرار رمز عبور را وارد کنید',
                          hintStyle: TextStyle(
                            fontSize: 11,
                            color: kTextFieldHintTextColor,
                            fontFamily: 'Dana',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const SizedBox(
                  width: 350,
                  height: 20,
                  child: Text(
                    'رمز عبور باید شامل حروف بزرگ و کوچک انگلیسی و اعداد باشد.',
                    style: TextStyle(
                      fontFamily: 'IranYekan',
                      fontSize: 10,
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  width: 350,
                  height: 40,
                  child: Text(
                    'عکس پروفایل باید با فرمت jpg باشد و حجم آن کمتر از 15 مگابایت باشد',
                    style: TextStyle(
                      fontFamily: 'IranYekan',
                      fontSize: 10,
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(height: 80),
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
                    text: 'ثبت',
                    onPressed: () async {
                      if (firstName != null) {
                        if (password == passwordConfirmation) {
                          await postAddNewEmployee();
                          // ignore: unnecessary_null_comparison
                          errorText == null
                              ? Navigator.pushNamed(context, EmployeeList.id)
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
                        } else {
                          showDialog(
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
                                  content: const Text(
                                    'رمز عبور مطابقت ندارد',
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
                      } else {
                        if (firstName == null &&
                            lastName == null &&
                            mobile == null &&
                            password == null) {
                          showDialog(
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
                                  content: const Text(
                                    'اطلاعات وارد شده صحیح',
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
                                            visible = false;
                                            errorText = null;
                                          });
                                          Navigator.pop(context);
                                        })
                                  ],
                                );
                              });
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
