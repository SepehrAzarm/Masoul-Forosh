import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masoul_kharid/Classes/Dialogs/error_dialog.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/orange_header_text.dart';
import 'package:masoul_kharid/Classes/amount_card.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Classes/tax_widget.dart';
import 'package:masoul_kharid/Constants/borders_decorations.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Constants/constants.dart';
import 'package:masoul_kharid/Methods/text_field_input_decorations.dart';
import 'package:masoul_kharid/Screens/CategoryScreen/category_first_page.dart';
import 'package:masoul_kharid/Screens/profile_screen.dart';
import 'package:masoul_kharid/Services/storage_class.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);
  static const String id = 'AddProductPage';

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _availableController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  final TextEditingController _priceForMarket = TextEditingController();
  final TextEditingController _taxPercentage = TextEditingController();
  final TextEditingController _orderBoundary = TextEditingController();
  final TextEditingController _originalPrice = TextEditingController();
  final TextEditingController _taxValue = TextEditingController();
  final storage = const FlutterSecureStorage();
  final ImagePicker _picker = ImagePicker();
  late File imageFile;
  // ignore: prefer_typing_uninitialized_variables
  var newImage;
  List<String> categoryList = [];
  List<String> secList = [];
  String categoryDropDownValue = 'کیک و دسر';
  String secCategoryDropDownValue = '';
  String dropDownValue = 'تعداد';
  String amountMainText = '';
  String amountSecText = '';
  int? minOrderBoundary;
  int? maxOrderBoundary;
  String? errorMassage;
  String? description;
  String? categoryName;
  String? imagePath;
  String? title;
  bool isAvailableEnough = false;
  bool minOrderBoundaryChecked = false;
  bool? catHasChildren;
  bool secCatVisible = false;
  bool? isChecked = false;
  bool taxIsChecked = true;
  bool taxTypeValue = false;
  bool taxTypePercent = false;
  bool visible = false;
  bool _enabled = true;
  bool _enabledForAmount = true;
  bool _enabledMinOrderBoundary = true;
  int? availableAmount;
  int? priceForMarket;
  int? originalPrice;
  int taxPercentage = 0;
  int taxValue = 0;

  String mainText() {
    if (dropDownValue == 'تعداد ' ||
        dropDownValue == 'بسته ' ||
        dropDownValue == 'پالت ') {
      amountMainText = 'مقدار موجود ';
    } else {
      amountMainText = 'میزان موجود ';
    }
    return amountMainText;
  }

  String secondaryText() {
    if (dropDownValue == 'تعداد' ||
        dropDownValue == 'بسته' ||
        dropDownValue == 'جین' ||
        dropDownValue == 'پالت') {
      amountSecText = 'تعداد';
    } else if (dropDownValue == 'کیلوگرم') {
      amountSecText = 'کیلوگرم';
    } else if (dropDownValue == 'گرم') {
      amountSecText = 'گرم';
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
      "unit": dropDownValue,
      "categoryId": Storage.categoryId,
      "isAvailableEnough": isAvailableEnough,
      "availableAmount": availableAmount,
      "priceBeforeDiscount": 0,
      "originalPrice": originalPrice,
      "discountPerAmount": {
        "status": false,
        "minOrderAmount": 0,
        "perAmount": 0,
        "type": "percent",
        "amount": 0
      },
      "tax": {
        "status": taxIsChecked,
        "value": taxValue,
        "percentage": taxPercentage,
      },
      "orderBoundery": {
        "minAmount": minOrderBoundary,
        "maxAmount": maxOrderBoundary,
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
        setState(() {
          errorMassage = errorData['message'];
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

  Widget picFunc() {
    if (newImage != null) {
      return Image.file(
        File(newImage.path),
        fit: BoxFit.cover,
      );
    } else if (imagePath == null) {
      return const Image(
        fit: BoxFit.cover,
        image: AssetImage(
          'images/staticImages/productStaticImage.jpg',
        ),
      );
    } else {
      return Image(
        image: NetworkImage(
          'https://testapi.carbon-family.com/${imagePath!}',
        ),
        fit: BoxFit.cover,
      );
    }
  }

  Future getCategories() async {
    Map<String, String> queryParams = {
      'categoryId': Storage.categoryId,
    };
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    try {
      var response = await http.get(
        Uri.parse(
                "https://testapi.carbon-family.com/api/public/global/productsCategories")
            .replace(queryParameters: queryParams),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var data = response.body;
        var categories = jsonDecode(data)['category'];
        setState(() {
          categoryName = categories["title"];
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              ProfileScreen.id,
              (Route<dynamic> route) => false,
            );
          },
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
                  //Product Photo
                  const Text(
                    'افزودن عکس',
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
                        child: picFunc(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  OrangeButton(
                    text: 'افزودن عکس محصول',
                    onPressed: () async {
                      await chooseImage();
                    },
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
                  //Product Name and Description
                  const Text(
                    'افزودن متن',
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
                  const SizedBox(height: 40),
                  //Price
                  const Text(
                    'قیمت',
                    style: TextStyle(
                      fontFamily: 'Dana',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kNewsCardHeaderTextColor,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'قیمت در بازار(تومان)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4B4B4B),
                            fontFamily: 'Dana',
                            fontSize: 15,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            width: 150,
                            height: 35,
                            child: TextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                controller: _originalPrice,
                                cursorColor: kButtonOrangeColor,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                onChanged: (String value) {
                                  setState(() {
                                    originalPrice = int.parse(value);
                                  });
                                },
                                style: const TextStyle(
                                  fontFamily: 'IranYekan',
                                  fontSize: 13,
                                ),
                                decoration: textFieldDecorations()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  //Category
                  const Text(
                    'دسته بندی',
                    style: TextStyle(
                      fontFamily: 'Dana',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kNewsCardHeaderTextColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    categoryName == null
                        ? ''
                        : 'دسته بندی انتخاب شده : $categoryName',
                    style: const TextStyle(
                      fontFamily: 'Dana',
                      color: Color(0xFF4B4B4B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OrangeButton(
                    text: 'انتخاب دسته بندی محصول',
                    onPressed: () {
                      Storage.isEditProduct = false;
                      Navigator.pushNamed(context, CategoryFirstPage.id)
                          .then((_) => setState(() {
                                categoryName = Storage.categoryName;
                              }));
                    },
                  ),
                  //Amount
                  const SizedBox(height: 30),
                  const Text(
                    'مقدار',
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
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        value: 'تعداد',
                        child: Text(
                          'تعداد',
                          style: TextStyle(
                            fontFamily: 'Dana',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'کیلوگرم',
                        child: Text(
                          'کیلوگرم',
                          style: TextStyle(
                            fontFamily: 'Dana',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'گرم',
                        child: Text(
                          'گرم',
                          style: TextStyle(
                            fontFamily: 'Dana',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'بسته',
                        child: Text(
                          'بسته',
                          style: TextStyle(
                            fontFamily: 'Dana',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'لیتر',
                        child: Text(
                          'لیتر',
                          style: TextStyle(
                            fontFamily: 'Dana',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'پالت',
                        child: Text(
                          'پالت',
                          style: TextStyle(
                            fontFamily: 'Dana',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'میلی لیتر',
                        child: Text(
                          'میلی لیتر',
                          style: TextStyle(
                            fontFamily: 'Dana',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AmountWidget(
                    onChanged: (value) {
                      setState(() {
                        availableAmount = int.parse(value);
                      });
                    },
                    enabled: _enabledForAmount,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        activeColor: kButtonOrangeColor,
                        value: isAvailableEnough,
                        onChanged: (bool? value) {
                          setState(() {
                            _availableController.clear();
                            isAvailableEnough = value!;
                            _enabledForAmount = !value;
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
                  AmountWidget(
                    enabled: _enabledMinOrderBoundary,
                    onChanged: (value) {
                      setState(() {
                        minOrderBoundary = int.parse(value);
                      });
                    },
                    controller: _orderBoundary,
                    mainText: 'کف فروش',
                    secondaryText: 'در هر سفارش',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        activeColor: kButtonOrangeColor,
                        value: minOrderBoundaryChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            minOrderBoundary = null;
                            minOrderBoundaryChecked = value!;
                            _enabledMinOrderBoundary = !value;
                            _orderBoundary.clear();
                          });
                        },
                      ),
                      const Text(
                        'ندارد',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4B4B4B),
                          fontSize: 12.0,
                          fontFamily: 'Dana',
                        ),
                      ),
                    ],
                  ),
                  AmountWidget(
                    onChanged: (value) {
                      maxOrderBoundary = int.parse(value);
                    },
                    enabled: _enabled,
                    controller: _limitController,
                    mainText: 'محدودیت فروش',
                    secondaryText: 'در هر سفارش',
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
                            maxOrderBoundary = null;
                            _limitController.clear();
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
                          await postImage();
                          await postCreateNewProduct();

                          // ignore: unnecessary_null_comparison
                          errorMassage == null
                              // ignore: use_build_context_synchronously
                              ? Navigator.pushNamed(context, ProfileScreen.id)
                              : showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ErrorDialog(
                                      errorText: '$errorMassage',
                                      onPressed: () {
                                        setState(() {
                                          errorMassage = null;
                                          visible = false;
                                        });
                                        Navigator.pop(context);
                                      },
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
                                  return ErrorDialog(
                                    errorText:
                                        'اطلاعات وارد شده صحیح نمی باشند',
                                    onPressed: () {
                                      setState(() {
                                        visible = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                          } else if (originalPrice! < priceForMarket!) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return ErrorDialog(
                                    errorText:
                                        'قیمت برای مسئول فروش باید کم تر از قیمت بازار باشد',
                                    onPressed: () {
                                      setState(() {
                                        visible = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                          } else if (availableAmount == null) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return ErrorDialog(
                                    errorText:
                                        'لطفا موجودی محصول را وارد نمائید',
                                    onPressed: () {
                                      setState(() {
                                        visible = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                          } else if (priceForMarket == null) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return ErrorDialog(
                                    errorText:
                                        'لطفا قیمت برای مسئول فروش را وارد نمائید',
                                    onPressed: () {
                                      setState(() {
                                        visible = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                          } else if (originalPrice == null) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return ErrorDialog(
                                    errorText:
                                        'لطفا قیمت در بازار را وارد نمائید',
                                    onPressed: () {
                                      setState(() {
                                        visible = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                          } else {
                            print("error");
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
