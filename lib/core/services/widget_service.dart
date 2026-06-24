import 'package:home_widget/home_widget.dart';

class WidgetService {
  WidgetService._();

  static const _appGroupId = 'group.com.motivationquotesmng.motivationquotes';
  static const _quoteKey = 'daily_quote';
  static const _authorKey = 'daily_author';
  static const _androidWidgetName = 'QuoteWidgetProvider';

  static Future<void> init() async {
    try {
      await HomeWidget.setAppGroupId(_appGroupId);
    } catch (_) {}
  }

  static Future<void> updateDailyQuote({
    required String quote,
    required String author,
  }) async {
    try {
      await HomeWidget.saveWidgetData<String>(_quoteKey, quote);
      await HomeWidget.saveWidgetData<String>(_authorKey, author);
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: 'QuoteWidget',
      );
    } catch (_) {}
  }
}
