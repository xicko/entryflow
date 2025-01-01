// Using GetX state management

import 'package:entryflow/controllers/add_item_controller.dart';
import 'package:entryflow/controllers/fetch_items_controller.dart';
import 'package:entryflow/widgets/simple_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entryflow/models/item.dart';

class BaseController extends GetxController {
  static BaseController get to => Get.find();

  // obs makes the variable observable, allowing UI to react to changes
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  var currentNavIndex = 0.obs;
  RxBool isCustomSnackBarVisible = false.obs;
  RxInt fetchPage = 1.obs; // fetch from page 1 by default
  RxInt fetchLimit = 10.obs; // fetch limited to 10 items by default
  RxString searchQuery = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isSearchMode =
      false.obs; // flag to track if user is currently searching
  final _items = <Item>[].obs;

  List<Item> get items => _items;

  // method to change the current navbar index
  void changePage(int index) {
    currentNavIndex.value = index;
  }

  // METHODS FOR LIST
  // add 1 item in list
  void addAnItem(BuildContext context) {
    if (!BaseController.to.isLoading.value) {
      final addItemController = Get.find<AddItemController>();
      addItemController.addNewItem();
      SimpleSnackBar(context).show('Adding...');
    }
  }

  // delete 1 item
  void deleteAnItem(BuildContext context) {
    final fetchItemsController = FetchItemsController(listKey);
    if (BaseController.to.items.isNotEmpty) {
      // get the first item from list
      final item = BaseController.to.items[0];

      // remove from index 0
      BaseController.to.items.removeAt(0);

      // animate the deletion
      listKey.currentState?.removeItem(
        0,
        (context, animation) =>
            fetchItemsController.buildRemovedItem(context, item, animation),
        duration: const Duration(milliseconds: 300),
      );
    }
    SimpleSnackBar(context).show('Removed');
  }

  // search button
  void performSearch(BuildContext context) {
    // turn on searchmode, clear current items, and set page to 1(default) when search button is clicked
    BaseController.to.isSearchMode.value = true;
    BaseController.to.items.clear();
    BaseController.to.fetchPage.value = 1;
    // fetching items with unnecessary whitespace removed for search
    final fetchItemsController = Get.put(FetchItemsController(listKey));
    fetchItemsController.fetchItems(title: searchController.text.trim());

    SimpleSnackBar(context).show('Searching...');
  }

  // refresh list
  void refreshList(BuildContext context) {
    final fetchItemsController = FetchItemsController(listKey);

    SimpleSnackBar(context).show('Refreshing...');

    // disable search mode, clear search input when refreshed
    BaseController.to.isSearchMode.value = false;

    BaseController.to.searchController.clear();

    // remove items from AnimatedList with animations
    final int itemCount = BaseController.to.items.length;
    for (int i = itemCount - 1; i >= 0; i--) {
      final removedItem = BaseController.to.items[i];
      listKey.currentState?.removeItem(
        i,
        (context, animation) => fetchItemsController.buildRemovedItem(
            context, removedItem, animation),
        duration: const Duration(milliseconds: 300),
      );
    }

    // clear the items list after animations
    Future.delayed(const Duration(milliseconds: 300), () {
      BaseController.to.items.clear();
      BaseController.to.fetchPage.value = 1;

      // fetch 10 items
      final fetchItemsController = Get.put(FetchItemsController(listKey));
      fetchItemsController.fetchItems();
    });
  }

  // fetches 10 more items if user scrolled to the bottom
  void scrollListener(BuildContext context) {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!BaseController.to.isLoading.value &&
          !BaseController.to.isSearchMode.value) {
        final fetchItemsController = Get.put(FetchItemsController(listKey));
        fetchItemsController.fetchItems();
        SimpleSnackBar(context).show('Loading...');
      }
    }
  }
}
