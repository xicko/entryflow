// base screen used for navigation bar, obx listens for changes
// in the BaseController, IndexedStack displays different screens
// based on the index of currentIndex which is changed by BottomNavBar

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:entryflow/navs/home_nav.dart';
import 'package:entryflow/navs/news_nav.dart';
import '/base_controller.dart';
import '../navigationbar.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: BaseController.to.currentIndex.value,
            children: const [
              HomeNav(),
              NewsNav(),
            ],
          )),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}