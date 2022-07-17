import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:masoul_kharid/Classes/Cards/order_list_card.dart';
import 'package:masoul_kharid/Classes/Dialogs/error_dialog.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/textfield_label_text_style.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Constants/constants.dart';
import 'package:masoul_kharid/Methods/text_field_input_decorations.dart';
import 'package:masoul_kharid/Screens/Orders/order_delivery.dart';
import 'package:masoul_kharid/Screens/Orders/order_screen.dart';
import 'package:masoul_kharid/Screens/profile_screen.dart';
import 'package:masoul_kharid/Services/storage_class.dart';
import 'package:shamsi_date/shamsi_date.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({Key? key}) : super(key: key);
  static const String id = "OrdersList";

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  final storage = const FlutterSecureStorage();
  List orderedItems = [];
  String? verificationCode;
  String? firstName;
  String? lastName;
  String? mobile;
  String? profileImage;
  String? errorText;
  late Jalali j;

  courierPicInfo() {
    if (profileImage == null) {
      return const AssetImage(
        'images/staticImages/ShopDefaultPic.png',
      );
    } else {
      return NetworkImage('https://testapi.carbon-family.com/$profileImage');
    }
  }

  String toStringFormatter(Jalali j) {
    final f = j.formatter;

    return '${f.y},${f.m},${f.d}-${j.hour}:${j.minute}';
  }

  Future getOrderList() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    try {
      var response = await http.get(
          Uri.parse(
              "https://testapi.carbon-family.com/api/market/orders/list/basedOnShops"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var items = jsonDecode(data)["orders"];
        setState(() {
          for (var i = 0; i < items.length; i++) {
            orderedItems.add(items[i]);
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

  Future getOrderAndCourierInfo() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    try {
      var response = await http.get(
          Uri.parse(
              "https://testapi.carbon-family.com/api/market/orders/delivery/$verificationCode"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        setState(() {
          firstName = jsonDecode(data)["courierInfo"]["firstName"];
          lastName = jsonDecode(data)["courierInfo"]["lastName"];
          mobile = jsonDecode(data)["courierInfo"]["mobile"];
          profileImage = jsonDecode(data)["courierInfo"]["profileImage"];
        });
        print(response.statusCode);
        print(response.body);
      } else {
        var errorData = await jsonDecode(response.body.toString());
        setState(() {
          errorText = errorData['message'];
        });
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future postDeliveryConfirmation() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    try {
      var response = await http.post(
        Uri.parse(
            'https://testapi.carbon-family.com/api/market/orders/delivery/$verificationCode'),
        headers: headers,
      );
      if (response.statusCode == 201) {
        print(response.statusCode);
        print(response.body);
      } else {
        var errorData = await jsonDecode(response.body.toString());
        setState(() {
          errorText = errorData['message'];
        });
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  orderListConfirm() async {
    await getOrderList();
    if (orderedItems.isEmpty) {
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(
              errorText: 'لیست سفارشات شما خالی میباشد',
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  ProfileScreen.id,
                  (Route<dynamic> route) => false,
                );
              },
            );
          });
    }
  }

  @override
  void initState() {
    orderListConfirm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return orderedItems.isEmpty
        ? const Center(
            child: CircularProgressIndicator(
            color: kOrangeColor,
          ))
        : Scaffold(
            appBar: AppBar(
              toolbarHeight: 60,
              centerTitle: true,
              elevation: 0.5,
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
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 8,
                            child: ListView.builder(
                                itemCount: orderedItems.length,
                                itemBuilder: (context, int index) {
                                  Widget picFunc() {
                                    if (orderedItems[index]["shop"]
                                            ["shopLogo"] ==
                                        null) {
                                      return const Image(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          'images/staticImages/ShopDefaultPic.png',
                                        ),
                                      );
                                    } else {
                                      return Image(
                                        image: NetworkImage(
                                            'https://testapi.carbon-family.com/${orderedItems[index]["shop"]["shopLogo"]}'),
                                        fit: BoxFit.cover,
                                      );
                                    }
                                  }

                                  var dateAndTime = DateTime.parse(
                                          orderedItems[index]["createdAt"]!)
                                      .toLocal();
                                  Gregorian g =
                                      Gregorian.fromDateTime(dateAndTime);
                                  j = Jalali.fromGregorian(g);
                                  return OrderListCard(
                                    shopName: orderedItems[index]["shop"]
                                        ["shopName"],
                                    orderNumber: orderedItems[index]
                                            ["orderNumber"]
                                        .toString(),
                                    time: toStringFormatter(j),
                                    onTap: () {
                                      Storage.orderId =
                                          orderedItems[index]["_id"];
                                      Navigator.pushNamed(
                                          context, OrderDetailScreen.id);
                                    },
                                    image: picFunc(),
                                  );
                                }),
                          ),
                          Expanded(
                            child: Center(
                              child: OrangeButton(
                                text: 'تحویل',
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, OrdersDeliveryConfirmation.id);
                                },
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
          );
  }
}
