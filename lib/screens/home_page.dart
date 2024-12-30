// HomePage is the main screen that fetches and displays a list of items
// from a remote API. The page is made to show the articles with their image, title, 
// and created date using animated list for smooth item animations. The user can filter the
// results by title and it'll display the matching articles in real-time. The app also supports
// pagination, automatically fetching new items when the user scrolls to the bottom of the list.
// It also has functionality to refresh, add, and delete items. When adding a new item, it appears
// at the top of the list, and when deleting, the first article is removed with an animation.
// A custom cache manager is used for image caching to save resources and reduce data usage.

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:entryflow/theme/colors.dart'; // theme specific colors
import 'package:cached_network_image/cached_network_image.dart'; // for caching images
import 'package:intl/intl.dart'; // used intl for converting date to human readable date
import 'package:entryflow/models/item.dart';
import 'package:flutter/material.dart';
import 'package:entryflow/utils/custom_cache_manager.dart'; // custom cache manager

class HomePage extends StatefulWidget {
  final http.Client? httpClient;
  HomePage({super.key, http.Client? httpClient})
    : httpClient = httpClient ?? http.Client();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // default values
  int _page = 1; // fetch from page 1 by default
  bool _isLoading = false; 
  bool _isSearchMode = false; // flag to track if user is currently searching
  bool _isSnackBarVisible = false; // flag to track snackbar is currently active
  final List<Item> _items = [];
  final String _searchQuery = '';
  final int _limit = 10; // fetch limited to 10 items by default
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> _listkey = GlobalKey<AnimatedListState>();

  // runs at app start
  @override
  void initState() {
    super.initState();
    initializeApp();
  }
  Future<void> initializeApp() async {
    // fetching items from api
    fetchItems();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // main method to fetch items from api with page, limit, and title parameters
  Future<void> fetchItems({String title = '', http.Client? client}) async {
    // preventing fetching if already in loading state
    if (_isLoading) return;

    // set loading state to true when fetchItems is called(during)
    setState(() {
      _isLoading = true;
    });

    // if title is provided (user is searching) clear the current visible items
    if (title.isNotEmpty) {
      // removing item with animation
      for (int i = _items.length - 1; i >= 0; i--) {
        _listkey.currentState?.removeItem(
          i,
          (context, animation) => _buildRemovedItem(_items[i], animation),
          duration: const Duration(milliseconds: 300),
        );
      }
      // clear all items
      _items.clear();
      // reset page parameter to 1(default)
      _page = 1;
    }

    try {
      // making http get request to fetch items from api
      final response = await http.get(
        Uri.parse(
          'https://67062875031fd46a83122a52.mockapi.io/api/v1/news?page=$_page&limit=$_limit&title=$title',
        ),
      );

      // if response is OK, decode the json response and map the json into List objects
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        final newItems = jsonData.map((json) => Item.fromJson(json)).toList();

        // adding the new items with animation
        for (int i = 0; i < newItems.length; i++) {
          int indexToInsert = _items.length + i;

          if (indexToInsert >= 0 && indexToInsert <= _items.length + i) {
            _listkey.currentState?.insertItem(indexToInsert);
          }
        }

        // add the new items to the List, increment page number for the next fetch
        setState(() {
          _items.addAll(newItems);
          _page++;
        });
      } else {
        // if response wasn't 200
        throw Exception('Failed to load');
      }
    } catch (e) {
      debugPrint('Error fetching items: $e');
    } finally {
      // setting loading to false after fetching is done
      setState(() {
        _isLoading = false;
      });
    }
  }

