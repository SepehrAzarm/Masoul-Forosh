import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masoukharid/Classes/Dialogs/error_dialog.dart';
import 'package:masoukharid/Classes/Text&TextStyle/orange_header_text.dart';
import 'package:masoukharid/Classes/amount_card.dart';
import 'package:masoukharid/Classes/orange_button.dart';
import 'package:masoukharid/Classes/tax_widget.dart';
import 'package:masoukharid/Constants/borders_decorations.dart';
import 'package:masoukharid/Constants/colors.dart';
import 'package:masoukharid/Constants/constants.dart';
import 'package:masoukharid/Screens/CategoryScreen/category_first_page.dart';
import 'package:masoukharid/Screens/Products/products_mainpage.dart';
import 'package:masoukharid/Services/storage_class.dart';

import '../../Methods/text_field_input_decorations.dart';

class ProductEdit extends StatefulWidget {
  const ProductEdit({Key? key}) : super(key: key);
  static const String id = 'ProductEdit';

  @override
  State<ProductEdit> createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  final TextEditingController _availableController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  final TextEditingController _priceForMarket = TextEditingController();
  final TextEditingController _orderBoundary = TextEditingController();
  final TextEditingController _originalPrice = TextEditingController();
  final TextEditingController _taxPercentage = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _taxValue = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final storage = const FlutterSecureStorage();
  final ImagePicker _picker = ImagePicker();
  List availableImage = [];
  // ignore: prefer_typing_uninitialized_variables
  var newImage;
  // ignore: prefer_typing_uninitialized_variables
  var imageFile;
  String dropDownValue = 'تعداد';
  String amountMainText = '';
  String amountSecText = '';
  String? availableCategory;
  String? orderBoundary;
  String? description;
  String? imagePath;
  String? errorText;
  String? title;
  String? unit;
  bool taxIsChecked = true;
  bool taxTypeValue = false;
  bool taxTypePercent = false;
  bool? isChecked = false;
  bool visible = false;
  bool enabled = true;
  int? availableAmount;
  int? priceForMarket;
  int? originalPrice;
  int taxPercentage = 0;
  int taxValue = 0;

  String mainText() {
    if (dropDownValue == 'تعداد ' ||
        dropDownValue == 'بسته ' ||
        dropDownValue == 'جین ') {
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
    } else if (dropDownValue == 'وزن') {
      amountSecText = 'کیلوگرم';
    } else if (dropDownValue == 'لیتر') {
      amountSecText = 'لیتر';
    }
    return amountSecText;
  }

