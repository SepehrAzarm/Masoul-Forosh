import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:masoul_kharid/Classes/Cards/statistic_card.dart';
import 'package:masoul_kharid/Classes/Dialogs/error_dialog.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Screens/profile_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SellingItemsScreen extends StatefulWidget {
  const SellingItemsScreen({Key? key}) : super(key: key);
  static const String id = 'SellingItemsScreen';

  @override
  State<SellingItemsScreen> createState() => _SellingItemsScreenState();
}

class _SellingItemsScreenState extends State<SellingItemsScreen> {
  List sellItemsList = [];
  List itemsListTitle = [];
  List itemsTotalPrice = [];
  List itemsPercentage = [];
  final storage = const FlutterSecureStorage();

  Future getSellItemsList() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    try {
      var response = await http.get(
          Uri.parse(
              "https://testapi.carbon-family.com/api/market/history/sellItems/BasedOnProducts"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var sellItems = jsonDecode(data)["sellItems"]["products"];
        setState(() {
          for (var i = 0; i < sellItems.length; i++) {
            itemsListTitle.add(sellItems[i]["title"]);
            itemsTotalPrice.add(sellItems[i]["totalPrice"]);
            itemsPercentage.add(sellItems[i]["percentage"]);
          }
          sellItemsList = sellItems;
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

  Future<void> _refresh() async {
    itemsListTitle = [];
    itemsTotalPrice = [];
    itemsPercentage = [];
    getSellItemsList();
    sellItemsList.sort((a, b) {
      var r = (b['percentage']).compareTo(a['percentage']);
      if (r != 0) return r;
      return a["firstName"].compareTo(b["firstName"]);
    });
    print(sellItemsList);
  }

  double bottomSheetHeight() {
    double height;
    itemsListTitle.length * 85 < 400
        ? height = 400
        : height = itemsListTitle.length * 85;
    return height;
  }

  sellItemsListConfirm() async {
    await getSellItemsList();
    if (itemsListTitle.isEmpty) {
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(
              errorText: 'لیست اقلام فروش شما خالی میباشد',
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
    sellItemsListConfirm();
    getSellItemsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: kOrangeColor,
      onRefresh: _refresh,
      child: itemsListTitle.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
              color: kOrangeColor,
            ))
          : Scaffold(
              appBar: AppBar(
                toolbarHeight: 65,
                elevation: 0.2,
                centerTitle: true,
                backgroundColor: Colors.white,
                leading: const BackButton(
                  color: Colors.black,
                ),
                title: const Text(
                  'اقلام فروش',
                  style: TextStyle(
                    fontFamily: 'IranYekan',
                    color: kOrangeColor,
                    fontSize: 20,
                  ),
                ),
              ),
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('images/backgroundwhite.jpg'),
                    colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.07), BlendMode.dstATop),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 130,
                        child: Center(
                          child: Text(
                            'پرفروش ترین ها',
                            style: TextStyle(
                              fontFamily: 'IranYekan',
                              color: kOrangeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircularPercentIndicator(
                              lineWidth: 8,
                              radius: 80,
                              progressColor: kOrangeColor,
                              percent: itemsPercentage[0] / 100,
                              center: Text(
                                itemsListTitle[0],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'IranYekan',
                                  color: kOrangeColor,
                                ),
                              ),
                            ),
                            CircularPercentIndicator(
                              lineWidth: 8,
                              percent: itemsPercentage[1] / 100,
                              radius: 80,
                              progressColor: kOrangeColor,
                              center: Text(
                                itemsListTitle[1],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'IranYekan',
                                  color: kOrangeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                        ),
                        height: bottomSheetHeight(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: itemsListTitle.isNotEmpty
                                  ? itemsListTitle.length
                                  : 0,
                              itemBuilder: (context, int index) {
                                return StatisticCard(
                                  title: itemsListTitle[index],
                                  valueText: itemsTotalPrice[index],
                                  percent: itemsPercentage[index],
                                );
                              }),
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
