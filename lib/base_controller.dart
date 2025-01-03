// State management Getx ashiglav

import 'package:entryflow/controllers/add_item_controller.dart';
import 'package:entryflow/controllers/fetch_items_controller.dart';
import 'package:entryflow/widgets/simple_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entryflow/models/item.dart';
import 'package:url_launcher/url_launcher.dart';

class BaseController extends GetxController {
  // getx controller heregleh
  static BaseController get to => Get.find();

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

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
  RxBool isAboutMeModalVisible = false.obs;

  RxBool isAddItemModalVisible = false.obs;
  RxBool addItemModalAnim = false.obs;

  // fetch hiisnii daraa duurne
  final _items = <Item>[].obs; // hooson item list
  final _articleLinks = <String>[].obs; // hooson medeenii list

  List<Item> get items => _items;
  List<String> get articleLinks => _articleLinks;

  // buh modal neg dor haah
  void closeModals() {
    BaseController.to.isAboutMeModalVisible.value = false;
    BaseController.to.isAddItemModalVisible.value = false;
  }

  // navbar index solih method
  void changePage(int index) {
    currentNavIndex.value = index;
    closeModals();
  }

  // url link neeh method
  Future<void> linkNeeh(String url) async {
    final Uri link = Uri.parse(url);
    if (!await launchUrl(link)) {
      throw Exception('Could not launch $url');
    }
  }

  // aboutme modal neeh/haah
  void toggleAboutMeModal() {
    isAboutMeModalVisible.value = !isAboutMeModalVisible.value;

    if (isAboutMeModalVisible.value) {
      BaseController.to.isAddItemModalVisible.value = false;
    }
  }

  // additem modal neeh/haah
  void toggleAddItemModal() {
    if (addItemModalAnim.value) {
      // fade out hiih animation ehluuleh
      addItemModalAnim.value = false;

      // modaliin visibility-g animation buren duussanii daraa haah
      Future.delayed(Duration(milliseconds: 300), () {
        isAddItemModalVisible.value = false;
      });
    } else {
      // fade in hiih animation ehluuleh
      isAddItemModalVisible.value = true;

      // modaliin visibility-g animation buren duussanii daraa neeh
      Future.delayed(Duration(milliseconds: 200), () {
        addItemModalAnim.value = true;
      });
    }
  }

  // METHODS FOR LIST

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
    closeModals();
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
    closeModals();
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
    closeModals();
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
