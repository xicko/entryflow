import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart'; // image cache
import 'package:entryflow/base_controller.dart'; // state mngmt
import 'package:entryflow/theme/colors.dart'; // theme specific colors
import 'package:entryflow/utils/custom_cache_manager.dart'; // tusgai cache manager
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:entryflow/models/item.dart';
import 'package:intl/intl.dart'; // on sar udur hun unshihad taatai huvilbart huvirgahad intl ashiglav

class FetchItemsController extends GetxController {
  final GlobalKey<AnimatedListState> listKey;

  FetchItemsController(this.listKey);

  void addNewItem(String title, String imageUrl) {
    // Get current time for createdAt
    DateTime createdAt = DateTime.now();

    // Create the new item
    Item newItem = Item(
      id: UniqueKey().toString(), // Generate a unique id for the new item
      title: title,
      image: imageUrl,
      createdAt: createdAt,
    );

    // Add the item to the local list
    BaseController.to.items.insert(0, newItem); // Insert at the top

    // Insert the item into the AnimatedList with an animation
    listKey.currentState?.insertItem(0);

    // Optional: Call your API to store the new item (if needed)
  }

  // main method to fetch items from api with page, limit, and title parameters
  // api-s page/limit/title parameteruud ashiglaj jagsaaltnii item duudah gol method
  Future<void> fetchItems({String title = '', http.Client? client}) async {
    // spam hiigdsen uyd olon tatagdahaas sergiileh
    if (BaseController.to.isLoading.value) return;

    // fetchItems duudagdaj bh hugatsaand isLoading state true
    BaseController.to.isLoading.value = true;

    // search hiij ehlesn uyd odoogiin haragdaj bga jagsaaltiig hoosloh
    if (title.isNotEmpty) {
      // jagsaaltaas item hasagdah animation
      for (int i = BaseController.to.items.length - 1; i >= 0; i--) {
        listKey.currentState?.removeItem(
          i,
          (context, animation) =>
              buildRemovedItem(context, BaseController.to.items[i], animation),
          duration: const Duration(milliseconds: 300),
        );
      }

      // jagsaaltiig buren hoosloj
      BaseController.to.items.clear();
      // page parameteriig 1 ruu butsaav
      BaseController.to.fetchPage.value = 1;
    }

    try {
      // http handalt hiij api-s json itemuud tatav
      final response = await http.get(
        Uri.parse(
          'https://67062875031fd46a83122a52.mockapi.io/api/v1/news?page=${BaseController.to.fetchPage.value}&limit=${BaseController.to.fetchLimit.value}&title=$title',
        ),
      );

      // http request amjilttai bolson bol tatsan json-g dart data bolgoj decode hiij, Item(dart object) map hiij jagsaav
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        final newItems = jsonData.map((json) => Item.fromJson(json)).toList();

        // jagsaaltad item nemegdeh animation
        for (int i = 0; i < newItems.length; i++) {
          int indexToInsert = BaseController.to.items.length + i;

          if (indexToInsert >= 0 &&
              indexToInsert <= BaseController.to.items.length + i) {
            listKey.currentState?.insertItem(indexToInsert);
          }
        }

        // jagsaaltiin UI-d newItems nemj, daraagiin tataltad zoriulj page param negeer nemev
        BaseController.to.items.addAll(newItems);
        BaseController.to.fetchPage.value++;
      } else {
        // if response wasn't 200
        throw Exception('Failed to load');
      }
    } catch (e) {
      debugPrint('Error fetching: $e');
    } finally {
      // isLoading state-g item tatalt duussanii daraa false
      BaseController.to.isLoading.value = false;
    }
  }

  // jagsaaltah nemegdeh item UI
  Widget buildListItem(
      BuildContext context, Item item, Animation<double> animation, int index) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          color: AppColors.itemCardColor(Theme.of(context).brightness),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: CachedNetworkImage(
              // utils/custom_cache_manager.dart zurag cache
              cacheManager: CustomCacheManager.getInstance(),
              imageUrl: item.image,
              width: 100,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                  child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                  child: Icon(Icons.error)),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              item.title,
              style: TextStyle(
                  color: AppColors.itemTitleTextColor(
                      Theme.of(context).brightness)),
            ),
            subtitle: Text(
              'Created at: ${DateFormat.yMMMMd().format(item.createdAt)}',
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.itemSubtitleTextColor(
                      Theme.of(context).brightness)),
            ),
          ),
        ),
      ),
    );
  }

  // jagsaaltah hasagdah item UI
  Widget buildRemovedItem(
      BuildContext context, Item item, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          color: AppColors.itemCardColor(Theme.of(context).brightness),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: CachedNetworkImage(
              // utils/custom_cache_manager.dart zurag cache
              cacheManager: CustomCacheManager.getInstance(),
              imageUrl: item.image,
              width: 100,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                  child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                  child: Icon(Icons.error)),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              item.title,
              style: TextStyle(
                  color: AppColors.itemTitleTextColor(
                      Theme.of(context).brightness)),
            ),
            subtitle: Text(
              'Created at: ${DateFormat.yMMMMd().format(item.createdAt)}',
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.itemSubtitleTextColor(
                      Theme.of(context).brightness)),
            ),
          ),
        ),
      ),
    );
  }
}
