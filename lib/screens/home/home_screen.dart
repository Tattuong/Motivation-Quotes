import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/quote.dart';
import '../../providers/locale_provider.dart';
import '../../providers/quotes_provider.dart';
import '../../providers/shop_provider.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/coin_balance_chip.dart';
import '../../widgets/coin_purchase_sheet.dart';
import '../../widgets/quote_card.dart';
import '../main_shell.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Quote _todayQuote;

  @override
  void initState() {
    super.initState();
    _todayQuote = QuoteRepository.dailyQuote(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final quotes = context.read<QuotesProvider>();
    final locale = context.read<LocaleProvider>();
    await quotes.recordView(_todayQuote.id);
    await quotes.syncWidget(
      languageCode: locale.languageCode,
      quoteText: _todayQuote.textFor(locale.languageCode),
      authorText: _todayQuote.authorFor(locale.languageCode),
    );
    if (mounted) setState(() {});
  }

  Future<void> _toggleFavorite() async {
    final quotes = context.read<QuotesProvider>();
    final shop = context.read<ShopProvider>();
    final wasFavorite = quotes.isFavorite(_todayQuote.id);
    final ok = await quotes.toggleFavorite(
      _todayQuote.id,
      hasUnlimitedFavorites: shop.hasUnlimitedFavorites,
    );
    if (!mounted) return;
    if (!ok) {
      AppToast.show(context, title: AppStrings.t(context, 'favoriteLimitReached'), icon: Icons.lock_outline);
      MainShell.of(context)?.openShop();
      return;
    }
    if (!wasFavorite) await shop.rewardForFavorite();
    AppToast.show(
      context,
      title: AppStrings.t(context, wasFavorite ? 'removedFromFavorites' : 'addedToFavorites'),
      icon: wasFavorite ? Icons.favorite_border : Icons.favorite,
    );
  }

  Future<void> _shareQuote() async {
    final locale = context.read<LocaleProvider>();
    final shop = context.read<ShopProvider>();
    final text = _todayQuote.textFor(locale.languageCode);
    final author = _todayQuote.authorFor(locale.languageCode);
    final watermark = shop.hasNoWatermark
        ? ''
        : '\n\n— ${AppStrings.t(context, 'sharedVia')}';
    await Share.share('"$text"\n— $author$watermark');
    await shop.rewardForShare();
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final quotes = context.watch<QuotesProvider>();
    final locale = context.watch<LocaleProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFavorite = quotes.isFavorite(_todayQuote.id);
    final dateStr = DateFormat.yMMMMEEEEd(locale.languageCode).format(DateTime.now());

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: QuoteHeroBackground(
              background: shop.activeBackground,
              child: const SizedBox.expand(),
            ),
          ),
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.t(context, 'dailyQuote'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dateStr,
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      CoinBalanceChip(onTap: () => CoinPurchaseSheet.show(context)),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: QuoteCard(
                        quote: _todayQuote,
                        languageCode: locale.languageCode,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionBtn(
                        icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        label: AppStrings.t(context, 'favorite'),
                        color: isFavorite ? AppColors.accent : Colors.white,
                        onTap: _toggleFavorite,
                      ),
                      _ActionBtn(
                        icon: Icons.share_rounded,
                        label: AppStrings.t(context, 'share'),
                        color: Colors.white,
                        onTap: _shareQuote,
                      ),
                      _ActionBtn(
                        icon: Icons.refresh_rounded,
                        label: AppStrings.t(context, 'newQuote'),
                        color: Colors.white,
                        onTap: () {
                          setState(() {
                            final idx = QuoteRepository.all.indexWhere((q) => q.id == _todayQuote.id);
                            _todayQuote = QuoteRepository.all[(idx + 1) % QuoteRepository.all.length];
                          });
                          _init();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
