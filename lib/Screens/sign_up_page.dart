import 'package:flutter/material.dart';
import 'package:masoul_kharid/Constants/constants.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/textfield_label_text_style.dart';
import 'package:masoul_kharid/Methods/text_field_input_decorations.dart';
import 'package:masoul_kharid/Classes/orange_button.dart';
import 'package:masoul_kharid/Classes/Text&TextStyle/orange_header_text.dart';
import 'package:masoul_kharid/Constants/colors.dart';
import 'package:lottie/lottie.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  static const String id = 'SignUpPage';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerPassRepeat = TextEditingController();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  bool obsText1 = true;
  bool obsText2 = true;
  Color key1Color = kTextFieldBorderColor;
  Color key2Color = kTextFieldBorderColor;
  Color phoneColor = kTextFieldBorderColor;
  Color nameIconColor = kTextFieldBorderColor;
  Color lastNameIconColor = kTextFieldBorderColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: const BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/backgroundwhite.jpg'),
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.07), BlendMode.dstATop),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Container(
            margin:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Header Text
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OrangeHeaderText(
                      text: 'ثبت نام',
                      fontSize: 40.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                //Body Content
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: ListView(
                      children: [
                        //Name & Female
                        Container(
                          padding: const EdgeInsets.only(
                            left: 115,
                            right: 12,
                          ),
                          width: double.infinity,
                          height: kLabelTextContainerHeight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              TextFieldLabel(text: 'نام'),
                              TextFieldLabel(text: 'نام خوانوادگی'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 70.0,
                          width: double.infinity,
                          // color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 150,
                                height: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    // vertical: 2.0,
                                    horizontal: 5.0,
                                  ),
                                  child: TextField(
                                    textInputAction: TextInputAction.next,
                                    cursorColor: kButtonOrangeColor,
                                    controller: _controllerName,
                                    onChanged: (String? value) {
                                      setState(() {
                                        value != null
                                            ? nameIconColor = kButtonOrangeColor
                                            : nameIconColor =
                                                kTextFieldBorderColor;
                                      });
                                    },
                                    decoration: textFieldDecorations(
                                      suffixIcon: Container(
                                        margin: const EdgeInsets.all(13.0),
                                        child: ImageIcon(
                                          const AssetImage(
                                            'images/Icons/userIcon.png',
                                          ),
                                          color: nameIconColor,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 220.0,
                                height: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      // vertical: 2.0,
                                      horizontal: 10.0),
                                  child: TextField(
                                      textInputAction: TextInputAction.next,
                                      cursorColor: kButtonOrangeColor,
                                      controller: _controllerLastName,
                                      onChanged: (String? value) {
                                        setState(() {
                                          value != null
                                              ? lastNameIconColor =
                                                  kButtonOrangeColor
                                              : lastNameIconColor =
                                                  kTextFieldBorderColor;
                                        });
                                      },
                                      decoration: textFieldDecorations(
                                        suffixIcon: Container(
                                          margin: const EdgeInsets.all(13.0),
                                          child: ImageIcon(
                                            const AssetImage(
                                              'images/Icons/userIcon.png',
                                            ),
                                            color: lastNameIconColor,
                                            size: 20,
                                          ),
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        // Phone Number
                        Container(
                          padding: const EdgeInsets.only(
                            left: 115,
                            right: 12,
                          ),
                          width: double.infinity,
                          height: kLabelTextContainerHeight,
                          child: const TextFieldLabel(text: 'شماره موبایل'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              controller: _controllerPhoneNumber,
                              cursorColor: kButtonOrangeColor,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              onChanged: (String? value) {
                                setState(() {
                                  value != null
                                      ? phoneColor = kButtonOrangeColor
                                      : phoneColor = kTextFieldBorderColor;
                                });
                              },
                              decoration: textFieldDecorations(
                                suffixIcon: Container(
                                  margin: const EdgeInsets.all(10.0),
                                  child: ImageIcon(
                                    const AssetImage(
                                      'images/Icons/phoneIcon.png',
                                    ),
                                    color: phoneColor,
                                    size: 10,
                                  ),
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        //PassWord
                        Container(
                          padding: const EdgeInsets.only(
                            left: 115,
                            right: 12,
                          ),
                          width: double.infinity,
                          height: kLabelTextContainerHeight,
                          child: const TextFieldLabel(text: 'رمز عبور'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                              textInputAction: TextInputAction.next,
                              controller: _controller,
                              cursorColor: kButtonOrangeColor,
                              obscureText: obsText1,
                              obscuringCharacter: '*',
                              textAlign: TextAlign.center,
                              onChanged: (String? value) {
                                setState(() {
                                  value != null
                                      ? key1Color = kButtonOrangeColor
                                      : key1Color = kTextFieldBorderColor;
                                });
                              },
                              decoration: textFieldDecorations(
                                suffixIcon: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      iconSize: 24.0,
                                      icon: Icon(obsText1 == true
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          obsText1 == true
                                              ? obsText1 = false
                                              : obsText1 = true;
                                        });
                                      },
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: ImageIcon(
                                        const AssetImage(
                                          'images/Icons/keyIcon.png',
                                        ),
                                        color: key1Color,
                                        size: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //Password Repeat
                        Container(
                          padding: const EdgeInsets.only(
                            left: 115,
                            right: 12,
                          ),
                          width: double.infinity,
                          height: kLabelTextContainerHeight,
                          child: const TextFieldLabel(text: 'تکرار رمز عبور'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            obscuringCharacter: '*',
                            obscureText: obsText2,
                            textAlign: TextAlign.center,
                            controller: _controllerPassRepeat,
                            onChanged: (String? value) {
                              setState(() {
                                value != null
                                    ? key2Color = kButtonOrangeColor
                                    : key2Color = kTextFieldBorderColor;
                              });
                            },
                            decoration: textFieldDecorations(
                              suffixIcon: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    iconSize: 24.0,
                                    icon: Icon(obsText2 == true
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        obsText2 == true
                                            ? obsText2 = false
                                            : obsText2 = true;
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: ImageIcon(
                                      const AssetImage(
                                        'images/Icons/keyIcon.png',
                                      ),
                                      color: key2Color,
                                      size: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 94,
                        ),
                        //Bottom Button
                        Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                OrangeButton(
                                  text: 'مرحله بعدی',
                                  onPressed: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: Lottie.asset(
                                            'assets/lottieJSON/tick.json',
                                            width: 180,
                                            height: 180),
                                        content: const Text(
                                          'ثبت نام با موفقیت انجام شد',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Dana',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: kButtonOrangeColor,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          OrangeButton(
                                              text: 'اتمام',
                                              onPressed: () {
                                                Navigator.pop(context);
                                              })
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 7.0,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'تمامی حقوق مادی و معنوی مربوط به',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.0,
                                        fontFamily: 'Dana',
                                      ),
                                    ),
                                    Text(
                                      ' اپلیکیشن مسئول فروش میباشد',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.0,
                                        fontFamily: 'Dana',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
