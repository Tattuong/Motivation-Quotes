import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/locale_provider.dart';
import '../../providers/quotes_provider.dart';
import '../../providers/shop_provider.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/quote_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quotes = context.watch<QuotesProvider>();
    final shop = context.watch<ShopProvider>();
    final locale = context.watch<LocaleProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favorites = quotes.favoriteQuotes(locale.languageCode);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.t(context, 'favorites')),
        actions: [
          if (shop.hasExportFavorites && favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.file_download_outlined),
              onPressed: () async {
                final data = quotes.exportFavoritesJson();
                await Clipboard.setData(ClipboardData(text: data));
                if (context.mounted) {
                  AppToast.show(context, title: AppStrings.t(context, 'exportSuccess'));
                }
              },
            ),
        ],
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border_rounded, size: 64, color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text(AppStrings.t(context, 'noFavorites'), style: const TextStyle(color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.t(context, 'noFavoritesHint'),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.7), fontSize: 13),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final q = favorites[i];
                return Dismissible(
                  key: ValueKey(q.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.delete_outline, color: AppColors.error),
                  ),
                  onDismissed: (_) => quotes.toggleFavorite(q.id, hasUnlimitedFavorites: shop.hasUnlimitedFavorites),
                  child: QuoteCard(
                    quote: q,
                    languageCode: locale.languageCode,
                    compact: true,
                  ),
                );
              },
            ),
      bottomNavigationBar: !shop.hasUnlimitedFavorites
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppStrings.t(context, 'favoriteLimitInfo', {
                    'current': favorites.length.toString(),
                    'max': '15',
                  }),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
                ),
              ),
            )
          : null,
    );
  }
}
