import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:masoukharid/Classes/orange_button.dart';
import 'package:masoukharid/Constants/colors.dart';
import 'package:masoukharid/Constants/strings.dart';
import 'package:masoukharid/Constants/text_styles.dart';
import 'package:masoukharid/Screens/Products/product_edit.dart';
import 'package:masoukharid/Screens/profile_screen.dart';
import 'package:masoukharid/Services/storage_class.dart';

class ProductsMainPage extends StatefulWidget {
  const ProductsMainPage({Key? key}) : super(key: key);
  static const String id = 'ProductMainPage';

  @override
  State<ProductsMainPage> createState() => _ProductsMainPageState();
}

class _ProductsMainPageState extends State<ProductsMainPage> {
  final String headerImageAsset = 'images/ProductPic.png';
  final String contentText = kDefaultText;

  String? title;
  String? description;
  String? availableAmount;
  List image = [];

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
        print(data);
        setState(() {
          title = jsonDecode(data)["product"]["title"];
          description = jsonDecode(data)["product"]["descriptions"];
          availableAmount =
              jsonDecode(data)["product"]["availableAmount"].toString();
          image = jsonDecode(data)["product"]["media"];
        });
      } else {
        print(response.body);
        print(response.statusCode);
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
                            child: Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                image.isEmpty
                                    ? 'https://testapi.carbon-family.com/uploads/products/productsImages/635dc499204c404d99b3c3484b7c96fd_6246f113965272bf7ca06282_1648817959178.jpg'
                                    : 'https://testapi.carbon-family.com/' +
                                        image[0],
                              ),
                            ),
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
                                            ' تعداد:$availableAmount',
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
