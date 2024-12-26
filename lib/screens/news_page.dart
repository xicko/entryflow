// NewsPage shows news articles and blog posts from ICT Group website, WebView is used
// to show the webpages in full screen, while also removing unnecessary html elements
// like header and footer to allow the user focus on the article. Not just one, but multiple
// articles are fetched from their RSS feed making it possible to browse between them using
// neatly placed buttons at the bottom right of the screen, the user can go to next and
// previous article, with additional buttons to refresh the current page, and share the article(link).

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  NewsPageState createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> with AutomaticKeepAliveClientMixin {
  bool _isSnackBarVisible = false; // flag to track snackbar is currently active
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
    _controller.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (String url) {
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
        }
      )
    );
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
    _showCustomSnackBar(context, 'Refreshed');
  }

  // go to next page in the _currentIndex
  Future<void> _goToNext() async {
    if (_currentIndex < _articleLinks.length -1 ) {
      setState(() {
        _currentIndex++;
      });
      _controller.loadRequest(Uri.parse(_articleLinks[_currentIndex]));
    }
    _showCustomSnackBar(context, 'Next');
  }

  // go to previous page in the _currentIndex
  Future<void> _goToPrev() async {
    if (_currentIndex > 0 ) {
      setState(() {
        _currentIndex--;
      });
      _controller.loadRequest(Uri.parse(_articleLinks[_currentIndex]));
    }
    _showCustomSnackBar(context, 'Previous');
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
    _showCustomSnackBar(context, 'Sharing...');
  }

  // custom snackbar component for displaying messages below
  void _showCustomSnackBar(BuildContext context, String message) {
    // prevent multiple snackbars being called when spammed
    if (_isSnackBarVisible || !context.mounted) return;

    // snackbar visible while _showCustomSnackBar is called
    _isSnackBarVisible = true;

    final overlay = Overlay.of(context);
    // create animation
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: Scaffold.of(context),
    );

    // set the animation curve effect
    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutExpo,
    );

    // snackbar appearance
    final overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Positioned(
              // using tween to set the beginning and ending position of snackbar anim
              bottom: Tween<double>(begin: -40, end: 12).evaluate(animation),
              left: 140,
              right: 140,
              child: Opacity(
                opacity: 0.9,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        // subtle shadow
                        BoxShadow(
                          color: const Color.fromARGB(26, 0, 0, 0),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        message,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    // inserting overlay entry into overlay to show the snackbar
    overlay.insert(overlayEntry);

    // start anim in forward motion
    animationController.forward();

    // reverse the animation, remove overlayEntry from overlay, and reset snackbar visibility flag after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      animationController.reverse().then((_) {
        overlayEntry.remove(); // removing overlayEntry from Overlay.of(context)
        animationController.dispose(); // dispose anim controller
        _isSnackBarVisible = false; // resetting the flag after the snackbar disappears
      });
    });
  }

  // main widgets part
  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                    foregroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                      Icons.arrow_upward_rounded,
                      size: 30,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: _goToPrev,
                    tooltip: 'Previous',
                    elevation: 3,
                    foregroundColor: Color.fromARGB(255, 97, 66, 98),
                    child: Icon(
                      Icons.arrow_downward_rounded,
                      size: 30,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: _refreshWebView,
                    tooltip: 'Refresh',
                    elevation: 3,
                    foregroundColor: Color.fromARGB(255, 38, 38, 38),
                    child: Icon(
                      Icons.refresh_rounded,
                      size: 30,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: _shareCurrentPage, // Calls the share function
                    tooltip: 'Share',
                    elevation: 3,
                    foregroundColor: Color.fromARGB(255, 38, 38, 38),
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

  @override
  bool get wantKeepAlive => false;
}