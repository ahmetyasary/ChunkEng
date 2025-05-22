import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String userName;
  const HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Seviye verisi örnek
    final levels = [
      {
        'title': 'Beginner',
        'level': 1,
        'color': const Color(0xFF536DFE),
        'status': 'done'
      },
      {
        'title': 'Beginner',
        'level': 2,
        'color': const Color(0xFFFFA726),
        'status': 'locked'
      },
      {
        'title': 'Beginner',
        'level': 3,
        'color': const Color(0xFFEF5350),
        'status': 'locked'
      },
      {
        'title': 'Beginner',
        'level': 4,
        'color': const Color(0xFF536DFE),
        'status': 'locked'
      },
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hello,',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Ahmet Yıldırım',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // İllüstrasyon (örnek olarak bir ikon)
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
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kartlar
                        Expanded(
                          child: Column(
                            children: List.generate(levels.length, (i) {
                              final level = levels[i];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: level['color'] as Color,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (level['color'] as Color)
                                          .withOpacity(0.18),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 18),
                                  title: Text(
                                    level['title'] as String,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Level ${level['level']}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        // Dikey çizgi ve ikonlar
                        Container(
                          margin:
                              const EdgeInsets.only(left: 8, right: 8, top: 8),
                          width: 32,
                          child: Column(
                            children: List.generate(levels.length, (i) {
                              final status = levels[i]['status'];
                              return Column(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: status == 'done'
                                          ? Colors.green
                                          : status == 'locked'
                                              ? Colors.orange.shade200
                                              : Colors.grey.shade300,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      status == 'done'
                                          ? Icons.check
                                          : Icons.lock,
                                      color: status == 'done'
                                          ? Colors.white
                                          : status == 'locked'
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
