import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Screens/get_started_page.dart';
import 'package:masoul_kharid/Screens/profile_screen.dart';
import 'package:masoul_kharid/Screens/terms_and_conditions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:is_first_run/is_first_run.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = 'SplashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = const FlutterSecureStorage();
  String? version;
  String? appLink;
  Uri? url;
  @override
  void initState() {
    super.initState();
    checkFirstRun();
  }

  Future getGlobalInfo() async {
    try {
      var response = await http.get(
        Uri.parse(
            'https://testapi.carbon-family.com/api/market/configs/globalConfigs'),
      );
      if (response.statusCode == 200) {
        var data = response.body;
        setState(() {
          version =
              jsonDecode(data)["data"]["application"]["android"]["version"];
          appLink = jsonDecode(data)["data"]["application"]["android"]["app"];
          url = Uri.parse("https://$appLink");
        });
        print(response.statusCode);
        print(appLink);
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  void _navigateToGetStart() async {
    String? value = await storage.read(key: "token");
    if (value == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const GetStartedPage()),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<void> _launchUrl() async {
    await launchUrl(url!, mode: LaunchMode.externalApplication);
  }

  void checkVersion() async {
    await getGlobalInfo();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    print(version);
    print(currentVersion);
    if (currentVersion != version) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Center(
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Image(
                    image: AssetImage('images/ErroIcon.png'),
                  ),
                ),
              ),
              content: const Text(
                'نسخۀ نرم افزار شما قدیمی است. لطفا جهت استفاده بهتر از خدمات ابتدا اپلیکشن خود را به روز رسانی نمایید',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'IranYekan',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                OrangeButton(
                  text: 'بارگیری',
                  onPressed: () async {
                    await _launchUrl();
                  },
                ),
              ],
            );
          });
    } else {
      _navigateToGetStart();
    }
  }

  checkFirstRun() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    bool firstRun = await IsFirstRun.isFirstRun();
    if (firstRun == true) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        TermsAndConditionsScreen.id,
        (Route<dynamic> route) => false,
      );
    } else {
      checkVersion();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/background.jpg'),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: const Center(
        child: SizedBox(
          width: 250.0,
          height: 110.0,
          child: Center(child: Image(image: AssetImage('images/MainLogo.png'))),
        ),
      ),
    );
  }
}
