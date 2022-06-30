import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:masoukharid/Constants/colors.dart';
import 'package:masoukharid/Screens/Products/add_product.dart';
import 'package:masoukharid/Screens/Products/product_edit.dart';
import 'package:masoukharid/Services/storage_class.dart';

class CategorySecondList extends StatefulWidget {
  const CategorySecondList({Key? key}) : super(key: key);
  static const String id = "CategorySecondList";

  @override
  State<CategorySecondList> createState() => _CategorySecondListState();
}

class _CategorySecondListState extends State<CategorySecondList> {
  List<String> categoryList = [];
  List categoryIdList = [];
  List childrenList = [];
  String? categoryId;

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
        var categories = jsonDecode(data)['category']['childs'];
        setState(() {
          for (var i = 0; i < categories.length; i++) {
            categoryList.add(categories[i]["title"]);
            categoryIdList.add(categories[i]["_id"]);
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

  Future getChildren() async {
    Map<String, String> queryParams = {
      'categoryId': categoryId!,
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
        var categories = jsonDecode(data)['category']['childs'];
        for (var i = 0; i < categories.length; i++) {
          childrenList.add(categories[i]["title"]);
        }
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
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black,
        ),
        title: const Text(
          'انتخاب دسته بندی محصول',
          style: TextStyle(
            fontFamily: 'Dana',
            fontSize: 14,
            color: kOrangeColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categoryList.isNotEmpty ? categoryList.length : 0,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () async {
                  setState(() {
                    categoryId = categoryIdList[index];
                  });
                  await getChildren();
                  if (childrenList.isNotEmpty) {
                    if (mounted) {
                      Navigator.pushNamed(context, CategorySecondList.id);
                    }
                  } else if (childrenList.isEmpty) {
                    Storage.categoryId = categoryId!;
                    if (mounted && Storage.isEditProduct == false) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AddProductPage.id,
                        (Route<dynamic> route) => false,
                      );
                    } else if (mounted && Storage.isEditProduct == true) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        ProductEdit.id,
                        (Route<dynamic> route) => false,
                      );
                    }
                  }
                },
                child: SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          categoryList[index],
                          style: const TextStyle(
                            fontFamily: 'IranYekan',
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                        const Divider(
                          color: kNewsCardContentTextColor,
                          thickness: 0.5,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
