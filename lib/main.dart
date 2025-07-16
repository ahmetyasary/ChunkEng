import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'education_page.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/progress_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => ProgressProvider()),
      ],
      child: const ChunkEngApp(),
    ),
  );
}

class ChunkEngApp extends StatelessWidget {
  const ChunkEngApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, ThemeProvider>(
      builder: (context, languageProvider, themeProvider, child) {
        return MaterialApp(
          title: 'ChunkEng',
          debugShowCheckedModeBanner: false,
          locale: languageProvider.currentLocale,
          themeMode: themeProvider.currentThemeMode,
          supportedLocales: const [
            Locale('tr'), // Türkçe
            Locale('en'), // İngilizce
            Locale('de'), // Almanca
            Locale('sq'), // Arnavutça
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFF7043),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            cardTheme: CardTheme(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            scaffoldBackgroundColor: const Color(0xFFFFF3E0),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFF7043),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            cardTheme: CardTheme(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
          ),
          home: const ChunkEngHomePage(),
        );
      },
    );
  }
}

class ChunkEngHomePage extends StatefulWidget {
  const ChunkEngHomePage({super.key});

  @override
  State<ChunkEngHomePage> createState() => _ChunkEngHomePageState();
}

class _ChunkEngHomePageState extends State<ChunkEngHomePage> {
  int _selectedTab = 0; // 0: Anasayfa, 1: Öğren, 2: Eğitimim, 3: Ayarlar

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: _selectedTab == 0
            ? const HomePage(userName: 'Sufi Ahmed')
            : _selectedTab == 3
                ? const SettingsPage()
                : _selectedTab == 2
                    ? const EducationPage()
                    : const Center(
                        child: Text('Öğren sayfası - Seviye seçimi yapın'),
                      ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF7043),
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book_rounded),
            label: l10n.learn,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.school_rounded),
            label: l10n.myEducation,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_rounded),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
