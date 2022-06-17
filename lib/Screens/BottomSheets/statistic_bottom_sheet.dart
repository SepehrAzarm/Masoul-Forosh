import 'package:flutter/material.dart';
import 'package:masoukharid/Classes/Text&TextStyle/bottom_sheet_labeltext.dart';
import 'package:masoukharid/Constants/colors.dart';
import 'package:masoukharid/Methods/bottom_sheet_boxdecoration.dart';
import 'package:masoukharid/Screens/Statistics/factors_list.dart';
import 'package:masoukharid/Screens/Statistics/items_screen.dart';
import 'package:masoukharid/Screens/Statistics/turnover_screen.dart';

import '../../Classes/statistics_bsh_content_widget.dart';

class StatisticsBSH extends StatefulWidget {
  const StatisticsBSH({Key? key}) : super(key: key);

  @override
  _StatisticsBSHState createState() => _StatisticsBSHState();
}

class _StatisticsBSHState extends State<StatisticsBSH> {
  final String employeeImageAsset = 'images/Icons/EmployeesIcon.png';
  final String orangeShopImageAsset = 'images/Icons/OrangeShop.png';
  final String aghlamImageAsset = 'images/Icons/AghlamIcon.png';
  final String customersImageAsset = 'images/Icons/CustomersIcon.png';
  final String favtorImageAsset = "images/Icons/FactorIcon.png";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBottomSheetBackgroundColor,
      child: Container(
        height: 350.0,
        decoration: bottomSheetBoxDecoration(),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),
          child: Center(
            child: Column(
              children: [
                //Title
                SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BottomSheetLabelText(
                        text: 'انتخاب گزارشات',
                        fontSize: 22,
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
                const SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    height: 250,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Center(
                        child: Column(
                          children: [
                            StatisticsBSHContent(
                              image: favtorImageAsset,
                              text: 'فاکتور ها',
                              onTap: () {
                                Navigator.pushNamed(
                                    context, FactorListScreen.id);
                              },
                            ),
                            const Divider(thickness: 1),
                            StatisticsBSHContent(
                              image: orangeShopImageAsset,
                              text: 'گردش مالی',
                              onTap: () {
                                Navigator.pushNamed(context, TurnOverScreen.id);
                              },
                            ),
                            const Divider(thickness: 1),
                            StatisticsBSHContent(
                              image: aghlamImageAsset,
                              text: 'اقلام فروش',
                              onTap: () {
                                Navigator.pushNamed(
                                    context, SellingItemsScreen.id);
                              },
                            ),
                            const Divider(thickness: 1),
                          ],
                        ),
                      ),
                    ),
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
