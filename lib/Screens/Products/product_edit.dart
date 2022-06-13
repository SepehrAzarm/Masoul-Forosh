import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masoukharid/Classes/Text&TextStyle/orange_header_text.dart';
import 'package:masoukharid/Classes/amount_card.dart';
import 'package:masoukharid/Classes/orange_button.dart';
import 'package:masoukharid/Constants/borders_decorations.dart';
import 'package:masoukharid/Constants/colors.dart';
import 'package:masoukharid/Constants/constants.dart';
import 'package:masoukharid/Screens/Products/products_mainpage.dart';
import 'package:masoukharid/Services/storage_class.dart';

class ProductEdit extends StatefulWidget {
  const ProductEdit({Key? key}) : super(key: key);
  static const String id = 'ProductEdit';

  @override
  State<ProductEdit> createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  final TextEditingController _availableController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  final TextEditingController _orderBoundary = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool? isChecked = false;
  bool visible = false;
  String? availableAmount;
  String? orderBoundary;
  int? newAvailableAmount;
  late File imageFile;
  bool enabled = true;
  String? description;
  String? imagePath;
  String? title;
  String? errorText;
  List availableImage = [];
  // ignore: prefer_typing_uninitialized_variables
  var newImage;
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

  Future getProductInfo() async {
    Map<String, String> headers = {'token': Storage.token};

    try {
      var response = await http.get(
        Uri.parse(
            "https://testapi.carbon-family.com/api/market/products/${Storage.productId}"),
        headers: headers,
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        var data = response.body;
        setState(() {
          title = jsonDecode(data)["product"]["title"];
          description = jsonDecode(data)["product"]["descriptions"];
          availableAmount =
              jsonDecode(data)["product"]["availableAmount"].toString();
          availableImage = jsonDecode(data)["product"]["media"];
        });
      } else {
        print(response.body);
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future putEditProductInfo() async {
    Map<String, String> headers = {
      'token': Storage.token,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    Map<String, dynamic> data = {
      "productId": Storage.productId,
      "title": title,
      "descriptions": description,
      "media": [
        imagePath,
      ],
      "availableAmount": newAvailableAmount,
      "categoryId": "6246f05faca10face61bdf57",
      "orderBoundery": {
        "minAmount": orderBoundary,
      }
    };
    var body = jsonEncode(data);
    try {
      var response = await http.put(
          Uri.parse("https://testapi.carbon-family.com/api/market/products"),
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
    String fileName = newImage.path.split('/').last;
    try {
      var dioRequest = Dio();
      dioRequest.options.baseUrl =
          'https://testapi.carbon-family.com/api/market/products/uploadImage';
      dioRequest.options.headers = {
        'token': Storage.token,
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
  void initState() {
    getProductInfo();
    super.initState();
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
      body: availableImage.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
              color: kOrangeColor,
            ))
          : Padding(
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
                          text: 'ویرایش محصول',
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
                                    ? 'https://testapi.carbon-family.com/' +
                                        availableImage[0]
                                    : 'https://testapi.carbon-family.com/${imagePath!}'),
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
                                'ویرایش عکس محصول',
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
                          decoration: InputDecoration(
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: kOrangeColor,
                                width: 2.0,
                              ),
                            ),
                            hintText: '$title',
                            hintStyle: const TextStyle(
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
                            decoration: InputDecoration(
                              hintText: '$description',
                              hintStyle: const TextStyle(
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
                          onChanged: (value) {
                            setState(() {
                              newAvailableAmount = int.parse(value);
                            });
                          },
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
                          enabled: enabled,
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
                          onChanged: (value) {},
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
                                  enabled = !value;
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
                        const SizedBox(height: 60),
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
                              if (imagePath == null) {
                                imagePath = availableImage[0];
                                print(title);
                                print(description);
                                setState(() {
                                  visible = true;
                                });
                                await putEditProductInfo();
                                // ignore: unnecessary_null_comparison
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
                                    : Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        ProductsMainPage.id,
                                        (Route<dynamic> route) => false,
                                      );
                                deactivate();
                                print(errorText);
                              } else {
                                // Navigator.pushNamedAndRemoveUntil(
                                //   context,
                                //   ProductsMainPage.id,
                                //   (Route<dynamic> route) => false,
                                // );
                                print("Error");
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