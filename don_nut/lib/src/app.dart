import 'package:don_nut/src/screens/history_detail.dart';
import 'package:don_nut/src/screens/loading_page.dart';
import 'package:don_nut/src/screens/delivery_detail.dart';
import 'package:don_nut/src/screens/location.dart';
import 'package:don_nut/src/screens/main_page.dart';
import 'package:don_nut/src/screens/preparation_detail.dart';
import 'package:don_nut/src/screens/preview_page.dart';
import 'package:don_nut/src/screens/product_info.dart';
import 'screens/recover_password.dart';
import 'screens/register.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Don-Nut',
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => const LoadingPage(),
        "/main": (BuildContext context) => const MainPage(),
        "/product_info": (BuildContext context) => const ProductInfoPage(),
        "/register": (BuildContext context) => const RegisterPage(),
        "/recoverPass": (BuildContext context) => const RecoverPassPage(),
        "/location": (BuildContext context) => const LocationPage(),
        "/preview": (BuildContext context) => const PreviewPage(),
        "/preparation_detail": (BuildContext context) =>
            const PreparationDetail(),
        "/delivery_detail": (BuildContext context) => const DeliveryDetail(),
        "/history_detail": (BuildContext context) => const HistoryDetail(),
      },
    );
  }
}
