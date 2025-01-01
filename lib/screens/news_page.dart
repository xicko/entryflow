// NewsPage shows news articles and blog posts from ICT Group website, WebView is used
// to show the webpages in full screen, while also removing unnecessary html elements
// like header and footer to allow the user focus on the article. Not just one, but multiple
// articles are fetched from their RSS feed making it possible to browse between them using
// neatly placed buttons at the bottom right of the screen, the user can go to next and
// previous article, with additional buttons to refresh the current page, and share the article(link).

import 'dart:async';
import 'package:entryflow/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:entryflow/theme/colors.dart'; // theme specific colors

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  NewsPageState createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> with TickerProviderStateMixin {
  late WebViewController _controller = WebViewController();

  // empty list
  final List<String> _articleLinks = [];

  // opening 3rd post(same post in the ICT task) in the list at startup
  int _currentIndex = 2;

  @override
  // called at app startup
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    WebViewPlatform.instance;

    _controller = WebViewController()
      // allowing JS for WebView
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    // Running JS script to remove header, footer, scroll up button elements
    // from html after page load
    _controller
        .setNavigationDelegate(NavigationDelegate(onPageFinished: (String url) {
      // final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

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
    _fetchRSSFeed();
  }

  @override
  void dispose() {
    _controller.clearCache();
    super.dispose();
  }

  Future<void> _fetchRSSFeed() async {
    try {
      // fetching from RSS feed to fetch multiple blog/news posts and articles
      final url = 'https://www.ictgroup.mn/feed';
      final response = await http.get(Uri.parse(url));

      // decoding xml document from RSS to find links from item elements to articles/posts if the response is 200 - OK
      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        final items = document.findAllElements('item');
        // adding the items
        setState(() {
          _articleLinks.clear();
          _articleLinks.addAll(
            items.map((item) => item.findElements('link').single.innerText),
          );
        });

        // requests the webview to load current if the list isnt empty
        if (_articleLinks.isNotEmpty) {
          _controller.loadRequest(Uri.parse(_articleLinks[_currentIndex]));
        }
      }
    } catch (e) {
      debugPrint('error $e');
    }
  }

  // refresh current page in webview
  Future<void> _refreshWebView() async {
    try {
      await _controller.reload();
    } catch (e) {
      debugPrint('Error: $e');
    }
    CustomSnackBar(context).show(context, this, 'Refreshed');
  }

  // go to next page in the _currentIndex
  Future<void> _goToNext() async {
    if (_currentIndex < _articleLinks.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _controller.loadRequest(Uri.parse(_articleLinks[_currentIndex]));
    }
    CustomSnackBar(context).show(context, this, 'Next');
  }

  // go to previous page in the _currentIndex
  Future<void> _goToPrev() async {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _controller.loadRequest(Uri.parse(_articleLinks[_currentIndex]));
    }
    CustomSnackBar(context).show(context, this, 'Previous');
  }

  // share current post
  Future<void> _shareCurrentPage() async {
    try {
      final currentUrl = await _controller.currentUrl();
      if (currentUrl != null) {
        Share.share(currentUrl);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    CustomSnackBar(context).show(context, this, 'Sharing...');
  }

  // main widgets part
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller,
          ),

          // buttons positioned to bottom right
          Positioned(
            bottom: 16,
            right: 16,
            // setting opacity for translucency
            child: Opacity(
              opacity: 0.8,
              // line the buttons vertically
              child: Column(
                spacing: 10,
                children: [
                  FloatingActionButton(
                    onPressed: _goToNext,
                    tooltip: 'Next',
                    elevation: 3,
                    foregroundColor:
                        AppColors.nextButtonColor(Theme.of(context).brightness),
                    child: Icon(
                      Icons.arrow_upward_rounded,
                      size: 30,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: _goToPrev,
                    tooltip: 'Previous',
                    elevation: 3,
                    foregroundColor:
                        AppColors.prevButtonColor(Theme.of(context).brightness),
                    child: Icon(
                      Icons.arrow_downward_rounded,
                      size: 30,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: _refreshWebView,
                    tooltip: 'Refresh',
                    elevation: 3,
                    foregroundColor: AppColors.refreshButtonColor(
                        Theme.of(context).brightness),
                    child: Icon(
                      Icons.refresh_rounded,
                      size: 30,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: _shareCurrentPage,
                    tooltip: 'Share',
                    elevation: 3,
                    foregroundColor: AppColors.shareButtonColor(
                        Theme.of(context).brightness),
                    child: Icon(
                      Icons.share_rounded,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
