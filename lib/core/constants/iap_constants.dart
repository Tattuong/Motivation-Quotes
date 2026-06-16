class IapConstants {
  IapConstants._();

  static const String productPrefix = 'mq';

  static const String remoteConfigUrl = 'https://api2.blwsmartware.net/R214.json';

  static const Duration configTimeout = Duration(seconds: 10);

  static const List<String> coinPackIds = [
    'mq_pack_1',
    'mq_pack_2',
    'mq_pack_3',
    'mq_pack_4',
    'mq_pack_5',
    'mq_pack_6',
    'mq_pack_7',
    'mq_pack_8',
    'mq_pack_9',
    'mq_pack_10',
  ];

  static const String removeAdsProductId = 'mq_remove_ads';

  static List<String> get allProductIds => [...coinPackIds, removeAdsProductId];

  static const List<int> coinPackAmounts = [
    50,
    100,
    200,
    350,
    500,
    750,
    1000,
    1500,
    2200,
    3000,
  ];

  static int coinsForProduct(String productId) {
    final index = coinPackIds.indexOf(productId);
    if (index < 0) return 0;
    return coinPackAmounts[index];
  }

  static bool isRemoveAdsProduct(String productId) => productId == removeAdsProductId;

  static const int freeFavoriteLimit = 15;
  static const int dailyLoginReward = 10;
  static const int favoriteQuoteReward = 5;
  static const int maxFavoriteRewardsPerDay = 5;
  static const int shareQuoteReward = 5;
  static const int maxShareRewardsPerDay = 3;
}
