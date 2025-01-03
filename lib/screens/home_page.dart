// HomePage n api-s tatagdsan itemuudiig jagsaaj haruulah gol screen bolno. Jagsaalt n itemuudiig
// zurag, garchig bolon nemegdsen on sar udurtei n tseverhen animationtoi haruulna, mun jagsaaltaas
// shuult hiij, haih, item nemj hasah bolomjtoi. Itemuudiin zurguud cache hiigdej 7 honog hadgalagdana.

import 'package:entryflow/base_controller.dart';
import 'package:entryflow/controllers/add_item_controller.dart';
import 'package:entryflow/controllers/fetch_items_controller.dart';
import 'package:entryflow/theme/colors.dart';
import 'package:entryflow/widgets/aboutme_modal.dart';
import 'package:entryflow/widgets/additem_modal.dart';
import 'package:entryflow/widgets/list_manage_buttons.dart';
import 'package:entryflow/widgets/list_search.dart';
import 'package:entryflow/widgets/logo_with_title.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final http.Client? httpClient;
  HomePage({super.key, http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // BaseController listKey variable-g ene page-d ashiglah local variable listKey-d zalgav
  final GlobalKey<AnimatedListState> listKey = BaseController.to.listKey;

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  // app ehend unshih functionuud
  Future<void> initializeApp() async {
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

  // MAIN UI
  @override
  Widget build(BuildContext context) {
    // Hereglegchiin utasnii height-g huviar avah
    double screenHeight = MediaQuery.of(context).size.height;

    // DarkMode assan uyd zarim UI elementuudiig uurchluhud ashiglah flag
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    final addItemController = Get.put(AddItemController(listKey));
    final fetchItemsController = Get.put(FetchItemsController(listKey));

    return Scaffold(
        body: Stack(
      children: [
        // Main Content UI
        Center(
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

                // Main List UI
                Expanded(
                    child: Obx(
                  () => AnimatedList(
                      // list-d vertical padding nemev
                      padding: EdgeInsets.only(bottom: 60, top: 6),
                      key: listKey,
                      controller: BaseController.to.scrollController,
                      initialItemCount: BaseController.to.items.length,
                      itemBuilder: (context, index, animation) {
                        if (index >= BaseController.to.items.length) {
                          // index baihgui bol hooson SizedBox
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

        // About Me Modal
        Obx(
          () => AnimatedPositioned(
            duration: Duration(milliseconds: 450),
            curve: Curves.easeInOutQuad,
            bottom: BaseController.to.isAboutMeModalVisible.value ? 0 : -200,
            right: 0,
            left: 0,
            child: AboutMeModal(),
          ),
        ),

        // Add Item Modal
        Positioned(child: AddItemModal())
      ],
    ));
  }
}
