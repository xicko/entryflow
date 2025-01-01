import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entryflow/base_controller.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => NavigationBar(
          // height: 120,
          // animationDuration: Duration(seconds: 2),
          selectedIndex: BaseController.to.currentNavIndex.value,
          onDestinationSelected: (index) => BaseController.to.changePage(index),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(
                Icons.home,
                color: Theme.of(context)
                    .bottomNavigationBarTheme
                    .selectedItemColor,
              ),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.newspaper_rounded),
              selectedIcon: Icon(
                Icons.newspaper_rounded,
                color: Theme.of(context)
                    .bottomNavigationBarTheme
                    .selectedItemColor,
              ),
              label: 'News',
            ),
          ],
        ));
  }
}
