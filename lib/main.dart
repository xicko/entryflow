// App ner: EntryFlow
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
import 'theme/theme.dart';

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
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
