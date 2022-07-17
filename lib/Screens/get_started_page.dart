import 'package:flutter/material.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:masoul_kharid/Screens/login_page.dart';
import 'package:page_transition/page_transition.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({Key? key}) : super(key: key);
  static const String id = 'GetStartedPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
              flex: 5,
              child: Center(
                child: SizedBox(
                  width: 250,
                  height: 110,
                  child: Center(
                    child: Image(image: AssetImage('images/MainLogo.png')),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OrangeButton(
                    text: 'ورود',
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const LoginPage(),
                              type: PageTransitionType.leftToRightWithFade));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
