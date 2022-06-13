import 'package:flutter/material.dart';
import 'package:masoukharid/Classes/Cards/product_card.dart';
import 'package:masoukharid/Services/storage_class.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductList extends StatefulWidget {
  const ProductList({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List productTitles = [];
  List productAvailableAmount = [];
  List productDescription = [];

  Future getProductList() async {
    Map<String, String> headers = {'token': Storage.token};
    try {
      var response = await http.get(
          Uri.parse(
              "https://testapi.carbon-family.com/api/admin/users/marketUsers"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var admins = jsonDecode(data)['products'];
        setState(() {
          for (var i = 0; i < admins.length; i++) {
            productTitles.add(admins[i]["title"]);
            productDescription.add(admins[i]["description"]);
            productAvailableAmount.add(admins[i]["availableAmount"]);
          }
        });
        print(productTitles);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: productTitles.isNotEmpty ? productTitles.length : 0,
      itemBuilder: (BuildContext context, int index) {
        return ProductCard(
          onTap: () {},
          title: productTitles[index],
          availableAmount: productAvailableAmount[index].toString(),
          image: '',
        );
      },
    );
  }
}