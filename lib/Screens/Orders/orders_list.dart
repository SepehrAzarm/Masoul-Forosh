import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:masoukharid/Classes/Cards/order_list_card.dart';
import 'package:masoukharid/Classes/Dialogs/error_dialog.dart';
import 'package:masoukharid/Classes/Text&TextStyle/textfield_label_text_style.dart';
import 'package:masoukharid/Classes/orange_button.dart';
import 'package:masoukharid/Constants/colors.dart';
import 'package:masoukharid/Constants/constants.dart';
import 'package:masoukharid/Methods/text_field_input_decorations.dart';
import 'package:masoukharid/Screens/Orders/order_screen.dart';
import 'package:masoukharid/Screens/profile_screen.dart';
import 'package:masoukharid/Services/storage_class.dart';
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
    return '${j.hour}:${j.minute}';
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
    getOrderList();
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
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0))),
                                          content: SizedBox(
                                            height: 100,
                                            width: 300,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 12),
                                                        height:
                                                            kLabelTextContainerHeight,
                                                        child: const TextFieldLabel(
                                                            text:
                                                                'کد پیک را وارد نمائید '),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      // controller: _controllerPhoneNumber,
                                                      cursorColor:
                                                          kButtonOrangeColor,
                                                      // textAlignVertical: TextAlignVertical.center,
                                                      textAlign:
                                                          TextAlign.center,
                                                      onChanged:
                                                          (String value) {
                                                        verificationCode =
                                                            value;
                                                      },
                                                      style: const TextStyle(
                                                        fontFamily: 'IranYekan',
                                                      ),
                                                      decoration:
                                                          textFieldDecorations(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            OrangeButton(
                                              text: 'تحویل',
                                              onPressed: () async {
                                                await getOrderAndCourierInfo();

                                                errorText != null
                                                    ? showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return ErrorDialog(
                                                            errorText:
                                                                '$errorText',
                                                            onPressed: () {
                                                              setState(() {
                                                                errorText =
                                                                    null;
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          );
                                                        })
                                                    : showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20.0))),
                                                            content: Container(
                                                              // color: Colors
                                                              //     .amberAccent,
                                                              height: 300,
                                                              width: 300,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  CircleAvatar(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    radius: 60,
                                                                    backgroundImage:
                                                                        courierPicInfo(),
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      const Text(
                                                                        'نام پیک',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              "Dana",
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Color(0xFF707070),
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        'آقای $firstName  $lastName',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontFamily:
                                                                              "Dana",
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              18,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      const Text(
                                                                        'شماره تماس',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              "Dana",
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Color(0xFF707070),
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '$mobile',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontFamily:
                                                                              "IranYekan",
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              18,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: [
                                                              OrangeButton(
                                                                text: 'تحویل',
                                                                onPressed:
                                                                    () async {
                                                                  await postDeliveryConfirmation();

                                                                  errorText ==
                                                                          null
                                                                      // ignore: use_build_context_synchronously
                                                                      ? Navigator
                                                                          .pushNamedAndRemoveUntil(
                                                                          context,
                                                                          OrdersList
                                                                              .id,
                                                                          (Route<dynamic> route) =>
                                                                              false,
                                                                        )
                                                                      : showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return ErrorDialog(
                                                                              errorText: '$errorText',
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  errorText = null;
                                                                                });
                                                                                Navigator.pop(context);
                                                                              },
                                                                            );
                                                                          });
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        });
                                              },
                                            ),
                                          ],
                                        );
                                      });
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
