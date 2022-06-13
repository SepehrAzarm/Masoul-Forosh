import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:masoukharid/Classes/Cards/product_card.dart';
import 'package:masoukharid/Classes/Dialogs/aboutus_dialog.dart';
import 'package:masoukharid/Classes/settings_body_content.dart';
import 'package:masoukharid/Constants/colors.dart';
import 'package:masoukharid/Screens/BottomSheets/employee_settings.dart';
import 'package:masoukharid/Screens/BottomSheets/statistic_bottom_sheet.dart';
import 'package:masoukharid/Screens/Employees/add_employee.dart';
import 'package:masoukharid/Screens/News/add_news.dart';
import 'package:masoukharid/Screens/Products/add_product.dart';
import 'package:masoukharid/Screens/Products/products_mainpage.dart';
import 'package:masoukharid/Screens/PtofileScreenContent/news_list.dart';
import 'package:masoukharid/Screens/account_settings.dart';
import 'package:masoukharid/Screens/login_page.dart';
import 'package:masoukharid/Screens/support_ticket.dart';
import 'package:masoukharid/Services/storage_class.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String id = 'ProfileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  List productTitles = [];
  List productAvailableAmount = [];
  List productDescription = [];
  List productIdList = [];
  List productImageList = [];
  TabController? _tabController;
  String? companyName;
  String? imagePath;
  String? address;
  String? from;
  String? to;
  int? fee;

  Future getProductList() async {
    Map<String, String> headers = {'token': Storage.token};
    try {
      var response = await http.get(
          Uri.parse("https://testapi.carbon-family.com/api/market/products"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var admins = jsonDecode(data)['products'];
        setState(() {
          for (var i = 0; i < admins.length; i++) {
            productTitles.add(admins[i]["title"]);
            productDescription.add(admins[i]["description"]);
            productAvailableAmount.add(admins[i]["availableAmount"]);
            productIdList.add(admins[i]["_id"]);
            productImageList.add(admins[i]["media"]);
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
          address = marketInfo["locationInfo"]["address"];
          imagePath = marketInfo["logo"];
          from = marketInfo["activeHours"]["from"].toString();
          to = marketInfo["activeHours"]["to"].toString();
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
    getProductList();
    getMarketInfo();
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getMarketInfo();
    getProductList();
    super.initState();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = <Widget>[
      //Profile
      RefreshIndicator(
        color: kOrangeColor,
        onRefresh: _refresh,
        child: companyName == null
            ? const Center(
                child: CircularProgressIndicator(
                color: kOrangeColor,
              ))
            : ListView(
                shrinkWrap: true,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 540,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SafeArea(
                              child: Container(
                                color: Colors.amber,
                                height: 210,
                                width: MediaQuery.of(context).size.width,
                                child: const Image(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                    'images/HeaderPics/profileheaderpic.jpg',
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //Profile Part
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 60, left: 25, right: 25),
                                  child: SizedBox(
                                    height: 256,
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 8.0,
                                                top: 8.0,
                                              ),
                                              child: SizedBox(
                                                width: 320,
                                                height: 50,
                                                child: Text(
                                                  'فروشگاه $companyName ',
                                                  style: const TextStyle(
                                                    fontFamily: 'Dana',
                                                    fontSize: 22,
                                                    color: Color(0xFF1C2532),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: SizedBox(
                                            height: 25,
                                            width: 300,
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  size: 18,
                                                  color: Color(0xff888484),
                                                ),
                                                Text(
                                                  '$address',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Dana',
                                                    color: kGreyTextColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 25),
                                        //Delivery Price & active hours
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: SizedBox(
                                            height: 30,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.access_time_rounded,
                                                  color: kGreyTextColor,
                                                  size: 25,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  '$from الی $to',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'IranYekan',
                                                    color: kGreyTextColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //Button
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 10,
                                          ),
                                          child: SizedBox(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: kOrangeColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  height: 45,
                                                  width: 160,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      print(Storage.token);
                                                      Navigator.pushNamed(
                                                          context,
                                                          AccountSettings.id);
                                                    },
                                                    child: const Center(
                                                      child: Text(
                                                        'ویرایش',
                                                        style: TextStyle(
                                                          fontFamily: 'Dana',
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: kOrangeColor,
                                                    ),
                                                    // color: kButtonOrangeColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  height: 45,
                                                  width: 160,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                          context: context,
                                                          builder: (context) =>
                                                              const StatisticsBSH());
                                                    },
                                                    child: const Center(
                                                      child: Text(
                                                        'گزارشات',
                                                        style: TextStyle(
                                                          fontFamily: 'Dana',
                                                          fontSize: 14,
                                                          color: kOrangeColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        TabBar(
                                          controller: _tabController,
                                          indicatorColor: kOrangeColor,
                                          tabs: const [
                                            Tab(
                                              icon: FaIcon(
                                                FontAwesomeIcons.shoppingCart,
                                                color: kOrangeColor,
                                              ),
                                            ),
                                            Tab(
                                                icon: FaIcon(
                                              FontAwesomeIcons.newspaper,
                                              color: kOrangeColor,
                                            )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //Circle Avatar
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 140,
                          right: 20,
                        ),
                        child: CircleAvatar(
                          backgroundColor: kOrangeColor,
                          radius: 60,
                          child: CircleAvatar(
                            radius: 57,
                            backgroundImage: NetworkImage(
                              imagePath != null
                                  ? 'https://testapi.carbon-family.com/' +
                                      imagePath!
                                  : 'https://testapi.carbon-family.com/uploads/markets/marketImages/7185b4aa4494c37820e2d4abfefc6166_6246f113965272bf7ca06282_1648818031253.jpg',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 130 * productTitles.length.toDouble() + 100,
                        width: MediaQuery.of(context).size.width,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: productTitles.isNotEmpty
                                  ? productTitles.length
                                  : 0,
                              itemBuilder: (BuildContext context, int index) {
                                return ProductCard(
                                  onTap: () async {
                                    Storage.productId =
                                        await productIdList[index];

                                    Navigator.pushNamed(
                                        context, ProductsMainPage.id);
                                  },
                                  title: productTitles[index],
                                  availableAmount:
                                      productAvailableAmount[index].toString(),
                                  image: productImageList[index].isEmpty
                                      ? 'https://testapi.carbon-family.com/uploads/products/productsImages/635dc499204c404d99b3c3484b7c96fd_6246f113965272bf7ca06282_1648817959178.jpg'
                                      : 'https://testapi.carbon-family.com/' +
                                          productImageList[index][0],
                                );
                              },
                            ),
                            const NewsList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
      //Settings
      RefreshIndicator(
        color: kOrangeColor,
        onRefresh: getMarketInfo,
        child: ListView(
          children: [
            Stack(
              children: [
                SafeArea(
                  child: SizedBox(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: const Image(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        'images/HeaderPics/SettingsHeader.png',
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 230,
                    height: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 60,
                          child: CircleAvatar(
                            radius: 57,
                            backgroundImage: NetworkImage(
                              imagePath != null
                                  ? 'https://testapi.carbon-family.com/' +
                                      imagePath!
                                  : 'https://testapi.carbon-family.com/uploads/markets/marketImages/d798a55449bc9df4d13d7c46045150c7_62370134273683037652865c.jpg',
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AddNewEmployee.id);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            width: 370.0,
                            height: 50.0,
                            child: const Center(
                              child: Text(
                                'افزودن کارمند',
                                style: TextStyle(
                                  color: kOrangeColor,
                                  fontFamily: 'Dana',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SettingsBodyContent(
              text: 'تنظیمات حساب',
              image: 'images/SettingsIcons/EditIcon.png',
              onTap: () {
                Navigator.pushNamed(context, AccountSettings.id);
              },
            ),
            SettingsBodyContent(
              text: 'تنظیمات کارمندان',
              image: 'images/SettingsIcons/EmployeeSettings.png',
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => const EmployeesSettingsBSH());
              },
            ),
            SettingsBodyContent(
              text: 'شکایات و نظرات',
              image: 'images/SettingsIcons/Support.png',
              onTap: () {
                Navigator.pushNamed(context, SupportTicketScreen.id);
              },
            ),
            SettingsBodyContent(
              text: 'درباره ما',
              image: 'images/SettingsIcons/AboutUs.png',
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => const AboutUsDialog(),
                );
              },
            ),
            SettingsBodyContent(
              text: 'خروج از حساب کاربری',
              image: 'images/SettingsIcons/LogOut.png',
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Center(
                          child: Text(
                            'آیا میخواهید خارج شوید؟',
                            style: TextStyle(
                              fontFamily: 'IranYekan',
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFFF0000),
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                height: 45,
                                width: 140,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Center(
                                    child: Text(
                                      'خیر',
                                      style: TextStyle(
                                        fontFamily: 'Dana',
                                        fontSize: 14,
                                        color: Color(0xFFFF0000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF0000),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                height: 45,
                                width: 140,
                                child: TextButton(
                                  onPressed: () {
                                    Storage.resetToken();
                                    print(Storage.token);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                  child: const Center(
                                    child: Text(
                                      'خروج',
                                      style: TextStyle(
                                        fontFamily: 'Dana',
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    });
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    ];
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FittedBox(
          child: SpeedDial(
            overlayColor: kOrangeColor,
            overlayOpacity: 0.5,
            childrenButtonSize: const Size(80.0, 80.0),
            spaceBetweenChildren: 5.0,
            backgroundColor: kOrangeColor,
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                onTap: () {
                  Navigator.pushNamed(context, AddNewsPage.id);
                },
                child: const SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(
                    child: Text(
                      'خبر',
                      style: TextStyle(
                        fontFamily: "IranYekan",
                        fontSize: 14,
                        color: kOrangeColor,
                      ),
                    ),
                  ),
                ),
              ),
              SpeedDialChild(
                onTap: () {
                  Navigator.pushNamed(context, AddProductPage.id);
                },
                backgroundColor: kOrangeColor,
                child: const SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(
                    child: Text(
                      'محصول',
                      style: TextStyle(
                        fontFamily: "IranYekan",
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Center(child: _pages.elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: kOrangeColor,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              label: 'حساب',
              icon: SizedBox(
                width: 35,
                height: 35,
                child: Image(
                    image: AssetImage(
                        'images/BottomNavigationBarIcons/ShopIconBNBarOff.png')),
              ),
              activeIcon: SizedBox(
                width: 35,
                height: 35,
                child: Image(
                  image: AssetImage(
                      'images/BottomNavigationBarIcons/ShopIconBNBarOn.png'),
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: 'تنظیمات',
              icon: SizedBox(
                width: 35,
                height: 35,
                child: Image(
                    image: AssetImage(
                        'images/BottomNavigationBarIcons/SettingsIconOff.png')),
              ),
              activeIcon: SizedBox(
                width: 35,
                height: 35,
                child: Image(
                  image: AssetImage(
                      'images/BottomNavigationBarIcons/SettingIconOn.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
