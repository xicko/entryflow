import 'package:entryflow/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

class RSSFeedController extends GetxController {
  final webViewController = Get.find<WebViewController>();
  final String rssUrl;

  RSSFeedController(this.rssUrl);

  Future<void> fetchRSSFeed() async {
    try {
      // fetching from RSS feed to fetch multiple blog/news posts and articles
      final response = await http.get(Uri.parse(rssUrl));

      // decoding xml document from RSS to find links from item elements to articles/posts if the response is 200 - OK
      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        final items = document.findAllElements('item');
        // adding the items
        BaseController.to.articleLinks.clear();
        BaseController.to.articleLinks.addAll(
          items.map((item) => item.findElements('link').single.innerText),
        );

        // requests the webview to load current if the list isnt empty
        if (BaseController.to.articleLinks.isNotEmpty) {
          webViewController.loadRequest(Uri.parse(BaseController
              .to.articleLinks[BaseController.to.currentPostIndex.value]));
        }
      }
    } catch (e) {
      debugPrint('error $e');
    }
  }
}
