import 'dart:convert';
import 'package:entryflow/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:entryflow/models/item.dart';

class AddItemController extends GetxController {
  // key for the list view animation
  final GlobalKey<AnimatedListState> listKey;

  AddItemController(this.listKey);

  // api-s zuvhun neg item tatah
  Future<void> addNewItem() async {
    // spam hiigdsen uyd olon tatagdahaas sergiileh
    if (BaseController.to.isLoading.value) return;

    // addNewItem duudagdaj bh hugatsaand isLoading state true
    BaseController.to.isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(
            'https://67062875031fd46a83122a52.mockapi.io/api/v1/news?page=${BaseController.to.fetchPage.value}&limit=1&title=${BaseController.to.searchQuery.value}'),
      );

      // http request amjilttai bolson bol tatsan json-g dart data bolgoj decode hiij, Item(dart object) map hiij jagsaav
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData.isNotEmpty) {
          final item = Item.fromJson(jsonData[0]);

          BaseController.to.items.insert(0, item);

          // item index 0 buyu jagsaaltiin ehend nemne
          listKey.currentState?.insertItem(0);

          // daraagiin tataltad zoriulj page param negeer nemev
          BaseController.to.fetchPage.value++;
        }
        BaseController.to.isLoading.value = false;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      // isLoading state-g item tatalt duussanii daraa false
      BaseController.to.isLoading.value = false;
    }
  }
}
