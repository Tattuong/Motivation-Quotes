import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/locale_provider.dart';
import '../../providers/shop_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/coin_balance_chip.dart';
import '../../widgets/coin_purchase_sheet.dart';
import '../main_shell.dart';
import '../privacy_policy_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final theme = context.watch<ThemeProvider>();
    final locale = context.watch<LocaleProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.t(context, 'settingsTitle')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CoinBalanceChip(onTap: () => CoinPurchaseSheet.show(context)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle(AppStrings.t(context, 'activeCustomization')),
          _InfoTile(
            icon: Icons.palette_outlined,
            title: AppStrings.t(context, 'activeTheme'),
            subtitle: AppStrings.t(context, _themeNameKey(shop.activeThemeId)),
          ),
          _InfoTile(
            icon: Icons.layers_outlined,
            title: AppStrings.t(context, 'activeBackground'),
            subtitle: AppStrings.t(context, _bgNameKey(shop.activeBackgroundId)),
          ),
          _InfoTile(
            icon: Icons.style_outlined,
            title: AppStrings.t(context, 'activeSkin'),
            subtitle: AppStrings.t(context, _skinNameKey(shop.activeSkinId)),
          ),
          const SizedBox(height: 16),
          _SectionTitle(AppStrings.t(context, 'appearance')),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: Text(AppStrings.t(context, 'darkMode')),
            value: theme.isDarkMode,
            onChanged: (_) => theme.toggleTheme(),
          ),
          ListTile(
            leading: const Icon(Icons.font_download_outlined),
            title: Text(AppStrings.t(context, 'quoteFont')),
            subtitle: Text(_fontLabel(context, shop.quoteFont)),
            trailing: shop.hasPremiumFonts ? const Icon(Icons.chevron_right) : const Icon(Icons.lock_outline, size: 18),
            onTap: shop.hasPremiumFonts ? () => _pickFont(shop) : () => MainShell.of(context)?.openShop(),
          ),
          if (shop.hasCustomNotification)
            ListTile(
              leading: const Icon(Icons.notifications_active_outlined),
              title: Text(AppStrings.t(context, 'notificationHour')),
              subtitle: Text('${shop.notificationHour}:00'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _pickNotificationHour(shop),
            )
          else
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: Text(AppStrings.t(context, 'notificationHour')),
              subtitle: Text(AppStrings.t(context, 'notificationLocked')),
              trailing: const Icon(Icons.lock_outline, size: 18),
              onTap: () => MainShell.of(context)?.openShop(),
            ),
          const SizedBox(height: 16),
          _SectionTitle(AppStrings.t(context, 'other')),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(AppStrings.t(context, 'language')),
            subtitle: Text(locale.isVietnamese ? AppStrings.t(context, 'vietnamese') : AppStrings.t(context, 'english')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pickLanguage(locale),
          ),
          ListTile(
            leading: const Icon(Icons.widgets_outlined),
            title: Text(AppStrings.t(context, 'widgetInfo')),
            subtitle: Text(
              shop.hasWidgetStyles
                  ? AppStrings.t(context, 'widgetInfoDesc')
                  : AppStrings.t(context, 'widgetStylesLocked'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.stars_outlined),
            title: Text(AppStrings.t(context, 'openShop')),
            subtitle: Text(AppStrings.t(context, 'openShopDesc')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => MainShell.of(context)?.openShop(),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(AppStrings.t(context, 'privacyPolicy')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              AppStrings.t(context, 'copyright'),
              style: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.6), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickLanguage(LocaleProvider locale) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 22)),
              title: Text(AppStrings.t(context, 'english')),
              trailing: !locale.isVietnamese ? const Icon(Icons.check_rounded, color: AppColors.primary) : null,
              onTap: () async {
                await locale.setEnglish();
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Text('🇻🇳', style: TextStyle(fontSize: 22)),
              title: Text(AppStrings.t(context, 'vietnamese')),
              trailing: locale.isVietnamese ? const Icon(Icons.check_rounded, color: AppColors.primary) : null,
              onTap: () async {
                await locale.setVietnamese();
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _themeNameKey(String id) => switch (id) {
        'theme_sunset' => 'shopThemeSunset',
        'theme_midnight' => 'shopThemeMidnight',
        'theme_tropical' => 'shopThemeTropical',
        'theme_sakura' => 'shopThemeSakura',
        _ => 'shopThemeSunset',
      };

  String _bgNameKey(String id) => switch (id) {
        'bg_sunrise' => 'shopBgSunrise',
        'bg_ocean' => 'shopBgOcean',
        'bg_aurora' => 'shopBgAurora',
        'bg_galaxy' => 'shopBgGalaxy',
        _ => 'shopBgSunrise',
      };

  String _skinNameKey(String id) => switch (id) {
        'skin_glass' => 'shopSkinGlass',
        'skin_minimal' => 'shopSkinMinimal',
        'skin_elegant' => 'shopSkinElegant',
        _ => 'shopSkinGlass',
      };

  String _fontLabel(BuildContext context, String font) {
    if (!context.read<ShopProvider>().hasPremiumFonts && font != 'outfit') {
      return AppStrings.t(context, 'fontsLocked');
    }
    return switch (font) {
      'playfair' => AppStrings.t(context, 'fontPlayfair'),
      'lora' => AppStrings.t(context, 'fontLora'),
      'caveat' => AppStrings.t(context, 'fontCaveat'),
      _ => AppStrings.t(context, 'fontOutfit'),
    };
  }

  Future<void> _pickFont(ShopProvider shop) async {
    const fonts = ['outfit', 'playfair', 'lora', 'caveat'];
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: fonts.map((f) {
            return ListTile(
              title: Text(_fontLabel(context, f)),
              trailing: shop.quoteFont == f ? const Icon(Icons.check_rounded, color: AppColors.primary) : null,
              onTap: () async {
                await shop.setQuoteFont(f);
                if (ctx.mounted) Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _pickNotificationHour(ShopProvider shop) async {
    var hour = shop.notificationHour;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.t(context, 'notificationHour')),
        content: StatefulBuilder(
          builder: (_, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$hour:00', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
              Slider(
                value: hour.toDouble(),
                min: 0,
                max: 23,
                divisions: 23,
                label: '$hour:00',
                onChanged: (v) => setState(() => hour = v.round()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppStrings.t(context, 'cancel'))),
          FilledButton(
            onPressed: () async {
              await shop.setNotificationHour(hour);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text(AppStrings.t(context, 'save')),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.onSurfaceVariant)),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoTile({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
    );
  }
}
