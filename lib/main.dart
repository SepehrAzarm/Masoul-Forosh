import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:masoukharid/Screens/CategoryScreen/category_first_page.dart';
import 'package:masoukharid/Screens/CategoryScreen/category_second_page.dart';
import 'package:masoukharid/Screens/Employees/add_employee.dart';
import 'package:masoukharid/Screens/Employees/employe_list.dart';
import 'package:masoukharid/Screens/Employees/employee_profile.dart';
import 'package:masoukharid/Screens/News/add_news.dart';
import 'package:masoukharid/Screens/News/news_edit.dart';
import 'package:masoukharid/Screens/News/news_main_page.dart';
import 'package:masoukharid/Screens/Password_Recovery/enter_new_password.dart';
import 'package:masoukharid/Screens/Password_Recovery/input_page.dart';
import 'package:masoukharid/Screens/Password_Recovery/otp_input_page.dart';
import 'package:masoukharid/Screens/Products/add_product.dart';
import 'package:masoukharid/Screens/Products/product_edit.dart';
import 'package:masoukharid/Screens/Products/products_mainpage.dart';
import 'package:masoukharid/Screens/Statistics/factor_screen.dart';
import 'package:masoukharid/Screens/Statistics/factors_list.dart';
import 'package:masoukharid/Screens/Statistics/items_screen.dart';
import 'package:masoukharid/Screens/Statistics/turnover_screen.dart';
import 'package:masoukharid/Screens/account_settings.dart';
import 'package:masoukharid/Screens/get_started_page.dart';
import 'package:masoukharid/Screens/login_page.dart';
import 'package:masoukharid/Screens/otp_verify_screen.dart';
import 'package:masoukharid/Screens/profile_screen.dart';
import 'package:masoukharid/Screens/splash_screen.dart';
import 'package:masoukharid/Screens/support_ticket.dart';

void main() {
  runApp(const MasoulForosh());
}

class MasoulForosh extends StatelessWidget {
  const MasoulForosh({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Masoul Forosh',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale(
          'fa',
        ),
      ],
      initialRoute: SplashScreen.id,
      routes: {
        SupportTicketScreen.id: (context) => const SupportTicketScreen(),
        SellingItemsScreen.id: (context) => const SellingItemsScreen(),
        CategorySecondList.id: (context) => const CategorySecondList(),
        CategoryFirstPage.id: (context) => const CategoryFirstPage(),
        FactorListScreen.id: (context) => const FactorListScreen(),
        ProductsMainPage.id: (context) => const ProductsMainPage(),
        InputNumberPage.id: (context) => const InputNumberPage(),
        AccountSettings.id: (context) => const AccountSettings(),
        EmployeeProfile.id: (context) => const EmployeeProfile(),
        OTPVerifyScreen.id: (context) => const OTPVerifyScreen(),
        AddNewEmployee.id: (context) => const AddNewEmployee(),
        AddProductPage.id: (context) => const AddProductPage(),
        GetStartedPage.id: (context) => const GetStartedPage(),
        TurnOverScreen.id: (context) => const TurnOverScreen(),
        ProfileScreen.id: (context) => const ProfileScreen(),
        SplashScreen.id: (context) => const SplashScreen(),
        FactorScreen.id: (context) => const FactorScreen(),
        OTPInputPage.id: (context) => const OTPInputPage(),
        EnterNewPass.id: (context) => const EnterNewPass(),
        EmployeeList.id: (context) => const EmployeeList(),
        NewsMainPage.id: (context) => const NewsMainPage(),
        AddNewsPage.id: (context) => const AddNewsPage(),
        ProductEdit.id: (context) => const ProductEdit(),
        LoginPage.id: (context) => const LoginPage(),
        NewsEdit.id: (context) => const NewsEdit(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
