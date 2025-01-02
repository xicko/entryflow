// State management Getx ashiglav

import 'package:entryflow/controllers/add_item_controller.dart';
import 'package:entryflow/controllers/fetch_items_controller.dart';
import 'package:entryflow/widgets/simple_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entryflow/models/item.dart';

class BaseController extends GetxController {
  static BaseController get to => Get.find();

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // observable variables
  var currentNavIndex = 0.obs;
  RxBool isCustomSnackBarVisible =
      false.obs; // CustomSnackBar haragdaj bga eseh
  RxInt fetchPage = 1.obs; // ehleld page 1-s tatah/fetch
  RxInt fetchLimit = 10.obs; // fetch limited to 10 items by default
  RxString searchQuery = ''.obs; // default search param
  RxBool isLoading = false.obs; // is List loading
  RxBool isSearchMode = false.obs; // hereglegch yag odoo haij bag eseh flag
  RxInt currentPostIndex =
      2.obs; // webview rss feed-d bui 3dah postoor ehlene(dasgald zaasan medee)

  // fetch hiisnii daraa duurne
  final _items = <Item>[].obs; // hooson item list
  final _articleLinks = <String>[].obs; // hooson medeenii list

  List<Item> get items => _items;
  List<String> get articleLinks => _articleLinks;

  // navbar index solih method
  void changePage(int index) {
    currentNavIndex.value = index;
  }

  // METHODS FOR LIST
  // list-d neg item nemeh
  void addAnItem(BuildContext context) {
    if (!BaseController.to.isLoading.value) {
      final addItemController = Get.find<AddItemController>();
      addItemController.addNewItem();
      SimpleSnackBar(context).show('Adding...');
    }
  }

  // list-s neg item hasah
  void deleteAnItem(BuildContext context) {
    final fetchItemsController = FetchItemsController(listKey);
    if (BaseController.to.items.isNotEmpty) {
      // listiin ehnii item-g avah
      final item = BaseController.to.items[0];

      // listiin ehnees hasah(index 0)
      BaseController.to.items.removeAt(0);

      // hasaltiig UI deere animation ashiglaj haruulah
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
    // haih tovch daragdahad SearchMode asaaj, odoo bui buh item-g jagsaaltaas hasch, page parameteriig 1 ruu butsaav
    BaseController.to.isSearchMode.value = true;
    BaseController.to.items.clear();
    BaseController.to.fetchPage.value = 1;

    // hailtiin inputees zaig(whitespace) hasch title parameterd ashiglah
    final fetchItemsController = Get.put(FetchItemsController(listKey));
    fetchItemsController.fetchItems(title: searchController.text.trim());

    SimpleSnackBar(context).show('Searching...');
  }

  // list refresh hiih
  void refreshList(BuildContext context) {
    final fetchItemsController = FetchItemsController(listKey);

    SimpleSnackBar(context).show('Refreshing...');

    // refresh hiisen uyd SearchMode untraaj, search input-g hoosloh
    BaseController.to.isSearchMode.value = false;
    BaseController.to.searchController.clear();

    // AnimatedList jagsaaltaas animationtoi hasah (UI)
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

    // animation duussanii daraa jagsaaltaas item hasah
    Future.delayed(const Duration(milliseconds: 300), () {
      BaseController.to.items.clear();
      BaseController.to.fetchPage.value = 1;

      // dahin 10 item tataj haruulah
      final fetchItemsController = Get.put(FetchItemsController(listKey));
      fetchItemsController.fetchItems();
    });
  }

  // jagsaaltiin hamgiin doosh hurtel tohioldold daraagiin 10 item tataj haruulah
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
