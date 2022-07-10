import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:masoukharid/Methods/factors_orange_card.dart';
import 'package:masoukharid/Services/storage_class.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:intl/intl.dart' as intl;

import '../../Classes/Cards/factor_info_product.dart';
import '../../Constants/colors.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({Key? key}) : super(key: key);
  static const String id = "OrderDetailScreen";

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final storage = const FlutterSecureStorage();
  List itemsQuantity = [];
  List totalPrice = [];
  List itemTitle = [];
  List itemPPA = [];
  String? shopUserName;
  String productAmount = "1x";
  String? paymentReference;
  String? createdAt;
  int? transactionMoment;
  int? totalFactorPrice;
  int? invoiceNumber;
  int? paymentMethod;
  int? tax;
  late Jalali j;

  Map<int, String> paymentMethodMap = {
    0: 'نقدی',
    1: 'آنلاین',
    2: 'کیف پول',
    3: 'داخلی',
    4: 'نامشخص',
  };

  String toStringFormatter(Jalali j) {
    final f = j.formatter;

    return '${f.y},${f.m},${f.d}-${j.hour}:${j.minute}';
  }

  Future getOrderDetail() async {
    String? value = await storage.read(key: "token");

    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    try {
      var response = await http.get(
          Uri.parse(
              "https://testapi.carbon-family.com/api/market/orders/${Storage.orderId}"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var items = jsonDecode(data)["order"]['items'];
        setState(() {
          for (var i = 0; i < items.length; i++) {
            itemTitle.add(items[i]["title"]);
            itemPPA.add(items[i]["pricePerAmount"]);
            totalPrice.add(items[i]["totalPrice"]);
            itemsQuantity.add(items[i]["quantity"]);
          }
          if (jsonDecode(data)["order"]["shopId"] != null) {
            shopUserName = jsonDecode(data)["order"]["shopId"]["shopUserName"];
          }
          transactionMoment = jsonDecode(data)["order"]["transactionMoment"];
          paymentReference = jsonDecode(data)["order"]["paymentReference"];
          createdAt = jsonDecode(data)["order"]["createdAt"];
          paymentMethod = jsonDecode(data)["order"]["paymentMethod"];
          totalFactorPrice = jsonDecode(data)["order"]["totalPrice"];
          invoiceNumber = jsonDecode(data)["order"]["invoiceNumber"];
          tax = jsonDecode(data)["order"]["tax"];
        });
        var dateAndTime = DateTime.parse(createdAt!).toLocal();
        Gregorian g = Gregorian.fromDateTime(dateAndTime);
        j = Jalali.fromGregorian(g);
        print(j);
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
    getOrderDetail();
  }

  @override
  void initState() {
    getOrderDetail();
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
                  'لیست سفارشات',
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
                          const SizedBox(height: 15),
                          const SizedBox(
                            // color: Colors.red,
                            height: 50,
                            child: Center(
                              child: Text(
                                'لیست سفارشات',
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    shopUserName != null
                                        ? 'اطلاعات خریدار: $shopUserName'
                                        : '',
                                    style: const TextStyle(
                                      color: kFactorTitleTextColor,
                                      fontFamily: "IranSans",
                                      fontSize: 8,
                                    ),
                                  ),
                                  Text(
                                    '#$invoiceNumber',
                                    style: const TextStyle(
                                      color: kFactorTitleTextColor,
                                      fontFamily: "IranYekan",
                                      fontSize: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              color: Colors.white,
                              height: 650,
                              child: ListView(
                                children: [
                                  const SizedBox(height: 10),
                                  //Factor Title
                                  SizedBox(
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        //Product Name
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
                                        //Price
                                        Text(
                                          'قیمت واحد',
                                          style: TextStyle(
                                            color: Color(0xFF4A4A4A),
                                            fontFamily: "IranSans",
                                            fontSize: 16,
                                          ),
                                        ),
                                        //Total
                                        Text(
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
                                  const SizedBox(height: 5),
                                  //Product Info Card
                                  SizedBox(
                                    // color: Colors.yellowAccent,
                                    height: itemTitle.length < 6
                                        ? 300
                                        : itemTitle.length * 50,
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: itemTitle.isNotEmpty
                                          ? itemTitle.length
                                          : 0,
                                      itemBuilder: (context, int index) {
                                        return FactorInfoCard(
                                          name: itemTitle[index] +
                                              ' ${itemsQuantity[index]}x ',
                                          pricePerAmount:
                                              intl.NumberFormat.decimalPattern()
                                                  .format(itemPPA[index]),
                                          totalPrice:
                                              intl.NumberFormat.decimalPattern()
                                                  .format(totalPrice[index]),
                                        );
                                      },
                                    ),
                                  ),
                                  //Discount
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: SizedBox(
                                      height: 50,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Divider(
                                            color: Color(0xFFF7F7F7),
                                            thickness: 2,
                                            height: 1,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text(
                                                'تخفیف',
                                                style: TextStyle(
                                                  fontFamily: "IranYekan",
                                                  fontWeight: FontWeight.bold,
                                                  color: kFactorTitleTextColor,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Text(
                                                '0 تومان',
                                                style: TextStyle(
                                                  fontFamily: "IranYekan",
                                                  fontWeight: FontWeight.bold,
                                                  color: kOrangeColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Total Price
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
                                                '${intl.NumberFormat.decimalPattern().format(totalFactorPrice)} تومان',
                                                style: const TextStyle(
                                                  fontFamily: "IranYekan",
                                                  fontWeight: FontWeight.bold,
                                                  color: kOrangeColor,
                                                  fontSize: 15,
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
                                  //Information && Details
                                  SizedBox(
                                    height: 200,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          height: 65,
                                          width: 250,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Container(
                                                  decoration:
                                                      factorOrangeCardDecoration(),
                                                  height: 60,
                                                  width: 100,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      const Text(
                                                        'روش پرداخت',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'IranSans',
                                                          color: kOrangeColor,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${paymentMethodMap[paymentMethod]}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'IranSans',
                                                          color: Colors.black,
                                                          fontSize: 8,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Container(
                                                  decoration:
                                                      factorOrangeCardDecoration(),
                                                  height: 60,
                                                  width: 100,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      const Text(
                                                        'مالیات پرداخت',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'IranSans',
                                                          color: kOrangeColor,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      Text(
                                                        '$tax تومان',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'IranYekan',
                                                          color: Colors.black,
                                                          fontSize: 8,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 65,
                                          width: 250,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Container(
                                                  decoration:
                                                      factorOrangeCardDecoration(),
                                                  height: 60,
                                                  width: 100,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      const Text(
                                                        'زمان ایجاد تراکنش',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'IranSans',
                                                          color: kOrangeColor,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      Text(
                                                        toStringFormatter(j),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'IranYekan',
                                                          color: Colors.black,
                                                          fontSize: 8,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Container(
                                                  decoration:
                                                      factorOrangeCardDecoration(),
                                                  height: 60,
                                                  width: 100,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      const Text(
                                                        'زمان تراکنش',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'IranSans',
                                                          color: kOrangeColor,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      Text(
                                                        transactionMoment ==
                                                                null
                                                            ? ''
                                                            : "$transactionMoment",
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'IranYekan',
                                                          color: Colors.black,
                                                          fontSize: 8,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration:
                                              factorOrangeCardDecoration(),
                                          height: 60,
                                          width: 220,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Text(
                                                'شماره پیگیری',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'IranSans',
                                                  color: kOrangeColor,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              Text(
                                                paymentReference != null
                                                    ? '$paymentReference'
                                                    : '--',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'IranYekan',
                                                  color: Colors.black,
                                                  fontSize: 8,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
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
