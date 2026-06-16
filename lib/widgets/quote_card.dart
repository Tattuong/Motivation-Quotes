import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../models/app_theme_preset.dart';
import '../models/quote.dart';
import '../providers/shop_provider.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final String languageCode;
  final bool compact;
  final VoidCallback? onTap;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.languageCode,
    this.compact = false,
    this.onTap,
  });

  TextStyle _fontStyle(ShopProvider shop, {double size = 18, FontWeight weight = FontWeight.w600}) {
    return switch (shop.quoteFont) {
      'playfair' => GoogleFonts.playfairDisplay(fontSize: size, fontWeight: weight, height: 1.4),
      'lora' => GoogleFonts.lora(fontSize: size, fontWeight: weight, height: 1.4),
      'caveat' => GoogleFonts.caveat(fontSize: size + 4, fontWeight: weight, height: 1.3),
      _ => GoogleFonts.outfit(fontSize: size, fontWeight: weight, height: 1.4),
    };
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final skin = shop.activeSkin;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget card = Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 20 : 28),
      decoration: BoxDecoration(
        color: skin.overlayColor ?? (isDark ? AppColors.darkSurface : AppColors.surface),
        borderRadius: BorderRadius.circular(skin.borderRadius),
        border: skin.showBorder
            ? Border.all(color: Colors.white.withValues(alpha: isDark ? 0.15 : 0.5), width: 1.5)
            : null,
        boxShadow: skin.elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: skin.elevation * 4,
                  offset: Offset(0, skin.elevation),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!compact)
            Icon(Icons.format_quote_rounded, color: shop.activeTheme.primary.withValues(alpha: 0.7), size: 36),
          if (!compact) const SizedBox(height: 8),
          Text(
            quote.textFor(languageCode),
            style: _fontStyle(shop, size: compact ? 15 : 20, weight: FontWeight.w600),
          ),
          SizedBox(height: compact ? 12 : 20),
          Row(
            children: [
              Container(
                width: 32,
                height: 3,
                decoration: BoxDecoration(
                  gradient: shop.activeBackground.gradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  quote.authorFor(languageCode),
                  style: TextStyle(
                    fontSize: compact ? 12 : 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (skin.blur > 0) {
      card = ClipRRect(
        borderRadius: BorderRadius.circular(skin.borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: skin.blur, sigmaY: skin.blur),
          child: card,
        ),
      );
    }

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(skin.borderRadius),
          child: card,
        ),
      );
    }
    return card;
  }
}

class QuoteHeroBackground extends StatelessWidget {
  final Widget child;
  final QuoteBackground background;

  const QuoteHeroBackground({
    super.key,
    required this.child,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: background.gradient),
      child: child,
    );
  }
}
