import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:masoukharid/Classes/Cards/turnover_card.dart';
import 'package:masoukharid/Constants/colors.dart';
import 'package:masoukharid/Services/storage_class.dart';

class TurnOverScreen extends StatefulWidget {
  const TurnOverScreen({Key? key}) : super(key: key);
  static const String id = 'TurnOverScreen';

  @override
  State<TurnOverScreen> createState() => _TurnOverScreenState();
}

class _TurnOverScreenState extends State<TurnOverScreen> {
  int totalSellAmount = 0;
  int totalDoneDepositAmount = 0;
  int totalPendingDepositAmount = 0;
  int totalDoneWithdrawalsAmount = 0;
  int totalPendingWithdrawalsAmount = 0;
  String? companyName;
  String? imagePath;

  Future getMarketInfo() async {
    Map<String, String> headers = {'token': Storage.token};
    try {
      var response = await http.get(
        Uri.parse('https://testapi.carbon-family.com/api/market/profile'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var data = response.body;
        var marketInfo = jsonDecode(data)['market'];
        setState(() {
          companyName = marketInfo["companyName"];
          imagePath = marketInfo["logo"];
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

  Future getTurnOver() async {
    Map<String, String> headers = {
      'token': Storage.token,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    try {
      var response = await http.get(
          Uri.parse(
              "https://testapi.carbon-family.com/api/market/financial/turnover"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        setState(() {
          totalSellAmount = jsonDecode(data)["totalSellAmount"];
          totalDoneDepositAmount = jsonDecode(data)["totalDoneDepositAmount"];
          totalPendingDepositAmount =
              jsonDecode(data)["totalPendingDepositAmount"];
          totalDoneWithdrawalsAmount =
              jsonDecode(data)["totalDoneWithdrawalsAmount"];
          totalPendingWithdrawalsAmount =
              jsonDecode(data)["totalPendingWithdrawalsAmount"];
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

  @override
  void initState() {
    getMarketInfo();
    getTurnOver();
    super.initState();
  }

  Future<void> _refresh() async {
    getMarketInfo();
    getTurnOver();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: kOrangeColor,
      onRefresh: _refresh,
      // ignore: unnecessary_null_comparison
      child: companyName == null
          ? const Center(
              child: CircularProgressIndicator(
              color: kOrangeColor,
            ))
          : Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                toolbarHeight: 65,
                elevation: 0.2,
                centerTitle: true,
                backgroundColor: Colors.white,
                leading: const BackButton(
                  color: Colors.black,
                ),
                title: const Text(
                  'گردش مالی',
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
                      SizedBox(
                        height: 170,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 35,
                              child: CircleAvatar(
                                radius: 32,
                                backgroundImage: NetworkImage(
                                  imagePath != null
                                      ? 'https://testapi.carbon-family.com/' +
                                          imagePath!
                                      : 'https://testapi.carbon-family.com/uploads/markets/marketImages/7185b4aa4494c37820e2d4abfefc6166_6246f113965272bf7ca06282_1648818031253.jpg',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 8.0,
                                top: 8.0,
                              ),
                              child: Text(
                                'فروشگاه $companyName',
                                style: const TextStyle(
                                  fontFamily: 'Dana',
                                  fontSize: 22,
                                  color: Color(0xFF1C2532),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: 230,
                          child: Center(
                            child: Stack(
                              children: [
                                const SizedBox(
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      'میزان کل فروش',
                                      style: TextStyle(
                                        fontFamily: 'IranYekan',
                                        fontWeight: FontWeight.bold,
                                        color: kOrangeColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: SizedBox(
                                    height: 72,
                                    child: Center(
                                      child: Text(
                                        '$totalSellAmount',
                                        style: const TextStyle(
                                          fontFamily: 'IranYekan',
                                          fontWeight: FontWeight.bold,
                                          color: kOrangeColor,
                                          fontSize: 50,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 8, top: 70),
                                  child: SizedBox(
                                    height: 33,
                                    child: Text(
                                      'تومان',
                                      style: TextStyle(
                                        fontFamily: 'IranYekan',
                                        color: kOrangeColor,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 29),
                      Container(
                        height: 350,
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              // SizedBox(height: 20),
                              TurnOverCard(
                                title: 'واریز در حال انتظار',
                                valueText: totalPendingDepositAmount,
                              ),
                              TurnOverCard(
                                title: 'برداشت در حال انتظار',
                                valueText: totalPendingWithdrawalsAmount,
                              ),
                              TurnOverCard(
                                title: 'واریز',
                                valueText: totalDoneDepositAmount,
                              ),
                              TurnOverCard(
                                title: 'برداشت',
                                valueText: totalDoneWithdrawalsAmount,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
