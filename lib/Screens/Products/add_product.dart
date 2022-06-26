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
import 'package:masoukharid/Methods/text_field_input_decorations.dart';
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
  final TextEditingController _originalPrice = TextEditingController();
  final TextEditingController _priceForMarket = TextEditingController();
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
  String? orderBoundary;
  String? errorMassage;
  String? description;
  String? categoryId;
  String? imagePath;
  String? title;
  bool secCatVisible = false;
  bool? isChecked = false;
  bool visible = false;
  bool _enabled = true;
  int? availableAmount;
  int? priceForMarket;
  int? originalPrice;

  void categoryFunction() {
    if (categoryDropDownValue == 'کیک و دسر') {
      setState(() {
        secCatVisible = false;
      });
      categoryId = "62a8493175134f227cd91633";
    } else if (categoryDropDownValue == "لبنیات") {
      setState(() {
        secCatVisible = false;
      });
      categoryId = "62a8497510eaebfad97aa980";
    } else if (categoryDropDownValue == "سوپرمارکتی") {
      setState(() {
        secCatVisible = true;
        secList = ["مصرفی", "خوراکی"];
        secCategoryDropDownValue = "خوراکی";
      });
    } else if (categoryDropDownValue == "نان و غلات") {
      setState(() {
        secCatVisible = true;
        secList = ["نان", "برنج و حبوبات", "متفرقه"];
        secCategoryDropDownValue = "نان";
      });
    } else if (categoryDropDownValue == "پروتئین") {
      setState(() {
        secCatVisible = true;
        secList = ["گوشت", "مرغ و طیور", "دریایی", "فرآورده های پروتئینی"];
        secCategoryDropDownValue = "گوشت";
      });
    } else if (categoryDropDownValue == "میوه و تره بار") {
      setState(() {
        secCatVisible = true;
        secList = ["سبزی", "میوه", "صیفی جات"];
        secCategoryDropDownValue = "سبزی";
      });
    } else if (categoryDropDownValue == "عطاری") {
      setState(() {
        secCatVisible = true;
        secList = ["ادویه جات", "گیاهان خشک", "عرقیجات", "دمی جات"];
        secCategoryDropDownValue = "ادویه جات";
      });
    } else if (categoryDropDownValue == "تجهیزات") {
      setState(() {
        secCatVisible = true;
        secList = ["آشپزخانه", "بار", "طراحی و سالن"];
        secCategoryDropDownValue = "آشپزخانه";
      });
    }
  }

  void secondCategory() {
    if (secCategoryDropDownValue == "مصرفی") {
      categoryId = "62aa14d1a168adf6ba98ed35";
    } else if (secCategoryDropDownValue == "خوراکی") {
      categoryId = "62aa14deb2dc415f6df6b0ec";
    } else if (secCategoryDropDownValue == "نان") {
      categoryId = "62a849e675134f227cd9163d";
    } else if (secCategoryDropDownValue == "برنج و حبوبات") {
      categoryId = "62a84a0210eaebfad97aa98a";
    } else if (secCategoryDropDownValue == "متفرقه") {
      categoryId = "62a84a1775134f227cd91642";
    } else if (secCategoryDropDownValue == "گوشت") {
      categoryId = "62a84b1810eaebfad97aa98f";
    } else if (secCategoryDropDownValue == "مرغ و طیور") {
      categoryId = "62a84b4475134f227cd9164c";
    } else if (secCategoryDropDownValue == "دریایی") {
      categoryId = "62a84b6810eaebfad97aa994";
    } else if (secCategoryDropDownValue == "فرآورده های پروتئینی") {
      categoryId = "62a84b9d75134f227cd91651";
    } else if (secCategoryDropDownValue == "سبزی") {
      categoryId = "62a84c2d75134f227cd91656";
    } else if (secCategoryDropDownValue == "میوه") {
      categoryId = "62a84c4110eaebfad97aa99e";
    } else if (secCategoryDropDownValue == "صیفی جات") {
      categoryId = "62a84c6d75134f227cd9165b";
    } else if (secCategoryDropDownValue == "ادویه جات") {
      categoryId = "62a84ce575134f227cd91660";
    } else if (secCategoryDropDownValue == "گیاهان خشک") {
      categoryId = "62a84d1110eaebfad97aa9a8";
    } else if (secCategoryDropDownValue == "عرقیجات") {
      categoryId = "62a84d3975134f227cd91665";
    } else if (secCategoryDropDownValue == "دمی جات") {
      categoryId = "62a84d5b10eaebfad97aa9ad";
    } else if (secCategoryDropDownValue == "آشپزخانه") {
      categoryId = "62a84dbe10eaebfad97aa9b2";
    } else if (secCategoryDropDownValue == "بار") {
      categoryId = "62a84df475134f227cd9166f";
    } else if (secCategoryDropDownValue == "طراحی و سالن") {
      categoryId = "62a84e1110eaebfad97aa9b7";
    }
  }

  String mainText() {
    if (dropDownValue == 'تعداد' ||
        dropDownValue == 'بسته' ||
        dropDownValue == 'جین') {
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
      amountSecText = 'تعداد ';
    } else if (dropDownValue == 'وزن') {
      amountSecText = 'کیلوگرم ';
    } else if (dropDownValue == 'لیتر') {
      amountSecText = 'لیتر ';
    }
    return amountSecText;
  }

  Future getCategories() async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    try {
      var response = await http.get(
        Uri.parse(
            "https://testapi.carbon-family.com/api/public/global/productsCategories"),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var data = response.body;
        var categories =
            jsonDecode(data)['productsCategoriesTree']['categories']['childs'];
        setState(() {
          for (var i = 0; i < categories.length; i++) {
            categoryList.add(categories[i]["title"]);
          }
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
      "categoryId": categoryId,
      "isAvailableEnough": false,
      "availableAmount": availableAmount,
      "priceBeforeDiscount": 0,
      "originalPrice": originalPrice,
      "priceForMarket": priceForMarket,
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

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return categoryList.isEmpty
        ? const Center(
            child: CircularProgressIndicator(
            color: kOrangeColor,
          ))
        : Scaffold(
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
                                      fontSize: 15,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: SizedBox(
                                      width: 150,
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
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DropdownButton(
                              value: categoryDropDownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  categoryDropDownValue = newValue!;
                                  categoryFunction();
                                });
                              },
                              items: categoryList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            Visibility(
                              visible: secCatVisible,
                              child: DropdownButton(
                                value: secCategoryDropDownValue,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    secCategoryDropDownValue = newValue!;
                                  });
                                  secondCategory();
                                },
                                items: secList.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
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
                                    ? Navigator.pushNamed(
                                        context, ProfileScreen.id)
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
                                                image: AssetImage(
                                                    'images/ErroIcon.png'),
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
