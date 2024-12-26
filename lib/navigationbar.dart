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
          selectedIndex: BaseController.to.currentIndex.value,
          onDestinationSelected: (index) => BaseController.to.changePage(index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.newspaper_rounded),
              selectedIcon: Icon(
                Icons.newspaper_rounded,
                color: Colors.white,
              ),
              label: 'News',
            ),
          ],
        ));
  }
}
