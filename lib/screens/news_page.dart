// NewsPage n ICT Group-n website-s medee bolon blog postuudiig webview ashiglan haruulna.
// Website-iin RSS Feed-g unshij neg bish olon medeenii hoorond shiljij harah bolomjtoi.
// Delgetsiin baruun dood buland daraagiin bolon umnuh medeeruu shiljih tovch, mun odoo bui
// page-g refresh hiih, linkiig n share hiih niit 4 tovchtoi.

import 'package:entryflow/controllers/rss_feed_controller.dart'; // main rss fetch method
import 'package:entryflow/utils/webview_helper.dart'; // controls methods for webview
import 'package:entryflow/widgets/webview_buttons.dart'; // UI for buttons
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:entryflow/theme/colors.dart'; // theme specific colors

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  NewsPageState createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> with TickerProviderStateMixin {
  late WebViewController _controller = WebViewController();
  late RSSFeedController rssFeedController;
  late WebViewHelper webViewHelper;

  @override
  // app ehend unshih functionuud
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    WebViewPlatform.instance;

    _controller = WebViewController()
      // webview-d javascript ajillahiig zuvshuuruv
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    // webview page unshsanii daraa <header>, <footer> -g html ees hasah js script unshuulna
    // hereglegchid ochihdoo header bolon footer buren hasagdaj ochno
    _controller
        .setNavigationDelegate(NavigationDelegate(onPageFinished: (String url) {
      _controller.runJavaScript('''
            var header = document.querySelector('header');
            if (header) {
              header.remove();
            }

            var footer = document.querySelector('footer');
            if (footer) {
              footer.remove();
            }

            var scrollUp = document.querySelector('div.ict-scroll-up');
            if (scrollUp) {
              scrollUp.remove();
            }

            
          ''');
    }));
    Get.put(_controller);
    // fetch hiih url
    rssFeedController =
        Get.put(RSSFeedController('https://www.ictgroup.mn/feed'));
    rssFeedController.fetchRSSFeed();
    webViewHelper = WebViewHelper(context, _controller);
  }

  @override
  void dispose() {
    _controller.clearCache();
    super.dispose();
  }

  // MAIN UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // WebView
          WebViewWidget(
            controller: _controller,
          ),

          // WebView Control Buttons
          Positioned(
            bottom: 16,
            right: 16,
            child: WebviewButtons(webViewHelper: webViewHelper),
          ),
        ],
      ),
    );
  }
}
