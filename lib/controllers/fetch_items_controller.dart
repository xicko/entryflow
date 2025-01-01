import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:entryflow/base_controller.dart';
import 'package:entryflow/theme/colors.dart'; // theme specific colors
import 'package:entryflow/utils/custom_cache_manager.dart'; // custom cache manager
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:entryflow/models/item.dart';
import 'package:intl/intl.dart'; // used intl for converting date to human readable date

class FetchItemsController extends GetxController {
  final GlobalKey<AnimatedListState> listKey;

  FetchItemsController(this.listKey);

  // main method to fetch items from api with page, limit, and title parameters
  Future<void> fetchItems({String title = '', http.Client? client}) async {
    // preventing fetching if already in loading state
    if (BaseController.to.isLoading.value) return;

    // set loading state to true when fetchItems is called(during)
    BaseController.to.isLoading.value = true;

    // if title is provided (user is searching) clear the current visible items
    if (title.isNotEmpty) {
      // removing item with animation
      for (int i = BaseController.to.items.length - 1; i >= 0; i--) {
        listKey.currentState?.removeItem(
          i,
          (context, animation) =>
              buildRemovedItem(context, BaseController.to.items[i], animation),
          duration: const Duration(milliseconds: 300),
        );
      }

      // clear all items
      BaseController.to.items.clear();
      // reset page parameter to 1(default)
      BaseController.to.fetchPage.value = 1;
    }

    try {
      // making http get request to fetch items from api
      final response = await http.get(
        Uri.parse(
          'https://67062875031fd46a83122a52.mockapi.io/api/v1/news?page=${BaseController.to.fetchPage.value}&limit=${BaseController.to.fetchLimit.value}&title=$title',
        ),
      );

      // if response is OK, decode the json response and map the json into List objects
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        final newItems = jsonData.map((json) => Item.fromJson(json)).toList();

        // adding the new items with animation
        for (int i = 0; i < newItems.length; i++) {
          int indexToInsert = BaseController.to.items.length + i;

          if (indexToInsert >= 0 &&
              indexToInsert <= BaseController.to.items.length + i) {
            listKey.currentState?.insertItem(indexToInsert);
          }
        }

        // add the new items to the List, increment page number for the next fetch
        BaseController.to.items.addAll(newItems);
        BaseController.to.fetchPage.value++;
      } else {
        // if response wasn't 200
        throw Exception('Failed to load');
      }
    } catch (e) {
      debugPrint('Error fetching items: $e');
    } finally {
      // setting loading to false after fetching is done
      BaseController.to.isLoading.value = false;
    }
  }

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
              // utils/custom_cache_manager.dart
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

  Widget buildRemovedItem(
      BuildContext context, Item item, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          //color: AppColors.itemCardColor(Theme.of(context).brightness),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: CachedNetworkImage(
              // utils/custom_cache_manager.dart
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
