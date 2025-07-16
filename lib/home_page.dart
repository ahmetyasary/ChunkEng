import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/progress_provider.dart';
import 'learn_page.dart';

class HomePage extends StatelessWidget {
  final String userName;
  const HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final progressProvider = Provider.of<ProgressProvider>(context);
    final currentCategory = progressProvider.userProgress.currentCategory;
    final levels = progressProvider.getLevelsForCategory(currentCategory);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık kısmı
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.hello,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.87),
                          ),
                        ),
                        Text(
                          'Ahmet Yıldırım',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // İllüstrasyon
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: Image.network(
                        'https://img.icons8.com/color/96/reading.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Seviye kartları
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kartlar
                  Expanded(
                    child: Column(
                      children: List.generate(levels.length, (i) {
                        final level = levels[i];
                        final isUnlocked = level['isUnlocked'] as bool;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: isUnlocked
                                ? (level['color'] as Color)
                                : (level['color'] as Color).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: (level['color'] as Color)
                                    .withOpacity(isUnlocked ? 0.18 : 0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 18),
                            title: Text(
                              progressProvider.getCategoryDisplayName(
                                  level['title'] as String),
                              style: TextStyle(
                                color: isUnlocked
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              '${l10n.level} ${level['subLevel']}',
                              style: TextStyle(
                                color: isUnlocked
                                    ? Colors.white70
                                    : Colors.white.withOpacity(0.3),
                                fontSize: 16,
                              ),
                            ),
                            onTap: isUnlocked
                                ? () {
                                    // Kelime öğrenme sayfasına yönlendir
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const LearnPage(),
                                      ),
                                    );
                                  }
                                : null,
                          ),
                        );
                      }),
                    ),
                  ),

                  // Dikey çizgi ve ikonlar
                  Container(
                    margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    width: 32,
                    child: Column(
                      children: List.generate(levels.length, (i) {
                        final status = levels[i]['status'];
                        final isUnlocked = levels[i]['isUnlocked'] as bool;
                        return Column(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: status == 'done'
                                    ? Colors.green
                                    : status == 'current'
                                        ? Colors.blue
                                        : isUnlocked
                                            ? Colors.orange.shade200
                                            : Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                status == 'done'
                                    ? Icons.check
                                    : status == 'current'
                                        ? Icons.play_arrow
                                        : Icons.lock,
                                color: status == 'done'
                                    ? Colors.white
                                    : status == 'current'
                                        ? Colors.white
                                        : isUnlocked
                                            ? Colors.orange
                                            : Colors.grey,
                                size: 18,
                              ),
                            ),
                            if (i != levels.length - 1)
                              Container(
                                width: 2,
                                height: 48,
                                color: Colors.grey.shade300,
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