  // add new item
  Future<void> addNewItem() async {
    if (_isLoading) {
      //_showSnackBar('Loading...');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // fetch one item instead of 10
      final response = await http.get(
        Uri.parse('https://67062875031fd46a83122a52.mockapi.io/api/v1/news?page=$_page&limit=1&title=$_searchQuery'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData.isNotEmpty) {
          final item = Item.fromJson(jsonData[0]);

          setState(() {
            // insert the new item at the top of the list
            _items.insert(0, item);
          });

          // trigger the insertion animation for the new item at index 0
          _listkey.currentState?.insertItem(0); // insert the new item at the top
          
          // increment the page for the next item
          _page++;
        }
        setState(() {
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // fetches 10 more items if user scrolled to the bottom
  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!_isLoading && !_isSearchMode) {
        fetchItems();
        _showSnackBar('Loading...');
      }
    }
  }

  // search button
  void _performSearch() {
    // turn on searchmode, clear current items, and set page to 1(default) when search button is clicked
    setState(() {
      _isSearchMode = true;
      _items.clear();
      _page = 1;
    });
    // fetching items with unnecessary whitespace removed for search
    fetchItems(title: _searchController.text.trim());

    _showSnackBar('Searching...');
  }

  void _refreshList() {
    _showSnackBar('Refreshing...');

    // disable search mode, clear search input when refreshed
    setState(() {
      _isSearchMode = false;
      _searchController.clear();
    });

    // remove items from AnimatedList with animations
    final int itemCount = _items.length;
    for (int i = itemCount - 1; i >= 0; i--) {
      final removedItem = _items[i];
      _listkey.currentState?.removeItem(
        i,
        (context, animation) => _buildRemovedItem(removedItem, animation),
        duration: const Duration(milliseconds: 300),
      );
    }

    // clear the items list after animations
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _items.clear();
        _page = 1;
      });

      // fetch 10 items
      fetchItems();
    });
  }

  // add 1 new item
  void _addItem() {
    if (!_isLoading) {
      addNewItem();
      _showSnackBar('Adding...');
    }
  }

  // delete 1 item
  void _deleteItem() {
    if (_items.isNotEmpty) {
      // get the first item from list
      final item = _items[0];

      // remove from index 0
      setState(() {
        _items.removeAt(0);
      });

      // animate the deletion
      _listkey.currentState?.removeItem(
        0,
        (context, animation) => _buildRemovedItem(item, animation),
        duration: const Duration(milliseconds: 300),
      );
    }
    _showSnackBar('Removed');
  }

  // snackbar component for displaying messages below
  void _showSnackBar(String message) {
    // prevent multiple snackbars being called when spammed
    if (_isSnackBarVisible) return;

    // snackbar visible while _showCustomSnackBar is called
    _isSnackBarVisible = true;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.fixed,
        duration: Duration(seconds: 1),
        content: Center(
          child: Text(
          message, 
          style: TextStyle(
            fontFamily: 'Montserrat', 
            fontWeight: FontWeight.w500,
            fontSize: 16
          )
        ),
        )
      )
    ).closed.then((_) {
      // resetting the flag after the snackbar disappears
      _isSnackBarVisible = false;
    });
  }

  // main screen widgets
  @override
  Widget build(BuildContext context) {
    // getting user's device screen height
    double screenHeight = MediaQuery.of(context).size.height;

    // checking if dark mode is on for theming some widgets
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.112), // top space

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    // changing logo src based on theme
                    image: isDarkMode ? AssetImage('assets/logoDark.png') : AssetImage('assets/logoLight.png'), 
                    width: 80, 
                    height: 80
                  ),
                  Text(
                    'EntryFlow',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 36,
                      color: AppColors.titleTextColor(Theme.of(context).brightness),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14), // spacer

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _refreshList,
                    icon: Icon(
                      Icons.refresh_rounded,
                      size: 26,
                      color: AppColors.refreshListColor(Theme.of(context).brightness),
                    ),
                  ),
                  IconButton(
                    onPressed: _isSearchMode ? null : _addItem,
                    icon: Icon(
                      Icons.add,
                      size: 30,
                      color: 
                        // pastel blue,
                        AppColors.addItemColor(Theme.of(context).brightness),
                    ),
                  ),
                  IconButton(
                    onPressed: _deleteItem,
                    icon: Icon(
                      Icons.delete,
                      size: 24,
                      color: 
                        // pastel pink
                        AppColors.deleteItemColor(Theme.of(context).brightness),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10), // spacer

              // sizedbox to set equal heights for search input and button
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    Expanded(
                      child: Material(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)
                        ),
                        elevation: 0,
                        // search input
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.searchInputTextColor(Theme.of(context).brightness),
                          ),
                          cursorColor: AppColors.searchInputCursorColor(Theme.of(context).brightness),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.searchInputFillColor(Theme.of(context).brightness),
                            labelText: 'Filter',
                            labelStyle: TextStyle(
                              color: AppColors.searchInputLabelColor(Theme.of(context).brightness),
                              fontWeight: FontWeight.w500
                            ),
                            iconColor: AppColors.searchInputIconColor(Theme.of(context).brightness),
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8)
                              ),
                              borderSide: BorderSide(color: AppColors.searchInputFocusedBorderSideColor(Theme.of(context).brightness)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8)
                              ),
                            ),
                          ),
                          onChanged: (text) {
                            // making search mode true while input field is being used, to effectively activate/disable the search button
                            setState(() {
                              _isSearchMode = text.isNotEmpty;
                            });
                          },
                        ),
                      )
                    ),

                    // container for button stroke
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.searchButtonBorderColor(Theme.of(context).brightness), width: 1),
                          bottom: BorderSide(color: AppColors.searchButtonBorderColor(Theme.of(context).brightness), width: 1),
                          right: BorderSide(color: AppColors.searchButtonBorderColor(Theme.of(context).brightness), width: 1),
                          left: BorderSide.none,
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8)
                        ),
                      ),
                      // search button
                      child: ElevatedButton(
                        // button is activated while the user is searching
                        onPressed: _isSearchMode ? _performSearch : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.searchButtonForegroundColor(Theme.of(context).brightness),
                          elevation: 0,
                          shape: RoundedRectangleBorder( // rounding the edges
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8)
                            ),
                          ),
                        ),
                        child: Icon(
                          _isSearchMode ? Icons.search_rounded : Icons.search_off,
                          color: _isSearchMode 
                          ? Color.fromARGB(255, 37, 37, 37) 
                          : AppColors.searchButtonIconColor(Theme.of(context).brightness),
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: AnimatedList(
                  key: _listkey,
                  controller: _scrollController,
                  initialItemCount: _items.length,
                  itemBuilder: (context, index, animation) {
                    if (index >= _items.length) {
                      // 0px box if the index is invalid
                      return const SizedBox.shrink();
                    }
                    final item = _items[index];
                    return _buildListItem(item, animation, index);
                  }
                ),
              ),  
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRemovedItem(Item item, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          color: AppColors.itemCardColor(Theme.of(context).brightness),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)
          ),
          child: ListTile(
            leading: CachedNetworkImage(
              // utils/custom_cache_manager.dart
              cacheManager: CustomCacheManager.getInstance(),
              imageUrl: item.image,
              width: 100,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => Padding(padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10), child: CircularProgressIndicator()), 
              errorWidget: (context, url, error) => Padding(padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10), child: Icon(Icons.error)),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)
            ),
            title: Text(
              item.title,
              style: TextStyle(
                color: AppColors.itemTitleTextColor(Theme.of(context).brightness)
              ),
            ),
            subtitle: Text(
              'Created at: ${DateFormat.yMMMMd().format(item.createdAt)}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.itemSubtitleTextColor(Theme.of(context).brightness)
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(Item item, Animation<double> animation, int index) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          color: AppColors.itemCardColor(Theme.of(context).brightness),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)
          ),
          child: ListTile(
            leading: CachedNetworkImage(
              // utils/custom_cache_manager.dart
              cacheManager: CustomCacheManager.getInstance(),
              imageUrl: item.image,
              width: 100,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => Padding(padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10), child: CircularProgressIndicator()), 
              errorWidget: (context, url, error) => Padding(padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10), child: Icon(Icons.error)),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)
            ),
            title: Text(
              item.title,
              style: TextStyle(
                color: AppColors.itemTitleTextColor(Theme.of(context).brightness)
              ),
            ),
            subtitle: Text(
              'Created at: ${DateFormat.yMMMMd().format(item.createdAt)}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.itemSubtitleTextColor(Theme.of(context).brightness)
              ),
            ),
          ),
        ),
      ),
    );
  }
}