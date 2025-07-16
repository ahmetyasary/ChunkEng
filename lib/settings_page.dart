import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  String _getThemeDisplayName(ThemeMode themeMode, AppLocalizations l10n) {
    switch (themeMode) {
      case ThemeMode.light:
        return l10n.light;
      case ThemeMode.dark:
        return l10n.dark;
      case ThemeMode.system:
        return l10n.system;
    }
  }

  void _showThemeDialog(BuildContext context, AppLocalizations l10n,
      ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.themeSelection),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: themeProvider.getSupportedThemes().map((theme) {
            return ListTile(
              title:
                  Text(_getThemeDisplayName(theme['mode'] as ThemeMode, l10n)),
              trailing: themeProvider.currentThemeMode == theme['mode']
                  ? const Icon(Icons.check, color: Color(0xFFFF7043))
                  : null,
              onTap: () {
                themeProvider.setThemeMode(theme['mode'] as ThemeMode);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, AppLocalizations l10n,
      LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.languageSelection),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languageProvider.getSupportedLanguages().map((language) {
            return ListTile(
              title: Text(language['name']!),
              trailing: languageProvider.currentLocale.languageCode ==
                      language['code']
                  ? const Icon(Icons.check, color: Color(0xFFFF7043))
                  : null,
              onTap: () {
                languageProvider.setLanguage(language['code']!);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            // Profil fotoğrafı ve isim
            CircleAvatar(
              radius: 44,
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/men/32.jpg',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ahmet Yıldırım',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 32),
            // Tema seçimi
            ListTile(
              leading: const Icon(Icons.color_lens_rounded,
                  color: Color(0xFFFF7043)),
              title: Text(l10n.theme,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              trailing: Text(
                  _getThemeDisplayName(themeProvider.currentThemeMode, l10n),
                  style: const TextStyle(color: Colors.grey)),
              onTap: () {
                _showThemeDialog(context, l10n, themeProvider);
              },
            ),
            // Dil seçimi
            ListTile(
              leading:
                  const Icon(Icons.language_rounded, color: Color(0xFFFF7043)),
              title: Text(l10n.language,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              trailing: Text(
                  languageProvider.getLanguageName(
                      languageProvider.currentLocale.languageCode),
                  style: const TextStyle(color: Colors.grey)),
              onTap: () {
                _showLanguageDialog(context, l10n, languageProvider);
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
                  Text(l10n.version,
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6))),
                  const SizedBox(height: 4),
                  Text(l10n.designedBy,
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                          fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
