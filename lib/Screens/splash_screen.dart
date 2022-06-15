import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:masoukharid/Screens/get_started_page.dart';
import 'package:masoukharid/Screens/profile_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = 'SplashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = const FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    _navigateToGetStart();
  }

  void _navigateToGetStart() async {
    await Future.delayed(const Duration(seconds: 2), () {});
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

    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => const GetStartedPage()),
    //   (Route<dynamic> route) => false,
    // );
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
