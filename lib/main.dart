// App Name: EntryFlow
// App icon/logo is a list document icon with gradient added, from: https://www.flaticon.com/free-icon/list-document-interface-symbol_36063
// Main color scheme used in the app: Hex #7E577F - Dark Pastel Pink, Hex #124870 - Dark Pastel Blue, #FFFFFF White, #262626 Dark Gray
// Font family used: Montserrat
// Followed minimalistic, clean design

// main.dart ==> base_screen.dart ==> screens/home_page.dart

import 'package:flutter/material.dart';
import 'base_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:entryflow/base_controller.dart';

void main() {
  Get.put<BaseController>(BaseController());
  // screen orientation portrait/vertical
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const BaseScreen(),
      theme: ThemeData(
        primaryColor: Color(0xFF124870),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // grey 100
        fontFamily: 'Montserrat',

        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Color.fromARGB(255, 38, 38, 38),
        ),

        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Color.fromARGB(255, 38, 38, 38),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          splashColor: Color.fromARGB(255, 213, 213, 213),
        ),

        listTileTheme: ListTileThemeData(
          titleTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          subtitleTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            color: Colors.black,
          )
        ),

        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.white,
          contentTextStyle: TextStyle(color: Color.fromARGB(255, 38, 38, 38)),
        ),

        dropdownMenuTheme: DropdownMenuThemeData(
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.all(Colors.white),
          ),
        ),
      ),
    );
  }
}