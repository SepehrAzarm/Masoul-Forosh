import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:masoul_kharid/Screens/CategoryScreen/category_first_page.dart';
import 'package:masoul_kharid/Screens/CategoryScreen/category_second_page.dart';
import 'package:masoul_kharid/Screens/Employees/add_employee.dart';
import 'package:masoul_kharid/Screens/Employees/employe_list.dart';
import 'package:masoul_kharid/Screens/Employees/employee_lists.dart';
import 'package:masoul_kharid/Screens/Employees/employee_profile.dart';
import 'package:masoul_kharid/Screens/News/add_news.dart';
import 'package:masoul_kharid/Screens/News/news_edit.dart';
import 'package:masoul_kharid/Screens/News/news_main_page.dart';
import 'package:masoul_kharid/Screens/Orders/order_delivery.dart';
import 'package:masoul_kharid/Screens/Orders/order_screen.dart';
import 'package:masoul_kharid/Screens/Orders/orders_list.dart';
import 'package:masoul_kharid/Screens/Password_Recovery/enter_new_password.dart';
import 'package:masoul_kharid/Screens/Password_Recovery/input_page.dart';
import 'package:masoul_kharid/Screens/Password_Recovery/otp_input_page.dart';
import 'package:masoul_kharid/Screens/Products/add_product.dart';
import 'package:masoul_kharid/Screens/Products/product_edit.dart';
import 'package:masoul_kharid/Screens/Products/products_mainpage.dart';
import 'package:masoul_kharid/Screens/Statistics/factor_screen.dart';
import 'package:masoul_kharid/Screens/Statistics/factors_list.dart';
import 'package:masoul_kharid/Screens/Statistics/items_screen.dart';
import 'package:masoul_kharid/Screens/Statistics/turnover_screen.dart';
import 'package:masoul_kharid/Screens/Ticket/chat_screen.dart';
import 'package:masoul_kharid/Screens/Ticket/tickets_list.dart';
import 'package:masoul_kharid/Screens/Wallet/wallet_screen.dart';
import 'package:masoul_kharid/Screens/account_settings.dart';
import 'package:masoul_kharid/Screens/get_started_page.dart';
import 'package:masoul_kharid/Screens/login_page.dart';
import 'package:masoul_kharid/Screens/otp_verify_screen.dart';
import 'package:masoul_kharid/Screens/profile_screen.dart';
import 'package:masoul_kharid/Screens/splash_screen.dart';
import 'package:masoul_kharid/Screens/Ticket/support_ticket.dart';
import 'package:masoul_kharid/Screens/terms_and_conditions.dart';

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
        OrdersDeliveryConfirmation.id: (context) =>
            const OrdersDeliveryConfirmation(),
        TermsAndConditionsScreen.id: (context) =>
            const TermsAndConditionsScreen(),
        SupportTicketScreen.id: (context) => const SupportTicketScreen(),
        SellingItemsScreen.id: (context) => const SellingItemsScreen(),
        CategorySecondList.id: (context) => const CategorySecondList(),
        CategoryFirstPage.id: (context) => const CategoryFirstPage(),
        OrderDetailScreen.id: (context) => const OrderDetailScreen(),
        FactorListScreen.id: (context) => const FactorListScreen(),
        TicketChatScreen.id: (context) => const TicketChatScreen(),
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
        EmployeeLists.id: (context) => const EmployeeLists(),
        SplashScreen.id: (context) => const SplashScreen(),
        FactorScreen.id: (context) => const FactorScreen(),
        OTPInputPage.id: (context) => const OTPInputPage(),
        EnterNewPass.id: (context) => const EnterNewPass(),
        EmployeeList.id: (context) => const EmployeeList(),
        NewsMainPage.id: (context) => const NewsMainPage(),
        WalletScreen.id: (context) => const WalletScreen(),
        TicketsList.id: (context) => const TicketsList(),
        AddNewsPage.id: (context) => const AddNewsPage(),
        ProductEdit.id: (context) => const ProductEdit(),
        OrdersList.id: (context) => const OrdersList(),
        LoginPage.id: (context) => const LoginPage(),
        NewsEdit.id: (context) => const NewsEdit(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
