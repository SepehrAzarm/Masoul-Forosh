import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:masoul_kharid/Classes/Cards/product_card.dart';
import 'package:masoul_kharid/Classes/Dialogs/aboutus_dialog.dart';
import 'package:masoul_kharid/Classes/Dialogs/error_dialog.dart';
import 'package:masoul_kharid/Classes/settings_body_content.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Constants/strings.dart';
import 'package:masoul_kharid/Screens/BottomSheets/employee_settings.dart';
import 'package:masoul_kharid/Screens/BottomSheets/statistic_bottom_sheet.dart';
import 'package:masoul_kharid/Screens/Employees/add_employee.dart';
import 'package:masoul_kharid/Screens/Employees/employe_list.dart';
import 'package:masoul_kharid/Screens/News/add_news.dart';
import 'package:masoul_kharid/Screens/Products/add_product.dart';
import 'package:masoul_kharid/Screens/Products/product_edit.dart';
import 'package:masoul_kharid/Screens/Ticket/tickets_list.dart';
import 'package:masoul_kharid/Screens/account_settings.dart';
import 'package:masoul_kharid/Screens/login_page.dart';
import 'package:masoul_kharid/Services/storage_class.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String id = 'ProfileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final storage = const FlutterSecureStorage();
  List productsList = [];
  TabController? _tabController;
  String? companyName;
  String? imagePath;
  String? address;
  String? from;
  String? to;
  int? fee;
  int page = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  late ScrollController _controller;

  productDefaultPic(int index) {
    if (productsList[index]["media"].isEmpty) {
      return const AssetImage(
        'images/staticImages/productStaticImage.jpg',
      );
    } else {
      return NetworkImage(
          'https://api.carbon-family.com/${productsList[index]["media"][0]}');
    }
  }

  Future getProductList() async {
    String? value = await storage.read(key: "token");
    Map<String, String> headers = {'token': value!};
    print(value);
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      var response = await http.get(
          Uri.parse("https://api.carbon-family.com/api/market/products"),
          headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        var products = jsonDecode(data)['products'];
        setState(() {
          for (var i = 0; i < products.length; i++) {
            productsList.add(products[i]);
          }
        });
        print(response.statusCode);
        print(response.body);
      } else {
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 401) {
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

  Future loadMoreProducts() async {
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
              "https://api.carbon-family.com/api/market/products?page=$page"),
          headers: headers,
        );
        final List fetchedPosts = [];
        if (response.statusCode == 200) {
          var data = response.body;
          var items = jsonDecode(data)["products"];
          for (var i = 0; i < items.length; i++) {
            fetchedPosts.add(items[i]);
          }
          print(response.statusCode);
          print(response.body);
        }
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            productsList.addAll(fetchedPosts);
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
    productsList = [];
    getProductList();
    getMarketInfo();
  }

  profilePicFunc() {
    if (imagePath == null) {
      return const AssetImage(
        'images/staticImages/productStaticImage.jpg',
      );
    } else {
      return NetworkImage('https://api.carbon-family.com/${imagePath!}');
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _controller = ScrollController()..addListener(loadMoreProducts);
    getMarketInfo();
    getProductList();
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(loadMoreProducts);
    super.dispose();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
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
                controller: _controller,
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
                                                height: 50,
                                                child: Text(
                                                  'فروشگاه $companyName ',
                                                  style: const TextStyle(
                                                    fontFamily: 'Dana',
                                                    fontSize: 22,
                                                    color:
                                                        kProfileCompanyNameTextColor,
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
                          backgroundColor: Colors.white,
                          radius: 60,
                          child: CircleAvatar(
                            radius: 57,
                            backgroundImage: profilePicFunc(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 120 * productsList.length.toDouble() + 100,
                        width: MediaQuery.of(context).size.width,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: productsList.isNotEmpty
                                        ? productsList.length
                                        : 0,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ProductCard(
                                        onTap: () async {
                                          Storage.productId =
                                              await productsList[index]["_id"];
                                          Navigator.pushNamed(
                                              context, ProductEdit.id);
                                        },
                                        title: productsList[index]["title"],
                                        image: productsList[index]["media"]
                                                .isEmpty
                                            ? const Image(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                  'images/staticImages/productStaticImage.jpg',
                                                ),
                                              )
                                            : Image(
                                                image: productDefaultPic(index),
                                                fit: BoxFit.cover,
                                              ),
                                      );
                                    },
                                  ),
                                ),
                                if (_isLoadMoreRunning == true)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10),
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
                            const SizedBox(
                              height: 400,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  'به زودی',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Dana",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40,
                                    color: kOrangeColor,
                                  ),
                                ),
                              ),
                            ),
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
                            backgroundImage: profilePicFunc(),
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
                Navigator.pushNamed(context, EmployeeList.id);
              },
            ),
            SettingsBodyContent(
              text: 'شکایات و نظرات',
              image: 'images/SettingsIcons/Support.png',
              onTap: () {
                Navigator.pushNamed(context, TicketsList.id);
              },
            ),
            SettingsBodyContent(
              text: 'درباره ما',
              image: 'images/SettingsIcons/AboutUs.png',
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) =>
                      const AboutUsDialog(text: kDefaultText),
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
                                    storage.delete(key: "token");
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
      body: Center(child: pages.elementAt(_selectedIndex)),
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
