import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
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
            const Text(
              'Ahmet Yıldırım',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 32),
            // Tema seçimi
            ListTile(
              leading: const Icon(Icons.color_lens_rounded,
                  color: Color(0xFFFF7043)),
              title: const Text('Tema',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              trailing:
                  const Text('Açık', style: TextStyle(color: Colors.grey)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Tema Seçimi'),
                    content:
                        const Text('Tema seçimi burada yapılacak (örnek).'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Kapat'),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Dil seçimi
            ListTile(
              leading:
                  const Icon(Icons.language_rounded, color: Color(0xFFFF7043)),
              title: const Text('Dil',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              trailing:
                  const Text('Türkçe', style: TextStyle(color: Colors.grey)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Dil Seçimi'),
                    content: const Text('Dil seçimi burada yapılacak (örnek).'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Kapat'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: const [
                  Text('v1.0.0', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 4),
                  Text('designed by smartlogy',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
