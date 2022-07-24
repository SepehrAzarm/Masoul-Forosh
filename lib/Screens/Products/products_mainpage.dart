import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Constants/strings.dart';
import 'package:masoul_kharid/Constants/text_styles.dart';
import 'package:masoul_kharid/Screens/Products/product_edit.dart';
import 'package:masoul_kharid/Screens/profile_screen.dart';
import 'package:masoul_kharid/Services/storage_class.dart';

class ProductsMainPage extends StatefulWidget {
  const ProductsMainPage({Key? key}) : super(key: key);
  static const String id = 'ProductMainPage';

  @override
  State<ProductsMainPage> createState() => _ProductsMainPageState();
}

class _ProductsMainPageState extends State<ProductsMainPage> {
  final String headerImageAsset = 'images/ProductPic.png';
  final String contentText = kDefaultText;
  final storage = const FlutterSecureStorage();

  String? title;
  String? description;
  String? availableAmount;
  String? unit;
  String? secUnit;
  List image = [];

  void secondaryText() {
    if (unit == 'تعداد' || unit == 'بسته' || unit == 'جین' || unit == 'پالت') {
      setState(() {
        secUnit = 'عدد ';
      });
    } else if (unit == 'وزن') {
      setState(() {
        secUnit = 'کیلوگرم ';
      });
    } else if (unit == 'لیتر') {
      setState(() {
        secUnit = 'لیتر ';
      });
    }
  }

  Future getProductInfo() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {'token': value!};
    try {
      var response = await http.get(
        Uri.parse(
            "https://api.carbon-family.com/api/market/products/${Storage.productId}"),
        headers: headers,
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        var data = response.body;
        print(data);
        setState(() {
          title = jsonDecode(data)["product"]["title"];
          description = jsonDecode(data)["product"]["descriptions"];
          availableAmount =
              jsonDecode(data)["product"]["availableAmount"].toString();
          image = jsonDecode(data)["product"]["media"];
          unit = jsonDecode(data)["product"]["unit"];
        });
        secondaryText();
      } else {
        print(response.body);
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget picFunc() {
    if (image.isEmpty) {
      return const Image(
        fit: BoxFit.cover,
        image: AssetImage(
          'images/staticImages/productStaticImage.jpg',
        ),
      );
    } else {
      return Image(
        image: NetworkImage('https://api.carbon-family.com/${image[0]}'),
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
    return RefreshIndicator(
      color: kOrangeColor,
      onRefresh: getProductInfo,
      child: title == null
          ? const Center(
              child: CircularProgressIndicator(
              color: kOrangeColor,
            ))
          : Scaffold(
              extendBodyBehindAppBar: true,
              body: Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 350,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(18),
                                bottomRight: Radius.circular(18)),
                            child: picFunc(),
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: SizedBox(
                                height: 80,
                                // color: Colors.lightBlueAccent,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Text(
                                            '$title',
                                            style: kNewsCardTitleTxtStyle,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Text(
                                            '$unit: $availableAmount $secUnit',
                                            style: const TextStyle(
                                              fontFamily: 'IranYekanExtraBold',
                                              fontSize: 10,
                                              color: kNewsCardContentTextColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, ProductEdit.id);
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.amberAccent,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(14),
                                          ),
                                        ),
                                        height: 45,
                                        width: 45,
                                        child: Image.asset(
                                            'images/Icons/EditIcon.png'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Text(
                                  '$description',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontFamily: 'IranYekan',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: kNewsCardContentTextColor,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: OrangeButton(
                      text: 'بازگشت',
                      onPressed: () {
                        Storage.resetProductId();
                        Navigator.pushNamed(context, ProfileScreen.id);
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
