import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager {
  static const cacheKey = "customCacheKey";

  static final CacheManager _customCacheManager = CacheManager(
    Config(
      cacheKey,
      // setting custom stalePeriod, caches are auto-cleaned after 7 days
      stalePeriod: Duration(days: 7),
      // setting the number of max cached objects, oldest is cleaned to make way for the new
      maxNrOfCacheObjects: 100,
    ),
  );

  static CacheManager getInstance() {
    return _customCacheManager;
  }
}
