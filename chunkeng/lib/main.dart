import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:async';
import 'home_page.dart';
import 'settings_page.dart';

void main() {
  runApp(const ChunkEngApp());
}

class ChunkEngApp extends StatelessWidget {
  const ChunkEngApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChunkEng',
      debugShowCheckedModeBanner: false,
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
      home: const ChunkEngHomePage(),
    );
  }
}

class ChunkEngHomePage extends StatefulWidget {
  const ChunkEngHomePage({super.key});

  @override
  State<ChunkEngHomePage> createState() => _ChunkEngHomePageState();
}

class _ChunkEngHomePageState extends State<ChunkEngHomePage> {
  List<Map<String, String>> chunks = [];
  bool isLoading = true;
  int currentIndex = 0;
  int timerSeconds = 10;
  Timer? _timer;
  bool isPaused = false;
  int _selectedTab = 1; // 0: Anasayfa, 1: Öğren, 2: Eğitimim, 3: Ayarlar
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
                  title: const Text('Anlamı'),
                  content: Text(
                      chunks[currentIndex]['turkish'] ?? 'Anlamı bulunamadı.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Kapat'),
                    ),
                  ],
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'İngilizcesi sesli okundu: ${chunks[currentIndex]['english'] ?? ''} (örnek)')),
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
    if (currentIndex < chunks.length - 1) {
      setState(() {
        currentIndex++;
      });
      startTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tebrikler! Tüm kelimeleri bitirdiniz.')),
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
    final total = chunks.length;
    final left = total - currentIndex;
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _selectedTab == 0
                ? const HomePage(userName: 'Sufi Ahmed')
                : _selectedTab == 3
                    ? const SettingsPage()
                    : _selectedTab == 2
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Tekrar Listem',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Color(0xFF5D4037),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: reviewList.isEmpty
                                    ? const Center(
                                        child: Text('Tekrar listesi boş.'))
                                    : ListView.builder(
                                        itemCount: reviewList.length,
                                        itemBuilder: (context, index) {
                                          final word = reviewList[index];
                                          return Card(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            child: ListTile(
                                              title: Text(word['english'] ?? '',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              subtitle:
                                                  Text(word['turkish'] ?? ''),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.green,
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        reviewList
                                                            .removeAt(index);
                                                      });
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'Kelime öğrenildi ve listeden çıkarıldı.')),
                                                      );
                                                    },
                                                    child:
                                                        const Text('Öğrendim'),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.orange,
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      if (index <
                                                          reviewList.length -
                                                              1) {
                                                        setState(() {
                                                          // Sadece bir sonraki kelimeye geç, listeden silme
                                                          reviewList.add(
                                                              reviewList
                                                                  .removeAt(
                                                                      index));
                                                        });
                                                      }
                                                    },
                                                    child: const Text('Geç'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          color: Color(0xFF5D4037)),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Ana ekrana dönüldü (örnek).')),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    const Expanded(
                                      child: Text(
                                        'Kelime Öğren',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Color(0xFF5D4037),
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
                                        backgroundColor:
                                            const Color(0xFFFF8A65),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 8),
                                      ),
                                      onPressed: pauseOrResumeTimer,
                                      child: Text(
                                        isPaused ? 'Başlat' : 'Duraklat',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 4),
                                child: Row(
                                  children: [
                                    Text(
                                      '${currentIndex + 1} | $total',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF8D6E63),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: (currentIndex + 1) /
                                            (total == 0 ? 1 : total),
                                        minHeight: 8,
                                        backgroundColor:
                                            const Color(0xFFFFCCBC),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xFFFF7043)),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
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
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                                onTap: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Ses çalındı (örnek).')),
                                                  );
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Icon(
                                                      Icons.volume_up_rounded,
                                                      color: Colors.white,
                                                      size: 28),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 0,
                                            child: Text(
                                              'Yeni Kelime',
                                              style: TextStyle(
                                                color: Colors.grey.shade400,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              chunks[currentIndex]['english'] ??
                                                  '',
                                              style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF263238),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF536DFE),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                        ),
                                        onPressed: () {
                                          nextWord();
                                        },
                                        icon: const Icon(Icons.check, size: 22),
                                        label: const Text('Biliyordum',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFFFB300),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                        ),
                                        onPressed: () {
                                          addToReviewList(chunks[currentIndex]);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Tekrar listesine eklendi (örnek).')),
                                          );
                                        },
                                        icon: const Icon(Icons.star, size: 22),
                                        label: const Text('Tekrarla',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFE57373),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Anlamı'),
                                              content: Text(chunks[currentIndex]
                                                      ['turkish'] ??
                                                  'Anlamı bulunamadı.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('Kapat'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.visibility,
                                            size: 22),
                                        label: const Text('Anlamı Gör',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) {
          setState(() {
            _selectedTab = index;
            if (index != 1) {
              timerSeconds = 10;
              isPaused = true;
            }
          });
          if (index == 1) return; // Zaten Öğren sekmesindeyiz
          String mesaj = '';
          switch (index) {
            case 0:
              mesaj = 'Anasayfa sekmesine tıklandı (örnek).';
              break;
            case 2:
              mesaj = '';
              break;
            case 3:
              mesaj = 'Ayarlar sekmesine tıklandı (örnek).';
              break;
          }
          if (mesaj.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(mesaj)),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF7043),
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFFFFF3E0),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Öğren',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_rounded),
            label: 'Eğitimim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Ayarlar',
          ),
        ],
      ),
    );
  }
}
