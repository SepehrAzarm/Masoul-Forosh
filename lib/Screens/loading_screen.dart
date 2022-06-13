import 'package:flutter/material.dart';
import 'package:masoukharid/Constants/colors.dart';
import 'package:masoukharid/Screens/profile_screen.dart';

class LoadingSplashScreen extends StatefulWidget {
  const LoadingSplashScreen({Key? key}) : super(key: key);
  static const String id = "LoadingSplashScreen";

  @override
  State<LoadingSplashScreen> createState() => _LoadingSplashScreenState();
}

class _LoadingSplashScreenState extends State<LoadingSplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    Navigator.pushReplacementNamed(context, ProfileScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/backgroundwhite.jpg'),
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.07), BlendMode.dstATop),
            fit: BoxFit.cover,
          ),
        ),
        child: const SafeArea(
          child: Center(
            child: SizedBox(
              height: 70,
              width: 70,
              child: CircularProgressIndicator(
                color: kOrangeColor,
                strokeWidth: 6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
