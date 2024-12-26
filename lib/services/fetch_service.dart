import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';

Future<List<Item>> fetchItems() async {
  // fetching from api
  final response = await http.get(
    Uri.parse('https://67062875031fd46a83122a52.mockapi.io/api/v1/news?page=1&limit=10'),
  );

  // decodes data and maps to objects if response is 200 (OK)
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((json) => Item.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load');
  }
}