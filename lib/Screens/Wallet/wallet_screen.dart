import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:masoul_kharid/Classes/Cards/wallet_card.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Screens/BottomSheets/deposit.dart';
import 'package:masoul_kharid/Screens/BottomSheets/withdraw_bsh.dart';
import 'package:masoul_kharid/Services/storage_class.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:intl/intl.dart' as intl;

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);
  static const String id = "WalletScreen";

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final storage = const FlutterSecureStorage();
  List<Map> depositsList = [];
  List<Map> withdrawalsList = [];
  List<Map> bankAccountsList = [];
  Map<int, Widget> statusMap = {
    0: const Text(
      'در حال پردازش',
      style: TextStyle(
        fontFamily: "Dana",
        fontWeight: FontWeight.bold,
        color: kOrangeColor,
        fontSize: 8,
      ),
    ),
    1: const Text(
      'پرداخت شده',
      style: TextStyle(
        fontFamily: "Dana",
        fontWeight: FontWeight.bold,
        color: Color(0xFF00FFB1),
        fontSize: 8,
      ),
    ),
    2: const Text(
      'رد شده',
      style: TextStyle(
        fontFamily: "Dana",
        fontWeight: FontWeight.bold,
        color: Color(0xFFFF0000),
        fontSize: 8,
      ),
    ),
    3: const Text(
      'لغو شده',
      style: TextStyle(
        fontFamily: "Dana",
        fontWeight: FontWeight.bold,
        color: Color(0xFFFF0000),
        fontSize: 8,
      ),
    ),
  };
  Map<int, Widget> dialogStatusMap = {
    0: Container(
      decoration: const BoxDecoration(
        color: kOrangeColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      width: 70,
      height: 20,
      child: const Center(
        child: Text(
          'در حال پردازش',
          style: TextStyle(
            fontFamily: "IranYekan",
            fontSize: 8,
            color: Colors.white,
          ),
        ),
      ),
    ),
    1: Container(
      decoration: const BoxDecoration(
        color: Color(0xFF00FFB1),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      width: 70,
      height: 20,
      child: const Center(
        child: Text(
          'پرداخت شده',
          style: TextStyle(
            fontFamily: "IranYekan",
            fontSize: 8,
            color: Colors.white,
          ),
        ),
      ),
    ),
    2: Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFF0000),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      width: 70,
      height: 20,
      child: const Center(
        child: Text(
          'رد شده',
          style: TextStyle(
            fontFamily: "IranYekan",
            fontSize: 8,
            color: Colors.white,
          ),
        ),
      ),
    ),
    3: Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFF0000),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      width: 70,
      height: 20,
      child: const Center(
        child: Text(
          'لغو شده',
          style: TextStyle(
            fontFamily: "IranYekan",
            fontSize: 8,
            color: Colors.white,
          ),
        ),
      ),
    ),
  };
  int? totalBalance;
  int? amount;
  int? status;
  String? createdAt;
  String? transactionMoment;
  String? causeReference;
  late Jalali depositCreated;
  late Jalali depositTAM;

  Future<void> _refresh() async {
    depositsList = [];
    withdrawalsList = [];
    getDepositsList();
    getWithdrawalsList();
    getBalance();
  }

  String toStringFormatter(Jalali j) {
    final f = j.formatter;

    return '${f.wN} ${f.d} ${f.mN} ${f.yy} | ${j.hour}:${j.minute}';
  }

  Future getDepositsList() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {'token': value!};
    try {
      var response = await http.get(
          Uri.parse(
              "https://testapi.carbon-family.com/api/market/history/deposits"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var deposits = jsonDecode(data)['deposits'];
        setState(() {
          for (var i = 0; i < deposits.length; i++) {
            depositsList.add(deposits[i]);
          }
        });
        print(depositsList);
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

  Future getWithdrawalsList() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {'token': value!};
    try {
      var response = await http.get(
          Uri.parse(
              "https://testapi.carbon-family.com/api/market/history/withdrawals"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var deposits = jsonDecode(data)['withdrawals'];
        setState(() {
          for (var i = 0; i < deposits.length; i++) {
            withdrawalsList.add(deposits[i]);
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

  Future getBalance() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {'token': value!};
    print(value);
    try {
      var response = await http.get(
          Uri.parse(
              "https://testapi.carbon-family.com/api/market/financial/balance"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var balance = jsonDecode(data)['balance'];
        setState(() {
          totalBalance = balance["freeBalance"];
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

  Future getDepositInfo() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {'token': value!};
    try {
      var response = await http.get(
        Uri.parse(
            "https://testapi.carbon-family.com/api/market/history/deposits/${Storage.depositId}"),
        headers: headers,
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        var data = response.body;
        setState(() {
          amount = jsonDecode(data)["deposit"]["amount"];
          status = jsonDecode(data)["deposit"]["status"];
          createdAt = jsonDecode(data)["deposit"]["createdAt"];
          transactionMoment = jsonDecode(data)["deposit"]["transactionMoment"];
          causeReference = jsonDecode(data)["deposit"]["causeReference"];
        });
        var dateAndTime = DateTime.parse(createdAt!).toLocal();
        Gregorian g = Gregorian.fromDateTime(dateAndTime);
        depositCreated = Jalali.fromGregorian(g);
        var dateAndTime2 = DateTime.parse(createdAt!).toLocal();
        Gregorian g2 = Gregorian.fromDateTime(dateAndTime2);
        depositTAM = Jalali.fromGregorian(g2);
      } else {
        print(response.body);
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future getWithdrawalInfo() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {'token': value!};
    try {
      var response = await http.get(
        Uri.parse(
            "https://testapi.carbon-family.com/api/market/history/withdrawals/${Storage.withdrawalId}"),
        headers: headers,
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        var data = response.body;
        setState(() {
          amount = jsonDecode(data)["withdrawal"]["amount"];
          status = jsonDecode(data)["withdrawal"]["status"];
          createdAt = jsonDecode(data)["withdrawal"]["createdAt"];
          transactionMoment =
              jsonDecode(data)["withdrawal"]["transactionMoment"];
          causeReference = jsonDecode(data)["withdrawal"]["causeReference"];
        });
        var dateAndTime = DateTime.parse(createdAt!).toLocal();
        Gregorian g = Gregorian.fromDateTime(dateAndTime);
        depositCreated = Jalali.fromGregorian(g);
        var dateAndTime2 = DateTime.parse(createdAt!).toLocal();
        Gregorian g2 = Gregorian.fromDateTime(dateAndTime2);
        depositTAM = Jalali.fromGregorian(g2);
      } else {
        print(response.body);
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future getBankAccoutnsList() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {'token': value!};
    try {
      var response = await http.get(
          Uri.parse(
              "https://testapi.carbon-family.com/api/market/financial/bankAccounts"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var accounts = jsonDecode(data)['bankAccounts'];
        setState(() {
          for (var i = 0; i < accounts.length; i++) {
            depositsList.add(accounts[i]);
          }
        });
        print(depositsList);
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
    getDepositsList();
    getWithdrawalsList();
    getBalance();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: kOrangeColor,
      onRefresh: _refresh,
      child: totalBalance == null
          ? const Center(
              child: CircularProgressIndicator(
              color: kOrangeColor,
            ))
          : DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 60,
                  centerTitle: true,
                  elevation: 0.5,
                  backgroundColor: Colors.white,
                  leading: const BackButton(
                    color: Colors.black,
                  ),
                  title: const Text(
                    'کیف پول',
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Container(
                      color: Colors.white,
                      child: ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Card
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Container(
                              decoration: const BoxDecoration(
                                // color: kOrangeColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                              height: 170,
                              child: Stack(
                                children: [
                                  const Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      child: Image(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          'images/staticImages/WalletCard.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: SizedBox(
                                      height: 130,
                                      width: 180,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 65,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                const Center(
                                                  child: Text(
                                                    'ارزش کل دارایی ها',
                                                    style: TextStyle(
                                                        fontFamily: "Dana",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                                Center(
                                                  child: Text(
                                                    intl.NumberFormat
                                                            .decimalPattern()
                                                        .format(totalBalance),
                                                    style: const TextStyle(
                                                        fontFamily: "IranYekan",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 22),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 65,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) =>
                                                            const DepositBSH());
                                                  },
                                                  child: const SizedBox(
                                                    height: 50,
                                                    width: 40,
                                                    child: Image(
                                                      image: AssetImage(
                                                        'images/Icons/DepositIcon.png',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) =>
                                                            const WithdrawBSH());
                                                  },
                                                  child: const SizedBox(
                                                    height: 50,
                                                    width: 40,
                                                    child: Image(
                                                      image: AssetImage(
                                                        'images/Icons/WithdrawalIcon.png',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Text(
                              'تاریخچه',
                              style: TextStyle(
                                fontFamily: 'Dana',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kNewsCardHeaderTextColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const TabBar(
                            labelPadding: EdgeInsets.all(4),
                            indicatorColor: Colors.black,
                            indicatorWeight: 1,
                            tabs: [
                              Text(
                                'برداشت ها',
                                style: TextStyle(
                                  fontFamily: "Dana",
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'واریز ها',
                                style: TextStyle(
                                  fontFamily: "Dana",
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: depositsList.length > withdrawalsList.length
                                ? 70 * depositsList.length.toDouble() + 50
                                : 70 * withdrawalsList.length.toDouble() + 50,
                            width: MediaQuery.of(context).size.width,
                            child: TabBarView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: withdrawalsList.isNotEmpty
                                        ? withdrawalsList.length
                                        : 0,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var dateAndTime = DateTime.parse(
                                              withdrawalsList[index]
                                                  ["createdAt"]!)
                                          .toLocal();
                                      Gregorian g =
                                          Gregorian.fromDateTime(dateAndTime);
                                      Jalali j = Jalali.fromGregorian(g);
                                      return WalletCard(
                                        type: 'برداشت',
                                        amount:
                                            intl.NumberFormat.decimalPattern()
                                                .format(withdrawalsList[index]
                                                    ["amount"]),
                                        dateAndTime: toStringFormatter(j),
                                        status: statusMap[withdrawalsList[index]
                                            ["status"]]!,
                                        onTap: () async {
                                          Storage.withdrawalId =
                                              withdrawalsList[index]["_id"];
                                          await getWithdrawalInfo();
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      20.0))),
                                                  title: SizedBox(
                                                    height: 150,
                                                    width: 300,
                                                    child: Center(
                                                      child: SizedBox(
                                                        width: 300,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              'مقدار',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Dana",
                                                                  fontSize: 9,
                                                                  color: Color(
                                                                      0xFF929292)),
                                                            ),
                                                            Text(
                                                              'تومان ${intl.NumberFormat.decimalPattern().format(amount)}',
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    "IranYekan",
                                                                fontSize: 22,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            dialogStatusMap[
                                                                status!]!,
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  content: SizedBox(
                                                    height: 170,
                                                    width: 300,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 50,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 45,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                      'زمان تراکنش',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Dana",
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Color(0xFF929292)),
                                                                    ),
                                                                    Text(
                                                                      toStringFormatter(
                                                                          depositCreated),
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              "IranYekan",
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const Divider(
                                                                thickness: 1,
                                                                height: 1,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 50,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 45,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                      'زمان ایجاد تراکنش',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Dana",
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Color(0xFF929292)),
                                                                    ),
                                                                    Text(
                                                                      toStringFormatter(
                                                                          depositTAM),
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              "IranYekan",
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const Divider(
                                                                thickness: 1,
                                                                height: 1,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 50,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 45,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                      'کد پیگیری',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Dana",
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Color(0xFF929292)),
                                                                    ),
                                                                    Text(
                                                                      '$causeReference',
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              "IranYekan",
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const Divider(
                                                                thickness: 1,
                                                                height: 1,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    OrangeButton(
                                                      text: 'بستن',
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: depositsList.isNotEmpty
                                        ? depositsList.length
                                        : 0,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var dateAndTime = DateTime.parse(
                                              depositsList[index]["createdAt"]!)
                                          .toLocal();
                                      Gregorian g =
                                          Gregorian.fromDateTime(dateAndTime);
                                      Jalali j = Jalali.fromGregorian(g);
                                      return WalletCard(
                                        type: 'واریز',
                                        amount:
                                            intl.NumberFormat.decimalPattern()
                                                .format(depositsList[index]
                                                    ["amount"]),
                                        dateAndTime: toStringFormatter(j),
                                        status: statusMap[depositsList[index]
                                            ["status"]]!,
                                        onTap: () async {
                                          Storage.depositId =
                                              depositsList[index]["_id"];
                                          await getDepositInfo();
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      20.0))),
                                                  title: SizedBox(
                                                    height: 150,
                                                    width: 300,
                                                    child: Center(
                                                      child: SizedBox(
                                                        width: 300,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              'مقدار',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Dana",
                                                                  fontSize: 9,
                                                                  color: Color(
                                                                      0xFF929292)),
                                                            ),
                                                            Text(
                                                              'تومان ${intl.NumberFormat.decimalPattern().format(amount)}',
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    "IranYekan",
                                                                fontSize: 22,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            dialogStatusMap[
                                                                status!]!,
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  content: SizedBox(
                                                    height: 170,
                                                    width: 300,
                                                    // color: Colors.amberAccent,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 50,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 45,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                      'زمان تراکنش',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Dana",
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Color(0xFF929292)),
                                                                    ),
                                                                    Text(
                                                                      toStringFormatter(
                                                                          depositCreated),
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              "IranYekan",
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const Divider(
                                                                thickness: 1,
                                                                height: 1,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 50,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 45,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                      'زمان ایجاد تراکنش',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Dana",
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Color(0xFF929292)),
                                                                    ),
                                                                    Text(
                                                                      toStringFormatter(
                                                                          depositTAM),
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              "IranYekan",
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const Divider(
                                                                thickness: 1,
                                                                height: 1,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 50,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 45,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                      'کد پیگیری',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Dana",
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Color(0xFF929292)),
                                                                    ),
                                                                    Text(
                                                                      '$causeReference',
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              "IranYekan",
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const Divider(
                                                                thickness: 1,
                                                                height: 1,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    OrangeButton(
                                                      text: 'بستن',
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
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
