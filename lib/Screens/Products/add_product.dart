import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masoukharid/Classes/Text&TextStyle/orange_header_text.dart';
import 'package:masoukharid/Classes/amount_card.dart';
import 'package:masoukharid/Classes/orange_button.dart';
import 'package:masoukharid/Constants/borders_decorations.dart';
import 'package:masoukharid/Constants/colors.dart';
import 'package:masoukharid/Constants/constants.dart';
import 'package:masoukharid/Screens/profile_screen.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);
  static const String id = 'AddProductPage';

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _availableController = TextEditingController();
  final TextEditingController _orderBoundary = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  final storage = const FlutterSecureStorage();
  final ImagePicker _picker = ImagePicker();
  late File imageFile;
  // ignore: prefer_typing_uninitialized_variables
  var newImage;
  String? imagePath;
  bool? isChecked = false;
  bool visible = false;
  bool _enabled = true;
  String? title;
  String? description;
  int? availableAmount;
  String? errorMassage;
  String? orderBoundary;
  String dropDownValue = 'تعداد';
  String amountMainText = '';
  String amountSecText = '';
  String mainText() {
    if (dropDownValue == 'تعداد' ||
        dropDownValue == 'بسته' ||
        dropDownValue == 'جین') {
      amountMainText = 'مقدار موجود';
    } else {
      amountMainText = 'میزان موجود';
    }
    return amountMainText;
  }

  String secondaryText() {
    if (dropDownValue == 'تعداد' ||
        dropDownValue == 'بسته' ||
        dropDownValue == 'جین' ||
        dropDownValue == 'پالت') {
      amountSecText = 'تعداد';
    } else if (dropDownValue == 'وزن') {
      amountSecText = 'کیلوگرم';
    } else if (dropDownValue == 'لیتر') {
      amountSecText = 'لیتر';
    }
    return amountSecText;
  }

  Future postCreateNewProduct() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    Map data = {
      "title": title,
      "descriptions": description,
      "media": [
        imagePath,
      ],
      "categoryId": "6246f05faca10face61bdf57",
      "isAvailableEnough": false,
      "availableAmount": availableAmount,
      "priceBeforeDiscount": 0,
      "price": 0,
      "discountPerAmount": {
        "status": false,
        "minOrderAmount": 0,
        "perAmount": 0,
        "type": "percent",
        "amount": 0
      },
      "orderBoundery": {
        "minAmount": orderBoundary,
      }
    };
    var body = jsonEncode(data);
    try {
      var response = await http.post(
        Uri.parse('https://testapi.carbon-family.com/api/market/products'),
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
          'https://testapi.carbon-family.com/api/market/products/uploadImage';
      dioRequest.options.headers = {
        'token': value!,
        "Content-Type": "multipart/from-data",
        'accept': "application/json"
      };
      var formData = FormData.fromMap({
        'productsImages': await MultipartFile.fromFile(
          newImage.path,
          filename: fileName,
          contentType: MediaType("image", "jpg"),
        )
      });
      var response = await dioRequest.post(
          'https://testapi.carbon-family.com/api/market/products/uploadImage',
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  OrangeHeaderText(
                    text: 'افزودن محصول',
                    fontSize: 35,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'ویرایش عکس',
                    style: TextStyle(
                      fontFamily: 'Dana',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kNewsCardHeaderTextColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: Container(
                        color: Colors.amber,
                        width: 250,
                        height: 250,
                        child: Image(
                          image: NetworkImage(imagePath == null
                              ? 'https://testapi.carbon-family.com/uploads/products/productsImages/635dc499204c404d99b3c3484b7c96fd_6246f113965272bf7ca06282_1648817959178.jpg'
                              : 'https://testapi.carbon-family.com/' +
                                  imagePath!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
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
                          'افزودن عکس محصول',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Dana',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(
                    width: 350,
                    height: 40,
                    child: Text(
                      'عکس پروفایل باید با فرمت jpg باشد و ابعاد 1x1 باشد و حجم آن کمتر از 15 مگابایت باشد',
                      style: TextStyle(
                        fontFamily: 'IranYekan',
                        fontSize: 10,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'ویرایش متن',
                    style: TextStyle(
                      fontFamily: 'Dana',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kNewsCardHeaderTextColor,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                      hintText: 'عنوان محصول',
                      hintStyle: TextStyle(
                        fontFamily: 'Dana',
                        fontSize: 13,
                        color: Color(0xFFE5E5E5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          description = value;
                        });
                      },
                      textAlign: TextAlign.start,
                      maxLines: null,
                      minLines: null,
                      expands: true,
                      cursorColor: kButtonOrangeColor,
                      decoration: const InputDecoration(
                        hintText: '  توضیحات محصول را وارد کنید',
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
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      'تعداد کاراکتر: 300',
                      style: TextStyle(
                        fontFamily: 'IranYekan',
                        fontSize: 10,
                        color: kTextFieldHintTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  const Text(
                    'ویرایش مقدار',
                    style: TextStyle(
                      fontFamily: 'Dana',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kNewsCardHeaderTextColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButton(
                    value: dropDownValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropDownValue = newValue!;
                      });
                    },
                    items: <String>[
                      'تعداد',
                      'جین',
                      'وزن',
                      'بسته',
                      'لیتر',
                      'پالت'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  AmountWidget(
                    onChanged: (value) {
                      setState(() {
                        availableAmount = int.parse(value);
                      });
                    },
                    controller: _availableController,
                    mainText: mainText(),
                    secondaryText: secondaryText(),
                    suffixIcon: IconButton(
                      iconSize: 20,
                      color: const Color(0xFF4B4B4B),
                      onPressed: () {
                        setState(() {
                          _availableController.clear();
                        });
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AmountWidget(
                    onChanged: (value) {
                      setState(() {
                        orderBoundary = value;
                      });
                    },
                    controller: _orderBoundary,
                    mainText: 'کف فروش',
                    secondaryText: '',
                    suffixIcon: IconButton(
                      iconSize: 20,
                      color: const Color(0xFF4B4B4B),
                      onPressed: () {
                        setState(() {
                          _orderBoundary.clear();
                        });
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AmountWidget(
                    onChanged: (value) {},
                    enabled: _enabled,
                    controller: _limitController,
                    mainText: 'محدودیت فروش',
                    secondaryText: '',
                    suffixIcon: IconButton(
                      iconSize: 20,
                      color: const Color(0xFF4B4B4B),
                      onPressed: () {
                        setState(() {
                          _limitController.clear();
                        });
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                  //Check Box
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        activeColor: kButtonOrangeColor,
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                            _enabled = !value;
                          });
                        },
                      ),
                      const Text(
                        'نامحدود',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4B4B4B),
                          fontSize: 12.0,
                          fontFamily: 'Dana',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  //Slider
                  // SizedBox(
                  //   height: 130,
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       const Padding(
                  //         padding: EdgeInsets.only(right: 20.0),
                  //         child: Text(
                  //           'مقدار تخفیف',
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             color: kTextFieldLabelTextColor,
                  //             fontSize: 20.0,
                  //             fontFamily: kTextFontsFamily,
                  //           ),
                  //         ),
                  //       ),
                  //       Slider(
                  //         min: 0,
                  //         max: 100,
                  //         activeColor: kButtonOrangeColor,
                  //         inactiveColor: kSliderInActiveColor,
                  //         value: _sliderValue,
                  //         onChanged: (double value) {
                  //           setState(() {
                  //             _sliderValue = value;
                  //           });
                  //         },
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.only(right: 20.0),
                  //         child: Row(
                  //           children: [
                  //             Text(
                  //               _sliderValue.toStringAsFixed(0),
                  //               style: const TextStyle(
                  //                 fontWeight: FontWeight.bold,
                  //                 color: kTextFieldLabelTextColor,
                  //                 fontSize: 20.0,
                  //                 fontFamily: kTextFontsFamily,
                  //               ),
                  //             ),
                  //             const Text(
                  //               '%',
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.bold,
                  //                 color: kTextFieldLabelTextColor,
                  //                 fontSize: 20.0,
                  //                 fontFamily: kTextFontsFamily,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
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
                  const SizedBox(height: 60),
                  OrangeButton(
                      text: 'تایید',
                      onPressed: () async {
                        setState(() {
                          visible = true;
                        });
                        if (title != null && description != null) {
                          await postCreateNewProduct();
                          // ignore: unnecessary_null_comparison
                          errorMassage == null
                              ? Navigator.pushNamed(context, ProfileScreen.id)
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
                                                visible = false;
                                                errorMassage = null;
                                              });
                                              Navigator.pop(context);
                                            })
                                      ],
                                    );
                                  });
                        } else {
                          setState(() {
                            visible = false;
                          });
                          if (title == null &&
                              description == null &&
                              // ignore: unnecessary_null_comparison
                              availableAmount == null) {
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
                      }),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
