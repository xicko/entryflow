import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager {
  static const cacheKey = "customCacheKey";

  static final CacheManager _customCacheManager = CacheManager(
    Config(
      cacheKey,
      // cache hiigdsen asset uud 7 honogiin daraa ustah
      stalePeriod: Duration(days: 7),
      // cache hiigdeh niit asset uudiin limit, shine asset cachelagdah uyd hamgiin huuchin n ustana
      maxNrOfCacheObjects: 100,
    ),
  );

  static CacheManager getInstance() {
    return _customCacheManager;
  }
}