  Future getProductInfo() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {'token': value!};
    try {
      var response = await http.get(
        Uri.parse(
            "https://testapi.carbon-family.com/api/market/products/${Storage.productId}"),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var data = response.body;
        setState(() {
          title = jsonDecode(data)["product"]["title"];
          unit = jsonDecode(data)["product"]["unit"];
          originalPrice = jsonDecode(data)["product"]["originalPrice"];
          priceForMarket = jsonDecode(data)["product"]["priceForMarket"];
          description = jsonDecode(data)["product"]["descriptions"];
          availableAmount = jsonDecode(data)["product"]["availableAmount"];
          availableImage = jsonDecode(data)["product"]["media"];
          taxIsChecked = jsonDecode(data)["product"]["tax"]["status"];
          taxPercentage = jsonDecode(data)["product"]["tax"]["percentage"];
          taxValue = jsonDecode(data)["product"]["tax"]["value"];
          availableCategory = jsonDecode(data)["product"]["categoryStringPath"];
          dropDownValue = unit!;
          _title.text = '$title ';
          _description.text = '$description ';
          _originalPrice.text = '$originalPrice ';
          _priceForMarket.text = '$priceForMarket ';
          _availableController.text = '$availableAmount ';
          _taxPercentage.text = '$taxPercentage ';
          _taxValue.text = '$taxValue ';
          if (taxValue != 0) {
            taxTypeValue = true;
          } else if (taxPercentage != 0) {
            taxTypePercent = true;
          }
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
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
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
      "availableAmount": availableAmount,
      "originalPrice": originalPrice,
      "priceForMarket": priceForMarket,
      "categoryId": Storage.categoryId,
      "tax": {
        "status": taxIsChecked,
        "value": taxValue,
        "percentage": taxPercentage,
      },
      "orderBoundery": {
        "minAmount": orderBoundary,
      },
      "unit": dropDownValue,
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
      imageFile = File(newImage.path);
      print(newImage);
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
    } else if (imagePath == null && availableImage.isEmpty) {
      return const Image(
        fit: BoxFit.cover,
        image: AssetImage(
          'images/staticImages/productStaticImage.jpg',
        ),
      );
    } else {
      return Image(
        image: NetworkImage(availableImage.isEmpty
            ? 'https://testapi.carbon-family.com/${imagePath!}'
            : 'https://testapi.carbon-family.com/${availableImage[0]}'),
        fit: BoxFit.cover,
      );
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
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              ProductsMainPage.id,
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: title == null
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
                              color: kTextFieldHintTextColor,
                              width: 250,
                              height: 250,
                              child: picFunc(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        //Post Image Button and Function
                        TextButton(
                          onPressed: () async {
                            await chooseImage();
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
                        // Title & description Edit
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
                          controller: _title,
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
                            controller: _description,
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
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'قیمت در بازار(تومان)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4B4B4B),
                                      fontFamily: 'Dana',
                                      fontSize: 11,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: SizedBox(
                                      width: 147,
                                      height: 35,
                                      child: TextField(
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.number,
                                          controller: _originalPrice,
                                          cursorColor: kButtonOrangeColor,
                                          textAlignVertical:
                                              TextAlignVertical.center,
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'قیمت برای '
                                    'مسئول فروش(تومان)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4B4B4B),
                                      fontFamily: 'Dana',
                                      fontSize: 11,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: SizedBox(
                                      width: 147,
                                      height: 35,
                                      child: TextField(
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.number,
                                          controller: _priceForMarket,
                                          cursorColor: kButtonOrangeColor,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          textAlign: TextAlign.center,
                                          onChanged: (String value) {
                                            setState(() {
                                              priceForMarket = int.parse(value);
                                            });
                                          },
                                          // inputFormatters: [
                                          //   MaskedInputFormatter(
                                          //       "000,000,000,000,000,000,000"),
                                          // ],
                                          style: const TextStyle(
                                            fontFamily: 'IranYekan',
                                            fontSize: 13,
                                          ),
                                          decoration: textFieldDecorations()),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //Tax
                        const Text(
                          'مالیات',
                          style: TextStyle(
                            fontFamily: 'Dana',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kNewsCardHeaderTextColor,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              activeColor: kButtonOrangeColor,
                              value: taxIsChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  taxIsChecked = value!;
                                  taxTypeValue = value;
                                  if (taxIsChecked == false) {
                                    taxTypeValue = false;
                                    taxTypePercent = false;
                                  }
                                });
                              },
                            ),
                            const Text(
                              'مالیات بر ارزش افزوده',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4B4B4B),
                                fontSize: 12.0,
                                fontFamily: 'Dana',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  activeColor: kButtonOrangeColor,
                                  value: taxTypeValue,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (taxIsChecked == true) {
                                        taxTypeValue = value!;
                                        taxTypePercent = false;
                                        _taxPercentage.clear();
                                      }
                                    });
                                  },
                                ),
                                const Text(
                                  'مالیات به صورت عددی',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4B4B4B),
                                    fontSize: 10,
                                    fontFamily: 'Dana',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  activeColor: kButtonOrangeColor,
                                  value: taxTypePercent,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (taxIsChecked == true) {
                                        taxTypePercent = value!;
                                        taxTypeValue = false;
                                        _taxValue.clear();
                                      }
                                    });
                                  },
                                ),
                                const Text(
                                  'مالیات به صورت درصدی',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4B4B4B),
                                    fontSize: 10,
                                    fontFamily: 'Dana',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        TaxWidget(
                          mainText: 'مالیات',
                          secondaryText: 'به عدد',
                          onChanged: (value) {
                            taxValue = int.parse(value);
                          },
                          enabled: taxTypeValue,
                          controller: _taxValue,
                          suffixIcon: IconButton(
                            iconSize: 20,
                            color: const Color(0xFF4B4B4B),
                            onPressed: () {
                              setState(() {
                                _taxValue.clear();
                              });
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                        TaxWidget(
                          mainText: 'مالیات',
                          secondaryText: 'درصد',
                          onChanged: (value) {
                            setState(() {
                              if (int.parse(value) > 100) {
                                _taxPercentage.text = " 100 ";
                                taxPercentage = 100;
                              }
                              taxPercentage = int.parse(value);
                            });
                          },
                          enabled: taxTypePercent,
                          controller: _taxPercentage,
                          suffixIcon: IconButton(
                            iconSize: 20,
                            color: const Color(0xFF4B4B4B),
                            onPressed: () {
                              setState(() {
                                _taxPercentage.clear();
                              });
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ),
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
                          'دسته بندی فعلی محصول: $availableCategory',
                          style: const TextStyle(
                            fontFamily: 'Dana',
                            color: Color(0xFF4B4B4B),
                          ),
                        ),
                        const SizedBox(height: 20),
                        OrangeButton(
                          text: 'انتخاب دسته بندی محصول',
                          onPressed: () {
                            Storage.isEditProduct = true;
                            Navigator.pushNamed(context, CategoryFirstPage.id);
                          },
                        ),
                        const SizedBox(height: 10),
                        //Amount
                        const Text(
                          'ویرایش مقدار',
                          style: TextStyle(
                            fontFamily: 'Dana',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kNewsCardHeaderTextColor,
                          ),
                        ),
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
                              value: 'جین',
                              child: Text(
                                'جین',
                                style: TextStyle(
                                  fontFamily: 'Dana',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'وزن',
                              child: Text(
                                'وزن',
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
                          ],
                        ),
                        //Available Amount
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
                                availableAmount = null;
                              });
                            },
                            icon: const Icon(Icons.clear),
                          ),
                          onChanged: (value) {
                            setState(() {
                              availableAmount = int.parse(value);
                            });
                          },
                        ),
                        //orderBoundary
                        AmountWidget(
                          onChanged: (value) {
                            setState(() {
                              orderBoundary = value;
                            });
                          },
                          controller: _orderBoundary,
                          mainText: 'کف فروش',
                          secondaryText: ' در هر سفارش',
                          suffixIcon: IconButton(
                            iconSize: 20,
                            color: const Color(0xFF4B4B4B),
                            onPressed: () {
                              setState(() {
                                _orderBoundary.clear();
                                orderBoundary = null;
                              });
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                        //Order Limit
                        AmountWidget(
                          enabled: enabled,
                          controller: _limitController,
                          mainText: 'سقف فروش',
                          secondaryText: ' در هر سفارش',
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
                            text: 'تایید',
                            onPressed: () async {
                              if (imagePath == null &&
                                  availableAmount != null &&
                                  priceForMarket != null &&
                                  originalPrice != null &&
                                  Storage.categoryId != null &&
                                  originalPrice! >= priceForMarket!) {
                                imagePath = availableImage[0];
                                setState(() {
                                  visible = true;
                                });

                                if (newImage != null) {
                                  await postImage();
                                }
                                await putEditProductInfo();
                                // ignore: unnecessary_null_comparison
                                errorText != null
                                    ? showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ErrorDialog(
                                            errorText: '$errorText',
                                            onPressed: () {
                                              setState(() {
                                                errorText = null;
                                                visible = false;
                                                imagePath = null;
                                              });
                                              Navigator.pop(context);
                                            },
                                          );
                                        })
                                    // ignore: use_build_context_synchronously
                                    : Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        ProductsMainPage.id,
                                        (Route<dynamic> route) => false,
                                      );
                              } else {
                                if (originalPrice! < priceForMarket!) {
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
                                } else if (Storage.categoryId == null) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ErrorDialog(
                                          errorText:
                                              'لطفا دسته بندی محصول را انتخاب نمائید',
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
