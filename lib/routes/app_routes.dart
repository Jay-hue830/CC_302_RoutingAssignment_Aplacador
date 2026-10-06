import 'package:flutter/material.dart';
import '../pages/main_screen.dart';
import '../pages/detail_page.dart';

class AppRoutes {
  //represents our route nga main screen
  //AppRoutes.main
  //AppRoutes.details
  static const String main = '/main';
  static const String details = '/details';

  static Map<String, WidgetBuilder> get routes => {
        main: (context) => const MainScreen(),
        details: (context) => const DetailPage(),
      };
    }
