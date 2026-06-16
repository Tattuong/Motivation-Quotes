import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/quote.dart';
import '../../providers/locale_provider.dart';
import '../../providers/quotes_provider.dart';
import '../../providers/shop_provider.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/quote_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _category = 'all';

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final quotes = context.watch<QuotesProvider>();
    final shop = context.watch<ShopProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categories = ['all', ...QuoteRepository.categories];
    final items = _category == 'all'
        ? QuoteRepository.all
        : QuoteRepository.byCategory(_category);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.t(context, 'explore')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = categories[i];
                final selected = _category == cat;
                return FilterChip(
                  selected: selected,
                  label: Text(AppStrings.t(context, cat == 'all' ? 'allCategories' : 'cat_$cat')),
                  onSelected: (_) => setState(() => _category = cat),
                  selectedColor: shop.activeTheme.primary.withValues(alpha: 0.2),
                  checkmarkColor: shop.activeTheme.primary,
                );
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final q = items[i];
                final isFav = quotes.isFavorite(q.id);
                return Stack(
                  children: [
                    QuoteCard(quote: q, languageCode: locale.languageCode, compact: true),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFav ? AppColors.accent : AppColors.onSurfaceVariant,
                        ),
                        onPressed: () async {
                          final wasFav = isFav;
                          final ok = await quotes.toggleFavorite(
                            q.id,
                            hasUnlimitedFavorites: shop.hasUnlimitedFavorites,
                          );
                          if (!context.mounted) return;
                          if (!ok) {
                            AppToast.show(context, title: AppStrings.t(context, 'favoriteLimitReached'), icon: Icons.lock_outline);
                            return;
                          }
                          if (!wasFav) await shop.rewardForFavorite();
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
