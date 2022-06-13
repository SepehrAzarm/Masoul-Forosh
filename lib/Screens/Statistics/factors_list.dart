import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:masoukharid/Screens/Statistics/factor_screen.dart';
import 'package:masoukharid/Services/storage_class.dart';

import '../../Classes/Cards/factor_list_card.dart';
import '../../Constants/colors.dart';

class FactorListScreen extends StatefulWidget {
  const FactorListScreen({Key? key}) : super(key: key);
  static const String id = "FactorListScreen";
  @override
  State<FactorListScreen> createState() => _FactorListScreenState();
}

class _FactorListScreenState extends State<FactorListScreen> {
  List invoiceNumber = [];
  List invoiceId = [];
  List storeName = [];

  Future getFactorsList() async {
    Map<String, String> headers = {
      'token': Storage.token,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    try {
      var response = await http.get(
          Uri.parse("https://testapi.carbon-family.com/api/market/invoices"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var factors = jsonDecode(data)["invoices"];
        setState(() {
          for (var i = 0; i < factors.length; i++) {
            storeName.add(factors[i]["shop"]["shopName"]);
            invoiceNumber.add(factors[i]["invoiceNumber"]);
            invoiceId.add(factors[i]["_id"]);
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

  Future<void> refresh() async {
    storeName = [];
    invoiceId = [];
    invoiceNumber = [];
    getFactorsList();
  }

  @override
  void initState() {
    getFactorsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: kOrangeColor,
        onRefresh: refresh,
        child: storeName.isEmpty
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
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      'شماره فاکتور',
                                      style: TextStyle(
                                        fontFamily: "IranYekan",
                                        color: Color(0xFF888888),
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      'فاکتور',
                                      style: TextStyle(
                                        fontFamily: "IranYekan",
                                        color: Color(0xFF888888),
                                        fontSize: 15,
                                      ),
                                    ),
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
                            child: ListView.builder(
                                itemCount:
                                    storeName.isNotEmpty ? storeName.length : 0,
                                itemBuilder: (context, int index) {
                                  return FactorListCard(
                                      storeName: storeName[index],
                                      invoiceNumber: invoiceNumber[index],
                                      onTap: () {
                                        Storage.invoiceId = invoiceId[index];
                                        Navigator.pushNamed(
                                            context, FactorScreen.id);
                                      });
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }
}
