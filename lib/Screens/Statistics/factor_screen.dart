import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:masoukharid/Services/storage_class.dart';

import '../../Classes/Cards/factor_info_product.dart';
import '../../Constants/colors.dart';

class FactorScreen extends StatefulWidget {
  const FactorScreen({Key? key}) : super(key: key);
  static const String id = 'FactorScreen';

  @override
  State<FactorScreen> createState() => _FactorScreenState();
}

class _FactorScreenState extends State<FactorScreen> {
  List itemTitle = [];
  List itemPPA = [];
  List totalPrice = [];
  int? totalFactorPrice;
  int? invoiceNumber;
  String productAmount = "1x";
  Future getFactorInfo() async {
    Map<String, String> headers = {
      'token': Storage.token,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    try {
      var response = await http.get(
          Uri.parse(
              "https://testapi.carbon-family.com/api/market/invoices/${Storage.invoiceId}"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var items = jsonDecode(data)["invoice"]['items'];
        setState(() {
          for (var i = 0; i < items.length; i++) {
            itemTitle.add(items[i]["title"]);
            itemPPA.add(items[i]["pricePerAmount"]);
            totalPrice.add(items[i]["totalPrice"]);
          }
          totalFactorPrice = jsonDecode(data)["invoice"]["totalPrice"];
          invoiceNumber = jsonDecode(data)["invoice"]["invoiceNumber"];
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

  Future<void> refresh() async {
    totalPrice = [];
    itemTitle = [];
    itemPPA = [];
    getFactorInfo();
  }

  @override
  void initState() {
    getFactorInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: itemTitle.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
              color: kOrangeColor,
            ))
          : Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                toolbarHeight: 60,
                centerTitle: true,
                elevation: 0.5,
                backgroundColor: Colors.white,
                leading: const BackButton(
                  color: Colors.black,
                ),
                title: const Text(
                  'فاکتور فروش',
                  style: TextStyle(
                    fontFamily: "IranYekan",
                    fontWeight: FontWeight.bold,
                    color: kOrangeColor,
                    fontSize: 17,
                  ),
                ),
              ),
              body: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 15),
                    child: Container(
                      color: const Color(0xFFF7F7F7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 25),
                          const SizedBox(
                            // color: Colors.red,
                            height: 50,
                            child: Center(
                              child: Text(
                                'فاکتور پرداختی',
                                style: TextStyle(
                                  color: kFactorTitleTextColor,
                                  fontFamily: "IranSans",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              // color: Colors.tealAccent,
                              height: 20,
                              child: Text(
                                '#$invoiceNumber',
                                style: const TextStyle(
                                  color: kFactorTitleTextColor,
                                  fontFamily: "IranSans",
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              color: Colors.white,
                              height: 640,
                              child: ListView(
                                children: [
                                  const SizedBox(height: 10),
                                  //Factor Title
                                  SizedBox(
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        //Product Name
                                        Stack(
                                          children: const [
                                            SizedBox(
                                              width: 66,
                                              height: 38,
                                              child: Text(
                                                'محصول',
                                                style: TextStyle(
                                                  color: Color(0xFF4A4A4A),
                                                  fontFamily: "IranSans",
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 22,
                                              child: Text(
                                                'فروشگاه',
                                                style: TextStyle(
                                                  color: Color(0xFF4A4A4A),
                                                  fontFamily: "IranSans",
                                                  fontSize: 6,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        //Price
                                        const Text(
                                          'قیمت واحد',
                                          style: TextStyle(
                                            color: Color(0xFF4A4A4A),
                                            fontFamily: "IranSans",
                                            fontSize: 16,
                                          ),
                                        ),
                                        //Total
                                        const Text(
                                          'جمع',
                                          style: TextStyle(
                                            color: Color(0xFF4A4A4A),
                                            fontFamily: "IranSans",
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Divider(
                                      color: Color(0xFFF7F7F7),
                                      thickness: 2,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  //Product Info Card
                                  SizedBox(
                                    height: 430,
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: itemTitle.isNotEmpty
                                          ? itemTitle.length
                                          : 0,
                                      itemBuilder: (context, int index) {
                                        return FactorInfoCard(
                                          productAmount: productAmount,
                                          name: itemTitle[index],
                                          pricePerAmount:
                                              itemPPA[index].toString(),
                                          totalPrice:
                                              totalPrice[index].toString(),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: SizedBox(
                                      height: 50,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Divider(
                                            color: Color(0xFFF7F7F7),
                                            thickness: 2,
                                            height: 1,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'جمع',
                                                style: TextStyle(
                                                  fontFamily: "IranYekan",
                                                  fontWeight: FontWeight.bold,
                                                  color: kFactorTitleTextColor,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Text(
                                                '$totalFactorPrice',
                                                style: const TextStyle(
                                                  fontFamily: "IranYekan",
                                                  fontWeight: FontWeight.bold,
                                                  color: kOrangeColor,
                                                  fontSize: 20,
                                                ),
                                              )
                                            ],
                                          ),
                                          const Divider(
                                            color: Color(0xFFF7F7F7),
                                            thickness: 2,
                                            height: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
