import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:masoul_kharid/Screens/Statistics/factor_screen.dart';
import 'package:masoul_kharid/Screens/login_page.dart';
import 'package:masoul_kharid/Services/storage_class.dart';

import '../../Classes/Cards/factor_list_card.dart';
import '../../Constants/colors.dart';

class FactorListScreen extends StatefulWidget {
  const FactorListScreen({Key? key}) : super(key: key);
  static const String id = "FactorListScreen";
  @override
  State<FactorListScreen> createState() => _FactorListScreenState();
}

class _FactorListScreenState extends State<FactorListScreen> {
  List invoices = [];

  final storage = const FlutterSecureStorage();
  Map<int, String> statusMap = {
    0: 'در حال پردازش',
    1: 'پرداخت شده',
    2: 'رد شده',
    3: 'لغو شده',
    4: 'در انتظار ارسال',
    5: 'تحویل داده شده به پیک',
    6: 'تحویل داده شده',
  };

  int page = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  late ScrollController _controller;

  Future getFactorsList() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      var response = await http.get(
          Uri.parse("https://testapi.carbon-family.com/api/market/invoices"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var factors = jsonDecode(data)["invoices"];
        setState(() {
          for (var i = 0; i < factors.length; i++) {
            invoices.add(factors[i]);
          }
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
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  Future loadMoreLoginActivity() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 100) {
      page += 1;
      print(page);
      setState(() {
        _isLoadMoreRunning = true;
      });
      try {
        final response = await http.get(
          Uri.parse(
              "https://testapi.carbon-family.com/api/market/invoices?page=$page"),
          headers: headers,
        );
        final List fetchedPosts = [];
        if (response.statusCode == 200) {
          var data = response.body;
          var items = jsonDecode(data)["invoices"];
          for (var i = 0; i < items.length; i++) {
            fetchedPosts.add(items[i]);
          }
          print(response.statusCode);
          print(response.body);
        }
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            invoices.addAll(fetchedPosts);
            _isLoadMoreRunning = false;
          });
        } else {
          setState(() {
            _hasNextPage = false;
            _isLoadMoreRunning = false;
          });
        }
      } catch (err) {
        print(err);
      }
    }
  }

  Future<void> refresh() async {
    invoices = [];
    getFactorsList();
  }

  @override
  void initState() {
    getFactorsList();
    _controller = ScrollController()..addListener(loadMoreLoginActivity);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(loadMoreLoginActivity);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: kOrangeColor,
        onRefresh: refresh,
        child: invoices.isEmpty
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
                    'فاکتورها',
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
                          horizontal: 20, vertical: 10),
                      child: ListView(
                        children: [
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 50,
                            // color: Colors.tealAccent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    Text(
                                      'فروشگاه',
                                      style: TextStyle(
                                        fontFamily: "IranYekan",
                                        color: Color(0xFF888888),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'شماره فاکتور',
                                      style: TextStyle(
                                        fontFamily: "IranYekan",
                                        color: Color(0xFF888888),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'وضعیت',
                                      style: TextStyle(
                                        fontFamily: "IranYekan",
                                        color: Color(0xFF888888),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text('فاکتور',
                                        style: TextStyle(
                                          fontFamily: "IranYekan",
                                          color: Color(0xFF888888),
                                          fontSize: 14,
                                        )),
                                  ],
                                ),
                                const Divider(
                                  color: Color(0xFF707070),
                                  thickness: 0.3,
                                  height: 0.5,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 700,
                            width: double.infinity,
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                      controller: _controller,
                                      itemCount: invoices.isNotEmpty
                                          ? invoices.length
                                          : 0,
                                      itemBuilder: (context, int index) {
                                        String statusText() {
                                          String? statusText;
                                          int num = invoices[index]["status"];
                                          statusText = statusMap[num];
                                          return statusText!;
                                        }

                                        return FactorListCard(
                                          storeName: invoices[index]["shop"]
                                                  ["shopName"] ??
                                              '-----',
                                          invoiceNumber: invoices[index]
                                              ["invoiceNumber"],
                                          onTap: () {
                                            Storage.invoiceId =
                                                invoices[index]["_id"];
                                            Navigator.pushNamed(
                                                context, FactorScreen.id);
                                          },
                                          status: statusText(),
                                        );
                                      }),
                                ),
                                if (_isLoadMoreRunning == true)
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: kOrangeColor,
                                      ),
                                    ),
                                  ),
                                if (_hasNextPage == false)
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 30, bottom: 40),
                                    child: const Center(
                                      child: Text(
                                        'پایان لیست',
                                        style: TextStyle(
                                          fontFamily: "Dana",
                                        ),
                                      ),
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
              ));
  }
}
