import 'package:entryflow/base_controller.dart';
import 'package:entryflow/widgets/simple_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entryflow/models/item.dart';

class AddItemController extends GetxController {
  // getx controller heregleh
  static AddItemController get to => Get.find();

  // key for the list view animation
  final GlobalKey<AnimatedListState> listKey;

  AddItemController(this.listKey);

  void addNewItem(BuildContext context, String title, String imageUrl) {
    // odoo bga tsagaar avah
    DateTime createdAt = DateTime.now();

    // shine item class
    Item newItem = Item(
      // shine item burt widget dotroo l amidrah ID onooj ugnu
      id: UniqueKey().toString(),
      title: title,
      image: imageUrl,
      createdAt: createdAt,
    );

    // Add the item to the local list
    BaseController.to.items.insert(0, newItem); // Insert at the top

    // jagsaaltiin ehend nemeh
    listKey.currentState?.insertItem(0);

    SimpleSnackBar(context).show('Adding...');
    BaseController.to.closeModals();
  }
}
