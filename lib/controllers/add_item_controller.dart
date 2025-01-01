import 'dart:convert';
import 'package:entryflow/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:entryflow/models/item.dart';

class AddItemController extends GetxController {
  // The key for the list view animation
  final GlobalKey<AnimatedListState> listKey;

  AddItemController(this.listKey);

  // Function to fetch and add a new item
  Future<void> addNewItem() async {
    if (BaseController.to.isLoading.value) {
      return;
    }

    BaseController.to.isLoading.value = true;

    try {
      // fetch one item instead of 10
      final response = await http.get(
        Uri.parse(
            'https://67062875031fd46a83122a52.mockapi.io/api/v1/news?page=${BaseController.to.fetchPage.value}&limit=1&title=${BaseController.to.searchQuery.value}'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData.isNotEmpty) {
          final item = Item.fromJson(jsonData[0]);

          BaseController.to.items.insert(0, item);

          // trigger the insertion animation for the new item at index 0
          listKey.currentState?.insertItem(0); // insert the new item at the top

          // increment the page for the next item
          BaseController.to.fetchPage.value++;
        }
        BaseController.to.isLoading.value = false;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      BaseController.to.isLoading.value = false;
    }
  }
}
