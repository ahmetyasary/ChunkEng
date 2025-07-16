import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:async';
import 'providers/progress_provider.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({Key? key}) : super(key: key);

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  List<Map<String, String>> chunks = [];
  bool isLoading = true;
  int currentIndex = 0;
  int timerSeconds = 10;
  Timer? _timer;
  bool isPaused = false;
  List<Map<String, String>> reviewList = [];

  @override
  void initState() {
    super.initState();
    loadChunks();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer?.cancel();
    setState(() {
      timerSeconds = 10;
      isPaused = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final l10n = AppLocalizations.of(context)!;
      if (!isPaused) {
        if (timerSeconds > 0) {
          setState(() {
            timerSeconds--;
          });
          if (timerSeconds == 0) {
            // Anlamı göster ve İngilizcesini sesli oku (simülasyon)
            Future.delayed(const Duration(milliseconds: 300), () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.meaning),
                  content: Text(
                      chunks[currentIndex]['turkish'] ?? 'Anlamı bulunamadı.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.close),
                    ),
                  ],
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(l10n.englishPronunciation(
                        chunks[currentIndex]['english'] ?? ''))),
              );
            });
          }
        } else {
          timer.cancel();
        }
      }
    });
  }

  void pauseOrResumeTimer() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  void nextWord() {
    final l10n = AppLocalizations.of(context)!;
    final progressProvider =
        Provider.of<ProgressProvider>(context, listen: false);

    // Mevcut kelimeyi tamamlanan olarak ekle
    final currentWord = chunks[currentIndex]['english'] ?? '';
    if (currentWord.isNotEmpty) {
      progressProvider.addCompletedWord(currentWord);
    }

    if (currentIndex < chunks.length - 1) {
      setState(() {
        currentIndex++;
      });
      startTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${l10n.congratulations} ${l10n.allWordsCompleted}')),
      );
      _timer?.cancel();
    }
  }

  Future<void> loadChunks() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/chunks.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> chunksList = jsonData['chunks'];
      setState(() {
        chunks =
            chunksList.map((chunk) => Map<String, String>.from(chunk)).toList();
        isLoading = false;
      });
      if (chunks.isNotEmpty) {
        startTimer();
      }
    } catch (e) {
      print('Error loading chunks: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Color getTimerColor() {
    if (timerSeconds >= 6) {
      return Colors.green;
    } else if (timerSeconds >= 1) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  void addToReviewList(Map<String, String> word) {
    if (!reviewList.any((item) => item['english'] == word['english'])) {
      setState(() {
        reviewList.add(word);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final total = chunks.length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios_new_rounded,
                              color: Theme.of(context).colorScheme.onSurface),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.learn,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: getTimerColor(),
                            child: Text(
                              timerSeconds.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF8A65),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                          ),
                          onPressed: pauseOrResumeTimer,
                          child: Text(
                            isPaused ? l10n.start : l10n.pause,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          '${currentIndex + 1} | $total',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: LinearProgressIndicator(
                            value:
                                (currentIndex + 1) / (total == 0 ? 1 : total),
                            minHeight: 8,
                            backgroundColor: const Color(0xFFFFCCBC),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                const Color(0xFFFF7043)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Center(
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: 320,
                          padding: const EdgeInsets.all(24),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Material(
                                  color: const Color(0xFF7E57C2),
                                  shape: const CircleBorder(),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(24),
                                    onTap: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Ses çalındı (örnek).')),
                                      );
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.volume_up_rounded,
                                          color: Colors.white, size: 28),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 0,
                                child: Text(
                                  l10n.newWord,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.4),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  chunks[currentIndex]['english'] ?? '',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF536DFE),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {
                              nextWord();
                            },
                            icon: const Icon(Icons.check, size: 22),
                            label: Text(l10n.iKnow,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFB300),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {
                              addToReviewList(chunks[currentIndex]);
                              final progressProvider =
                                  Provider.of<ProgressProvider>(context,
                                      listen: false);
                              final currentWord =
                                  chunks[currentIndex]['english'] ?? '';
                              if (currentWord.isNotEmpty) {
                                progressProvider.addLearnedWord(currentWord);
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Tekrar listesine eklendi (örnek).')),
                              );
                            },
                            icon: const Icon(Icons.star, size: 22),
                            label: Text(l10n.repeat,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE57373),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(l10n.meaning),
                                  content: Text(chunks[currentIndex]
                                          ['turkish'] ??
                                      'Anlamı bulunamadı.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(l10n.close),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.visibility, size: 22),
                            label: Text(l10n.seeMeaning,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
