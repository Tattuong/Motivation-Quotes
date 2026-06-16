import 'package:flutter/foundation.dart';

import '../core/constants/iap_constants.dart';
import '../core/services/storage_service.dart';
import '../core/services/widget_service.dart';
import '../models/quote.dart';

class QuotesProvider extends ChangeNotifier {
  static const _favoritesKey = 'mq_favorites';
  static const _historyKey = 'mq_history';

  Set<String> _favorites = {};
  List<String> _history = [];
  bool _loaded = false;

  Set<String> get favorites => _favorites;
  List<String> get history => List.unmodifiable(_history);
  bool get isLoaded => _loaded;

  Future<void> load() async {
    final fav = await StorageService.instance.getStringList(_favoritesKey);
    _favorites = fav?.toSet() ?? {};
    final hist = await StorageService.instance.getStringList(_historyKey);
    _history = hist ?? [];
    _loaded = true;
    notifyListeners();
  }

  Quote dailyQuote(DateTime date) => QuoteRepository.dailyQuote(date);

  Quote? quoteById(String id) => QuoteRepository.find(id);

  List<Quote> favoriteQuotes(String languageCode) {
    return _favorites
        .map(QuoteRepository.find)
        .whereType<Quote>()
        .toList();
  }

  bool isFavorite(String id) => _favorites.contains(id);

  bool canAddFavorite({required bool hasUnlimitedFavorites}) {
    if (hasUnlimitedFavorites) return true;
    return _favorites.length < IapConstants.freeFavoriteLimit;
  }

  Future<bool> toggleFavorite(String id, {required bool hasUnlimitedFavorites}) async {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
      await _save();
      notifyListeners();
      return true;
    }
    if (!canAddFavorite(hasUnlimitedFavorites: hasUnlimitedFavorites)) {
      return false;
    }
    _favorites.add(id);
    await _save();
    notifyListeners();
    return true;
  }

  Future<void> recordView(String id) async {
    _history.remove(id);
    _history.insert(0, id);
    if (_history.length > 50) _history = _history.take(50).toList();
    await StorageService.instance.saveStringList(_historyKey, _history);
    notifyListeners();
  }

  Future<void> syncWidget({
    required String languageCode,
    required String quoteText,
    required String authorText,
  }) async {
    await WidgetService.updateDailyQuote(
      quote: quoteText,
      author: authorText,
    );
  }

  String exportFavoritesJson() {
    final quotes = favoriteQuotes('en');
    final buffer = StringBuffer('[\n');
    for (var i = 0; i < quotes.length; i++) {
      final q = quotes[i];
      buffer.write('  {"id":"${q.id}","text":"${q.textEn.replaceAll('"', '\\"')}","author":"${q.authorEn}"}');
      if (i < quotes.length - 1) buffer.write(',');
      buffer.write('\n');
    }
    buffer.write(']');
    return buffer.toString();
  }

  Future<void> _save() async {
    await StorageService.instance.saveStringList(_favoritesKey, _favorites.toList());
  }
}
