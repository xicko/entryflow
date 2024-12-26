import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/news_page.dart';

class NewsNav extends StatelessWidget {
  const NewsNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey('news'),
      onGenerateRoute: (settings) {
        return GetPageRoute(
          settings: settings,
          page: () => const NewsPage(),
        );
      },
    );
  }
}
