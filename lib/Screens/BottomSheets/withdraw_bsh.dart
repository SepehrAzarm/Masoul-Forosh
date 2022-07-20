import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:masoul_kharid/Classes/Text&TextStyle/bottom_sheet_labeltext.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/textfield_label_text_style.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Constants/constants.dart';
import 'package:masoul_kharid/Methods/bottom_sheet_boxdecoration.dart';
import 'package:masoul_kharid/Methods/text_field_input_decorations.dart';
import 'package:intl/intl.dart' as intl;

class WithdrawBSH extends StatefulWidget {
  const WithdrawBSH({Key? key}) : super(key: key);

  @override
  State<WithdrawBSH> createState() => _WithdrawBSHState();
}

class _WithdrawBSHState extends State<WithdrawBSH> {
  final storage = const FlutterSecureStorage();
  final TextEditingController _amount = TextEditingController();
  List bankAccounts = [];
  List toggled = [];
  Map? bankAccountInfo;
  int? amount;
  String? errorMassage;
  int? freeBalance;

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
            bankAccounts.add(accounts[i]);
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

  postWithdrawal() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {
      'token': value!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    Map data = {
      "amount": amount,
      "bankAccountInfo": bankAccountInfo,
    };
    var body = jsonEncode(data);
    try {
      var response = await http.post(
        Uri.parse(
            'https://testapi.carbon-family.com/api/market/financial/withdrawal'),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 201) {
        print(response.statusCode);
        print(response.body);
      } else {
        var errorData = await jsonDecode(response.body.toString());
        errorMassage = await errorData['message'];
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
          freeBalance = balance["freeBalance"];
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
    getBankAccoutnsList();
    getBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return freeBalance == null
        ? const Center(
            child: CircularProgressIndicator(
            color: kOrangeColor,
          ))
        : Container(
            color: kBottomSheetBackgroundColor,
            child: Container(
              height: 500,
              decoration: bottomSheetBoxDecoration(),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 15.0,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: BottomSheetLabelText(
                              text: 'برداشت',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            iconSize: 35,
                            color: kBottomSheetTextColor,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 140,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(right: 12),
                            height: kLabelTextContainerHeight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                TextFieldLabel(
                                    text: 'مبلغ برداشت را وارد کنید: '),
                                Text(
                                  '(به تومان)',
                                  style: TextStyle(
                                    fontFamily: "Dana",
                                    color: Color(0xFF6D6D6D),
                                    fontSize: 8,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              cursorColor: kButtonOrangeColor,
                              controller: _amount,
                              textAlign: TextAlign.center,
                              onChanged: (String value) {
                                amount = int.parse(value);
                              },
                              style: const TextStyle(
                                fontFamily: 'IranYekan',
                              ),
                              decoration: textFieldDecorations(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'موجودی در دسترس: ${intl.NumberFormat.decimalPattern().format(freeBalance)}',
                                  style: const TextStyle(
                                    fontFamily: "IranYekan",
                                    color: Color(0xFF6D6D6D),
                                    fontSize: 10,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _amount.text = '$freeBalance';
                                    });
                                  },
                                  child: const Text(
                                    'کل موجودی',
                                    style: TextStyle(
                                      fontFamily: "Dana",
                                      color: kOrangeColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: SizedBox(
                        height: 180,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'اطلاعات حساب بانکی خودرا انتخاب کنید',
                              style: TextStyle(
                                fontFamily: "Dana",
                                color: kBottomSheetTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 135,
                              child: ListView.builder(
                                itemCount: bankAccounts.length,
                                itemBuilder: (context, int index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: SizedBox(
                                      height: 30,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            activeColor: kButtonOrangeColor,
                                            value: toggled.contains(index)
                                                ? true
                                                : false,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                if (toggled.contains(index)) {
                                                  toggled.clear();
                                                } else {
                                                  toggled.add(index);
                                                }
                                                bankAccountInfo =
                                                    bankAccounts[index];
                                              });
                                            },
                                          ),
                                          Text(
                                            bankAccounts[index]
                                                ["bankPersianName"],
                                            style: const TextStyle(
                                              fontFamily: "Dana",
                                              color: kBottomSheetTextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            bankAccounts[index]["cardNumber"],
                                            style: const TextStyle(
                                              fontFamily: "IranYekan",
                                              color: Color(0xFF6D6D6D),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    OrangeButton(
                      text: 'برداشت',
                      onPressed: () async {
                        await postWithdrawal();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
