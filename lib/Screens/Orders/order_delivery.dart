import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:masoul_kharid/Classes/Cards/order_list_card.dart';
import 'package:masoul_kharid/Classes/Dialogs/error_dialog.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/textfield_label_text_style.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Constants/constants.dart';
import 'package:masoul_kharid/Methods/text_field_input_decorations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:masoul_kharid/Screens/Orders/order_screen.dart';
import 'package:masoul_kharid/Screens/Orders/orders_list.dart';
import 'package:masoul_kharid/Screens/login_page.dart';
import 'package:masoul_kharid/Services/storage_class.dart';
import 'package:shamsi_date/shamsi_date.dart';

class OrdersDeliveryConfirmation extends StatefulWidget {
  const OrdersDeliveryConfirmation({Key? key}) : super(key: key);
  static const String id = "OrdersDeliveryConfirmation";

  @override
  State<OrdersDeliveryConfirmation> createState() =>
      _OrdersDeliveryConfirmationState();
}

class _OrdersDeliveryConfirmationState
    extends State<OrdersDeliveryConfirmation> {
  final storage = const FlutterSecureStorage();
  List orderedItems = [];
  String? firstName;
  String? lastName;
  String? mobile;
  String? profileImage;
  String? verificationCode;
  String? errorText;

  late Jalali j;

  courierPicInfo() {
    if (profileImage == null) {
      return const AssetImage(
        'images/staticImages/ShopDefaultPic.png',
      );
    } else {
      return NetworkImage('https://api.carbon-family.com/$profileImage');
    }
  }

  String toStringFormatter(Jalali j) {
    final f = j.formatter;

    return '${f.y},${f.m},${f.d}-${j.hour}:${j.minute}';
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
              "https://api.carbon-family.com/api/market/orders/delivery/${Storage.courierVerficationCode}"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var items = jsonDecode(data)["orders"];
        setState(() {
          for (var i = 0; i < items.length; i++) {
            orderedItems.add(items[i]);
          }
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
        if (response.statusCode == 403) {
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginPage.id,
            (Route<dynamic> route) => false,
          );
        }
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
            'https://api.carbon-family.com/api/market/orders/delivery/${Storage.courierVerficationCode}'),
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
        if (response.statusCode == 403) {
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginPage.id,
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getOrderAndCourierInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return firstName == null
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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  // color: Colors.amberAccent,
                  child: ListView(
                    children: [
                      Container(
                        // color: Colors.pinkAccent,
                        height: 300,
                        child: Column(
                          children: [
                            Container(
                              height: 300,
                              width: 300,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 60,
                                    backgroundImage: courierPicInfo(),
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'نام پیک',
                                        style: TextStyle(
                                          fontFamily: "Dana",
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF707070),
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        firstName == null
                                            ? ''
                                            : 'آقای $firstName  $lastName',
                                        style: const TextStyle(
                                          fontFamily: "Dana",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'شماره تماس',
                                        style: TextStyle(
                                          fontFamily: "Dana",
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF707070),
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        mobile == null ? '' : '$mobile',
                                        style: const TextStyle(
                                          fontFamily: "IranYekan",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 2,
                        thickness: 1,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: orderedItems.length * 85,
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: orderedItems.length,
                            itemBuilder: (context, int index) {
                              Widget picFunc() {
                                if (orderedItems[index]["shop"]["shopLogo"] ==
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
                                        'https://api.carbon-family.com/${orderedItems[index]["shop"]["shopLogo"]}'),
                                    fit: BoxFit.cover,
                                  );
                                }
                              }

                              var dateAndTime = DateTime.parse(
                                      orderedItems[index]["createdAt"]!)
                                  .toLocal();
                              Gregorian g = Gregorian.fromDateTime(dateAndTime);
                              j = Jalali.fromGregorian(g);
                              return OrderListCard(
                                shopName: orderedItems[index]["shop"]
                                    ["shopName"],
                                orderNumber: orderedItems[index]
                                        ["invoiceNumber"]
                                    .toString(),
                                time: toStringFormatter(j),
                                onTap: () {
                                  Storage.orderId = orderedItems[index]["_id"];
                                  Navigator.pushNamed(
                                      context, OrderDetailScreen.id);
                                },
                                image: picFunc(),
                              );
                            }),
                      ),
                      Container(
                        height: 100,
                        // color: Colors.blueAccent,
                        child: OrangeButton(
                          text: 'تحویل',
                          onPressed: () async {
                            await postDeliveryConfirmation();
                            errorText != null
                                ? showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ErrorDialog(
                                        errorText: '$errorText',
                                        onPressed: () {
                                          setState(() {
                                            errorText = null;
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    })
                                : Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    OrdersList.id,
                                    (Route<dynamic> route) => false,
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
