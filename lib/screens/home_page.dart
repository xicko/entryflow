// HomePage is the main screen that fetches and displays a list of items
// from a remote API. The page is made to show the articles with their image, title,
// and created date using animated list for smooth item animations. The user can filter the
// results by title and it'll display the matching articles in real-time. The app also supports
// pagination, automatically fetching new items when the user scrolls to the bottom of the list.
// It also has functionality to refresh, add, and delete items. When adding a new item, it appears
// at the top of the list, and when deleting, the first article is removed with an animation.
// A custom cache manager is used for image caching to save resources and reduce data usage.

import 'package:entryflow/base_controller.dart';
import 'package:entryflow/controllers/add_item_controller.dart';
import 'package:entryflow/controllers/fetch_items_controller.dart';
import 'package:entryflow/widgets/list_manage_buttons.dart';
import 'package:entryflow/widgets/list_search.dart';
import 'package:entryflow/widgets/logo_with_title.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:entryflow/theme/colors.dart'; // theme specific colors
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final http.Client? httpClient;
  HomePage({super.key, http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // controllers
  final GlobalKey<AnimatedListState> listKey = BaseController.to.listKey;

  // runs at app start
  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    // fetching items from api
    final fetchItemsController = Get.put(FetchItemsController(listKey));
    fetchItemsController.fetchItems();

    BaseController.to.scrollController.addListener(() {
      BaseController.to.scrollListener(context);
    });
  }

  @override
  void dispose() {
    BaseController.to.scrollController.dispose();
    BaseController.to.searchController.dispose();
    super.dispose();
  }

  // main screen widgets
  @override
  Widget build(BuildContext context) {
    // getting user's device screen height
    double screenHeight = MediaQuery.of(context).size.height;

    // checking if dark mode is on for styling(theme) some widgets
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    final addItemController = Get.put(AddItemController(listKey));
    final fetchItemsController = Get.put(FetchItemsController(listKey));

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.112), // top space

              LogoWithTitle(),

              SizedBox(height: 14), // spacer

              ListManageButtons(),

              SizedBox(height: 10), // spacer

              ListSearch(),

              // main list
              Expanded(
                  child: Obx(
                () => AnimatedList(
                    // bit of padding at the bottom of items
                    padding: EdgeInsets.only(bottom: 60, top: 6),
                    key: listKey,
                    controller: BaseController.to.scrollController,
                    initialItemCount: BaseController.to.items.length,
                    itemBuilder: (context, index, animation) {
                      if (index >= BaseController.to.items.length) {
                        // 0px box if the index is invalid
                        return const SizedBox.shrink();
                      }
                      final item = BaseController.to.items[index];
                      return fetchItemsController.buildListItem(
                          context, item, animation, index);
                    }),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
