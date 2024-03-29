import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:masoul_kharid/Classes/Cards/turnover_card.dart';
import 'package:masoul_kharid/Classes/Dialogs/error_dialog.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Screens/login_page.dart';
import 'package:masoul_kharid/Screens/profile_screen.dart';

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
  final storage = const FlutterSecureStorage();

    profilePicFunc() {
    if (imagePath == null) {
      return const AssetImage(
        'images/staticImages/productStaticImage.jpg',
      );
    } else {
      return NetworkImage('https://api.carbon-family.com/${imagePath!}');
    }
  }

  Future getMarketInfo() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {'token': value!};
    try {
      var response = await http.get(
        Uri.parse('https://api.carbon-family.com/api/market/profile'),
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
        if (response.statusCode == 401) {
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginPage.id,
            (Route<dynamic> route) => false,
          );
        }
        if (response.statusCode == 403) {
          showDialog(
              context: context,
              builder: (context) {
                return ErrorDialog(
                  errorText: 'شما دسترسی به این بخش را ندارید',
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
    } catch (e) {
      print(e);
    }
  }

  Future getTurnOver() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    try {
      var response = await http.get(
          Uri.parse(
              "https://api.carbon-family.com/api/market/financial/turnover"),
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
                                backgroundImage: profilePicFunc(),
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
